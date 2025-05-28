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


open class IBClient {
	
	/// app id
	public let id: Int

	/// socket connection
	private var connection: IBConnection
	
	public private(set) lazy var responses = connection.responseSubject.share().eraseToAnyPublisher()
	
	private var cancellables: Set<AnyCancellable> = []
		
	public private(set) var managedAccounts: [Account] = []

	public init(id: Int, host: String = "127.0.0.1", port: UInt16 = 4002) {
		self.id = id
		self.connection = IBConnection(host: host, port: port)
	}
	
	public var debugMode: Bool = false {
		willSet{
			self.connection.debugMode = newValue
		}
	}
	
	public var state: IBConnection.State {
		connection.state.value
	}
	
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
					self?.managedAccounts = temp.identifiers.map({Account(name: $0)})
					print("􀃲 Managed accounts: \( temp.identifiers.joined(separator: ", "))")
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
					self?.reconnect()
				}
			}
			.store(in: &cancellables)
		

		currentReconnectionAttempt = 0
		connection.start()

	}
		
	open func onConnection(){
					

	}

	public func disconnect() {
		timer?.invalidate()
		timer = nil
		connection.stop()
		cancellables.removeAll()
		managedAccounts.removeAll()
		_nextRequestID.send(-1)
	}


	/// Reconnection
	
	private var timer: Timer? = nil
	
	public var reconnectInterval: TimeInterval = 30
	
	public var maxReconnectAttempts: Int = 100
	
	private var currentReconnectionAttempt:Int = 0

	private func reconnect() {
		
		print(#function)
		
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
	  
}

