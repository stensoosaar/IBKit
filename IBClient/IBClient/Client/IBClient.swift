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
import Combine

open class IBClient {
	
	private let id: Int

	private let host: String

	private let port: Int

	private let connection: IBConnection
	
	private let subject = PassthroughSubject<IBResponse, Error>()
	
	public lazy var eventFeed = subject.share().eraseToAnyPublisher()
	
	public var serverVersion:Int? {
		return connection.serverVersion
	}

	public var cancellables: Set<AnyCancellable> = []

	/// Creates new api client
	/// - Parameters:
	/// - id: your app identifier
	///  - adderess: host addrress where your gateway or workstation runs.
	///  - port: default values (live, test): gateway 4001,4002 and workstation 7496,7497
	public init(id: Int, address: String, port: Int) {
		
		guard let host = URL(string: address)?.host else {
			fatalError("Cant figure out the host to connect")
		}
		
		self.host = host
		self.port = port
		self.id = id
		connection = IBConnection(host: host, port: port)
		
	}
	
	private var _nextValidID: Int = 0

	public var nextRequestID: Int {
		get{
			let value = _nextValidID
			_nextValidID += 1
			return value
		}
		set{
			_nextValidID = newValue
		}
	}
	
	public var debugMode: Bool = false{
		willSet{
			self.connection.debugMode = newValue
		}
	}
		
	open func onConnect(){}
	
	private func listen(){
		connection.publisher
			.decode(type: IBResponse.self, decoder: IBDecoder(self.connection.serverVersion))
			.catch { error -> Empty<IBResponse, Never> in
				print("Decoding error: \(error)") // Log the error silently
				return Empty() // Replace with an empty publisher, preventing termination
			}
			.sink { completion in
				print(completion)
			} receiveValue: { [weak self] response in
				
				if response.id == -1 && response.type == .ERROR, let error = response.error {
					self?.setServiceState(error)
					return
				}
				
				self?.subject.send(response)
			}
			.store(in: &cancellables)
	}
	
	open func onDisconnect(){}
		
	public func connect() throws {

		guard self.connection.state == .disconnected else {
			throw IBError.connection("Already connected")
		}
		
		self.connection.$state
			.sink { [weak self] state in
				switch state {
				case .connectedToAPI:
					do {
						try self?.startAPI()
					} catch {
						fatalError("failed to start api \(error.localizedDescription)")
					}
					self?.listen()
					self?.onConnect()
				default:
					break
				}
			}
			.store(in: &cancellables)
		connection.connect()
	}

	public func disconnect() {
		self.onDisconnect()
		connection.disconnect()
	}
	
	public func send(_ request: IBRequest) throws {
		guard connection.state == .connectedToAPI else {
			throw IBError.connection("Not connected")
		}
		let encoder = IBEncoder(connection.serverVersion)
		try encoder.encode(request)
		let data = encoder.data
		let dataWithLength = data.count.toBytes(size: 4) + data
		connection.send(data: dataWithLength)
	}
		
	private func startAPI() throws {
		let version: Int = 2
		let encoder = IBEncoder()
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.startAPI)
		try container.encode(version)
		try container.encode(id)
		try container.encode("")
		let dataWithLength = encoder.data.count.toBytes(size: 4) + encoder.data
		connection.send(data: dataWithLength)
	}
	
	private func setServiceState(_ error: IBError){
		print("SERVICE STATE", error.message)
	}
	
}

