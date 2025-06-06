
//
//  IBClient.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//


import Foundation
import Network
import Combine
import TWS



public final class IBConnection {
	
		
	private let host: NWEndpoint.Host
	
	private let port: NWEndpoint.Port
	
	private var connection: NWConnection?
	
	private var supportedRange: ClosedRange<ServerVersion> {
		return ServerVersion.FAProfileDesupport...ServerVersion.fullOrderPreviewFields
	}
		
	private var cancellables: Set<AnyCancellable> = []
		
	var debugMode:Bool = false
	
	private let queue = DispatchQueue(label: "IBConnectionQueue")
	
	/**
	 Creates a new Interactive Brokers (IB) connection object to a TWS workstation or IB Gateway instance.
	 - parameter id: unique session id, must not conflict with other connected clients.
	 - parameter host: the hostname or IP address to connect to (default is `127.0.0.1` for localhost)
	 - parameter port: the port number to connect to (should match your TWS or Gateway API port).
	 
	 You must have either Trader Workstation (TWS) or IB Gateway running and configured to accept API connections.
	 The `port` must match the settings in your running TWS or Gateway session:
	 * **Workstation**: `7496 live` and `7497 paper trading`
	 * **Gateway**: `4001 live`and `4002 paper trading`
	 */
	public init(host: String, port:UInt16){
		self.host = NWEndpoint.Host(host)
		self.port = NWEndpoint.Port(rawValue: port)!
	}
	
	//MARK: - CONNECTION STATE
	
	/**
	 States indicating whether a connection can be used to send and receive data.
	*/
	public enum State: Sendable, Equatable {
		
		///The connection has been initialized but not started.
		case setup
		
		///The connection is waiting for a network path change.
		case waiting(NWError)
		
		///The connection in the process of being established.
		case preparing
		
		///The connection is established, and ready for handshake
		case ready
		
		///The connection has disconnected or encountered an error.
		case failed(NWError)
		
		///The connection is established, and ready to send and receive data.
		case connected(ServerVersion, String)
		
		///The connection has been canceled / disconnected.
		case disconnected
		
		init(from state: NWConnection.State){
			
			switch state {
			case .setup:
				self = IBConnection.State.setup
			case .waiting(let error):
				self = .waiting(error)
			case .preparing:
				self = .preparing
			case .ready:
				self = .ready
			case .failed(let error):
				self = .failed(error)
			case .cancelled:
				self = .disconnected
			@unknown default:
				self = .disconnected
			}
		}
		
		public static func == (lhs: State, rhs: State) -> Bool {
			   switch (lhs, rhs) {
				   
			   case (.setup, .setup),
					(.preparing, .preparing),
					(.ready, .ready),
					(.disconnected, .disconnected):
					return true

			   case let (.connected(v1, t1), .connected(v2, t2)):
				   return v1 == v2 && t1 == t2

			   case let (.failed(e1), .failed(e2)):
				   return e1.localizedDescription == e2.localizedDescription

			   case let (.waiting(e1), .waiting(e2)):
				   return e1.localizedDescription == e2.localizedDescription

			   default: return false
			}
		}
	}
	
	public var state = CurrentValueSubject<IBConnection.State,Never>(.disconnected)
	
	func listenStateUpdate(to state: NWConnection.State) {
		
		switch state {
		case .ready:
			self.state.send(IBConnection.State.ready)
			self.sendHandshake(acceptedRange: self.supportedRange)
			self.readNextMessage()
			print("...host connected")
		case .failed(let error):
			self.state.send(IBConnection.State.failed(error))
			print("...connection failed \(error.localizedDescription) at \(Date())")
		case .waiting(let error):
			self.state.send(IBConnection.State.waiting(error))
			print("...connection waiting \(error.localizedDescription) at \(Date())")
		case .cancelled:
			self.state.send(IBConnection.State.disconnected)
			self.stop()
			print("...connection cancelled at \(Date())")
		case .preparing:
			self.state.send(IBConnection.State.preparing)
			print("...preparing connection")
		default:
			print("unhandled connection state: \(state)")
		}

	}
	
	
	//MARK: - RE/CONNECT
	
	
	var requstPacintInterval:Int = 20
	
	
	/**
	 Starts the session
	 */
	public func start() {
		print("Starting connection...")
		
		requestSubject
			.queue(for: .milliseconds(self.requstPacintInterval), scheduler: DispatchQueue.main)
			.combineLatest(state)
			.filter { _, state in
				if case .connected = state {
					return true
				} else {
					return false
				}
			}
			.sink { [weak self] request, state in
				
				guard case let .connected(serverVersion, _) = state else { return }
				
				do {
					let encoder = IBEncoder(serverVersion)
					_ = try encoder.encode(request)
					let data = encoder.dataWithLength
					self?.send(data: data)
				} catch {
					print("encoding error", error)
				}
			}
			.store(in: &cancellables)

		
		let options = NWProtocolTCP.Options()
		options.enableFastOpen = true
		options.connectionTimeout = 30

		let params = NWParameters(tls: nil, tcp: options)
		if let isOption = params.defaultProtocolStack.internetProtocol as? NWProtocolIP.Options {
			isOption.version = .v4
		}
		params.preferNoProxies = true
		params.expiredDNSBehavior = .allow
		params.multipathServiceType = .interactive
		params.serviceClass = .background
		
		self.connection = NWConnection(host: host, port: port, using: params)
		self.connection?.stateUpdateHandler = self.listenStateUpdate(to:)
		self.connection?.start(queue: queue)
		
	}
	
	/**
	 Stops the session
	*/
	public func stop() {
		print("...cleaning")
		connection?.cancel()
		connection = nil
		cancellables.removeAll()
		print("...connection closed.")
	}

	
	
	//MARK: - SENDING MESSAGES
	
	var requestSubject = PassthroughSubject<AnyRequest, Never>()
			 
	private func send(data: Data) {

		if self.debugMode {
			let message = String(data: data, encoding: .ascii)!.debugDescription
			print("\(#function)",message)
		}

		connection?.send(content: data, completion: .contentProcessed( { error in
			if let error = error {
				print("failed to send data to outputstream \(error)")
				return
			}
		}))
	}
	
	
	//MARK: - READING MESSAGES
	
	let responseSubject = PassthroughSubject<Response, Never>()
	
	
	private func readNextMessage() {
		
		connection?.receive(minimumIncompleteLength: 4, maximumLength: 4) { [weak self] (messageLengthData, _, isComplete, error) in
			
			guard let self = self else { return }
			
			if let error = error {
				print("Received error: \(error) when reading message")
				return
			}

			guard let data = messageLengthData, data.count == 4 else {
				return
			}

			let length = Int.fromBytes(data: data)

			self.connection?.receive(minimumIncompleteLength: length, maximumLength: length) { (data, _, isComplete, error) in
				
				if let error = error {
					print("Received payload error: \(error)")
					return
				}

				guard let data = data else {
					return
				}

				self.parseMessage(data: data)
				
				self.readNextMessage()
			}
		}
	}

	func parseMessage(data: Data) {
		
		if debugMode {
			let message = String(data: data, encoding: .ascii)?.debugDescription ?? "<invalid ascii>"
			print("\(#function)", message)
		}

		switch state.value {
			
		case .ready:
			
			print("...handshake accepted")

			guard
				let separator = "\0".data(using: .utf8),
				let range = data.range(of: separator),
				let versionString = String(data: data.subdata(in: 0..<range.lowerBound), encoding: .utf8),
				let versionRawValue = Int(versionString),
				let connectionTime = String(data: data.subdata(in: range.upperBound..<data.count - 1), encoding: .utf8)
			else {
				print("failed to read handshake info")
				stop()
				return
			}
			
			let version = ServerVersion(rawValue: versionRawValue)
			state.value = .connected(version, connectionTime)

		case .connected(let serverVersion, _):
			let decoder = IBDecoder(serverVersion)
			decoder.debugMode = debugMode

			do {
				let message = try decoder.decode(Response.self, from: data)
				self.responseSubject.send(message)
			} catch {
				print("failed to decode message: \(error)\n\(decoder.description) cursor: \(decoder.getCursor())")
			}

		default:
			print("ignoring message while in state: \(state.value)")
		}
	}
	
	
	//MARK: - CLEANING
	
	deinit{
		stop()
	}
	
}


extension IBConnection {
		
	fileprivate func sendHandshake(acceptedRange: ClosedRange<ServerVersion>) {
		var greeting = Data()
		let prefix = "API\0"
		if let contentData = prefix.data(using: .ascii, allowLossyConversion: false) {
			greeting += contentData
		}
	   
		let versions = "v\(acceptedRange.lowerBound.rawValue)..\(acceptedRange.upperBound.rawValue)"
		greeting += versions.count.toBytes(size: 4)
		if let contentData = versions.data(using: .ascii, allowLossyConversion: false) {
			greeting += contentData
		}
		send(data: greeting)
	}
	
}

