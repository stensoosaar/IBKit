/*
 MIT License

 Copyright (c) 2016-2025 Sten Soosaar

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


import Foundation
import Combine
import TWS

/**
 Interactive Brokers client that manages connection, authentication, and communication with TWS or IB Gateway.

 This class provides a high-level interface for connecting to Interactive Brokers' Trading Workstation (TWS)
 or IB Gateway. It handles connection management, automatic reconnection, request ID generation, and
 account management.

 ## Usage
 ```swift
 let client = IBClient(id: 1, host: "127.0.0.1", port: 4002)
 client.connect()
 ```

 ## Connection States
 The client automatically manages connection states and provides reconnection capabilities
 with configurable intervals and maximum attempts.
 */
open class IBClient {
	
	/// Unique application identifier used to distinguish this client from others connected to the same TWS/Gateway instance
	public let id: Int

	/// The underlying socket connection to TWS/Gateway
	private var connection: IBConnection
	
	/**
	 Publisher that emits all responses received from the TWS/Gateway
	 
	 Subscribe to this publisher to receive market data, order updates, account information, and other responses.
	 The publisher is shared, meaning multiple subscribers will receive the same events.
	 */
	public private(set) lazy var responses = connection.responseSubject.share().eraseToAnyPublisher()
	
	/// Set of cancellables for managing Combine subscriptions
	private var cancellables: Set<AnyCancellable> = []
	
	/// Array of managed accounts available for the current session
	public private(set) var managedAccounts: [Account] = []
	
	/**
	 Interval between request transmissions in milliseconds
	
	 This property controls the pacing of requests sent to TWS/Gateway to avoid overwhelming the server.
	 Interactive Brokers has rate limits, and this helps ensure compliance.
	
	 Default value is 20 milliseconds. You can reduce it further by purchasing Booster Pack or generate fees.
	 
	 - Important: by sending more than 50 orders in second, some orders might cached causing failure to attach parent-child relationships with bracket orders.
	 */
	public var requstPacingInterval: Int = 20 {
		willSet{
			connection.requstPacintInterval = newValue
		}
	}

	/**
	 Creates a new Interactive Brokers (IB) connection object to a TWS workstation or IB Gateway instance.
	 - parameter id: unique application id, must not conflict with other connected clients.
	 - parameter host: the hostname or IP address to connect to (default is `127.0.0.1` for localhost)
	 - parameter port: the port number to connect to (should match your TWS or Gateway API port).
	 
	 You must have either Trader Workstation (TWS) or IB Gateway running and configured to accept API connections.
	 The `port` must match the settings in your running TWS or Gateway session:
	 * **Workstation**: `7496 live` and `7497 paper trading`
	 * **Gateway**: `4001 live`and `4002 paper trading`
	 */
	public init(id: Int, host: String = "127.0.0.1", port: UInt16 = 4002) {
		self.id = id
		self.connection = IBConnection(host: host, port: port)
	}

	
	/// Enables or disables debug mode for detailed logging
	public var debugMode: Bool = false {
		willSet{
			self.connection.debugMode = newValue
		}
	}
	
	/**
	 Current connection state
	
	 - Returns: The current state of the underlying connection
	*/
	public var state: IBConnection.State {
		connection.state.value
	}
	
	
	/**
	Establishes connection to TWS/Gateway and initiates the API handshake
	
	This method starts the connection process, which includes:
	1. Establishing TCP connection to TWS/Gateway
	2. Performing API handshake
	3. Starting the API with the specified client ID
	4. Retrieving next valid request ID
	5. Getting managed account identifiers
	
	Monitor the `state` property or `responses` publisher to track connection progress and handle events.
	*/
	public func connect() {
		
		connection.state
			.filter { state in
				if case .connected = state { return true }
				return false
			}
			.prefix(1)
			.flatMap { [weak self] _ -> AnyPublisher<IBEvent, Never> in
				guard let self = self else { return Empty().eraseToAnyPublisher() }
				print("Connection established. Starting API for client \(self.id)")
				return self.startAPI(id: self.id)
			}
			.sink { [weak self] event in
				switch event {
				case let temp as NextRequestID:
					self?._nextRequestID.send(temp.value)
					print("􀃲 Next request id: \(temp.value)")
					if self?.managedAccounts.isEmpty == false {
						self?.onConnection()
					}

				case let temp as ManagedAccounts:
					self?.setupAccounts(identifiers: temp.identifiers)
					if self?._nextRequestID.value != -1 {
						self?.onConnection()
					}
					
				default:
					print("􀇾 Unhandled event: \(event)")
					break
				}
			}
			.store(in: &cancellables)
		
		
		connection.state
			.removeDuplicates()
			.sink { [weak self] state in
				if case .failed(let error) = state {
					print("􀇾 Connection lost due \(error). Starting reconnection loop...")
					DispatchQueue.main.async {
						self?.reconnect()
					}
				}
			}
			.store(in: &cancellables)

		currentReconnectionAttempt = 0
		connection.start()

	}
	
	/// Disconnects from TWS/Gateway and cleans up resources
	public func disconnect() {
		timer?.invalidate()
		timer = nil
		connection.stop()
		cancellables.removeAll()
		managedAccounts.removeAll()
		_nextRequestID.send(-1)
	}


	/// Reconnection
	
	/// Time interval between reconnection attempts in seconds
	public var reconnectInterval: TimeInterval = 30
	
	/// Maximum number of reconnection attempts before giving up
	public var maxReconnectAttempts: Int = 100
	
	/// Current number of reconnection attempts made
	private var currentReconnectionAttempt:Int = 0

	/// Timer used for automatic reconnection attempts
	private var timer: Timer? = nil

	/**
	 Initiates automatic reconnection process
		
	 TWS
	
	
	 This method starts a timer that periodically attempts to reconnect to TWS/Gateway.
	 It will continue attempting reconnection until either:
	 - Connection is successfully established
	 - Maximum number of attempts is reached
	 - The connection is manually stopped
	*/
	private func reconnect() {
				
		timer = Timer.scheduledTimer(withTimeInterval: reconnectInterval, repeats: true) { [weak self] timer in
			guard let self = self else {
				timer.invalidate()
				return
			}
			
			self.currentReconnectionAttempt += 1
			print("...\(self.currentReconnectionAttempt) attempt to reconnect at \(Date())")

			if self.currentReconnectionAttempt > self.maxReconnectAttempts {
				timer.invalidate()
				self.connection.stop()
				print("Max reconnection attempts reached. Giving up...")
				return
			}

			if case .connected = self.state {
				timer.invalidate()
				print("Already connected. Reconnection halted.")
				return
			}

			self.connection.start()
		}
	}
	
	public func sendRequest(_ request: AnyRequest){
		self.connection.requestSubject.send(request)
	}

	/**
	 Request IB to start API. Must be sent after handshake
	 - returns next valid id and managed account identifiers
	 - parameter id: unique app identifier.
	 */
	func startAPI(id: Int) -> AnyPublisher<IBEvent, Never> {
		
		let request = StartAPIRequest(clientId: id, options: nil)
		self.sendRequest(request)
	
		let monitoredTypes:[ResponseType] = [.errorMessage, .managedAccounts, .nextValidId, .openOrder, .orderStatus]
		return self.responses
			.filter { monitoredTypes.contains($0.type) }
			.handleEvents(receiveOutput: { response in

				guard let error = response.error else { return }
		
				switch error.code {
				case 1100, 1101, 1102:
					print("􀇾 Server state update: \(error.code) - \(error.message)")
				case 2100...2169:
					print("􀁞 Warning: \(error.code) - \(error.message)")
				default:
					break
				}
				
			})
			.compactMap { response in
				guard case .success(let event) = response.result else { return nil }
				return event
			}
			.eraseToAnyPublisher()
	}
	
	
	private let nextIdQueue = DispatchQueue(label: "com.ibkit.nextId.queue")

	private let _nextRequestID = CurrentValueSubject<Int, Never>(-1)
	
	public func nextIdPublisher(count: Int = 1) -> AnyPublisher<[Int], Never> {
		_nextRequestID
			.first { $0 > 0 } // Wait until a valid starting ID appears
			.map { start in
				self.nextIdQueue.sync {
					let ids = Array(start..<(start + count))
					self._nextRequestID.send(start + count)
					return ids
				}
			}
			.eraseToAnyPublisher()
	}
	
	
	/**
	 Sets up managed accounts from the provided identifiers
	
	 This method is called automatically during the connection process when account information
	 is received from TWS/Gateway. It can be overridden in subclasses to customize account setup.
	
	 - Parameter identifiers: Array of account identifier strings received from TWS/Gateway
	 */
	open func setupAccounts(identifiers: [String]){
		self.managedAccounts = identifiers.map({Account(name:$0)})
	}
		
	
	/**
	Called when the client is fully connected and authenticated

	This method is invoked after successful connection, API startup, and account setup.
	Override this method in subclasses to perform initialization tasks that require
	a fully established connection, such as subscribing to market data or retrieving account information.
	*/
	open func onConnection(){
					
	}

	
	  
}

