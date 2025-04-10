//
//  IBConnection.swift
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
import NIOCore
import NIOConcurrencyHelpers
import NIOPosix
import Combine


class IBConnection: AnyConnection {
	
	var requestSubject = PassthroughSubject<Data, Never>()
	
	var responseSubject = PassthroughSubject<Data,Error>()
	
	var state = CurrentValueSubject<ConnectionState,Never>(.disconnected)

	var debugMode:Bool = false
	
	let host: String
	
	let port: Int
	
	private(set) var serverVersion: Int?
	
	private(set) var connectionTime: String?

	private var cancellables: Set<AnyCancellable> = []

	init(host: String, port: Int) {
		self.host = host
		self.port = port
		
		requestSubject
			.queue(for: .milliseconds(20), scheduler: DispatchQueue.main)
			.combineLatest(state)
			.filter { $0.1 == .connectedToAPI }
			.map { $0.0 }
			.sink { [weak self] data in
				self?.send(data: data)
			}
			.store(in: &cancellables)
	}
	
	private var channel: Channel?
	
	private let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
	
	private let lock = NIOLock()

	func connect(){
		lock.withLock {
			assert(.disconnected == self.state.value)
			
			self.state.value = .initializing
			
			let bootstrap = ClientBootstrap(group: self.group)
				.channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
				.channelInitializer { channel in
					channel.pipeline.addHandlers([
						ByteToMessageHandler(IBClientFrameDecoder()),
						IBMessageHandler(messageFrame: self.readMessage)
					])
				}
			
			self.state.value = .connecting("\(host):\(port)")
			
			bootstrap.connect(host: host, port: port).flatMap { channel in
				channel.eventLoop.makeSucceededFuture(channel)
			}.whenComplete { result in
				switch result {
				case .success(let channel):
					self.lock.withLock {
						self.channel = channel
						self.state.value = .hostReached
						self.start()
					}
				case .failure(let failure):
					self.responseSubject.send(completion: .failure(failure))
				}
			}
		}
	}
		
	func disconnect(){
		self.responseSubject.send(completion: .finished)
		self.stop(error: nil)
	}
	
	public func disconnectSocket() -> EventLoopFuture<Void> {
		self.lock.withLock {
			if .hostReached != self.state.value{
				self.state.value = .disconnected
				return self.group.next().makeFailedFuture(IBError.connection("Not Ready"))
			}
			guard let channel = self.channel else {
				self.state.value = .disconnected
				return self.group.next().makeFailedFuture(IBError.connection("Not Ready"))
			}
			self.state.value = .disconnecting
			channel.closeFuture.whenComplete { _ in
				self.lock.withLock {
					self.state.value = .disconnected
				}
			}
			channel.close(promise: nil)
			return channel.closeFuture
		}
	}
	
	private func start() {
		var greeting = Data()
		let prefix="API\0"
		if let contentData = prefix.data(using: .ascii, allowLossyConversion: false) {
			greeting += contentData
		}
	
		let versions = "v\(IBServerVersion.range.lowerBound)..\(IBServerVersion.range.upperBound)"
		greeting += versions.count.toBytes(size: 4)
		if let contentData = versions.data(using: .ascii, allowLossyConversion: false) {
			greeting += contentData
		}
		
		send(data: greeting)
	}

	private func stop(error: Error?) {
		disconnectSocket()
			.whenComplete { result in
				switch result {
				case .success:
					self.responseSubject.send(completion: .finished)
				case .failure(let failure):
					self.responseSubject.send(completion: .failure(failure))
				}
			}
	}

	func send(data: Data) {
		
		if debugMode{
			print(#function, String(data: data, encoding: .utf8))
		}

		guard let channel else { return }
		var buffer = channel.allocator.buffer(capacity: data.count)
		buffer.writeBytes(data)
		channel
			.writeAndFlush(buffer)
			.whenComplete { _ in }
	}
	
	func readMessage(_ data: Data) {
		
		if debugMode{
			print(#function, String(data: data, encoding: .utf8))
		}
				
		if state.value == .hostReached {
			
			guard let separator = "\0".data(using: .utf8),
				  let range = data.range(of: separator),
				  let versionString = String(data: data.subdata(in: 0..<range.lowerBound),encoding: .utf8),
				  let serverVersion = Int(versionString),
				  let connectionTime = String(data: data.subdata(in: range.upperBound..<data.count-1), encoding: .utf8)
			else { return }
						
			self.serverVersion = serverVersion
			self.connectionTime = connectionTime
			self.state.value = .connectedToAPI
			
		} else if state.value == .connectedToAPI {
			responseSubject.send(data)
		}
	}
	
	deinit {
		assert(.disconnected == self.state.value)
		cancellables.removeAll()
		channel = nil
	}
	
}
