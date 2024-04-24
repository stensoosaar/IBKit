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
import Network
import NIOCore
import NIOConcurrencyHelpers
import NIOPosix

class IBConnection {
    enum State: Equatable {
        case initializing
        case connecting(String)
        case connected
        case disconnecting
        case disconnected
    }
    
    enum ClientError: Error {
        case notReady
        case cantBind
        case timeout
        case connectionResetByPeer
    }
    
    private var channel: Channel?
    private let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    private let lock = NIOLock()
    private(set) var state = State.initializing {
        didSet {
            stateDidChange(to: state)
        }
    }
    
    init(host: String, port: Int) throws {
        try lock.withLock {
            assert(.initializing == self.state)
            
            let bootstrap = ClientBootstrap(group: self.group)
                .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
                .channelInitializer { channel in
                    channel.pipeline.addHandlers([
                        ByteToMessageHandler(IBClientFrameDecoder()),
                        IBMessageHandler(messageFrame: self.receiveMessage)
                    ])
                }
            
            self.state = .connecting("\(host):\(port)")
            let _ = try bootstrap.connect(host: host, port: port).flatMap { channel in
                self.lock.withLock {
                    self.channel = channel
                    self.state = .connected
                }
                return channel.eventLoop.makeSucceededFuture(self)
            }.wait()
        }
    }
    
    
    deinit {
        assert(.disconnected == self.state)
        delegate = nil
        channel = nil
    }
    
    var didStopCallback: ((Error?) -> Void)? = nil
    var delegate: IBConnectionDelegate?
    
    func start() {
        let greeting = createGreeting()
        send(data: greeting)
    }
    
    private func stateDidChange(to state: IBConnection.State) {
        switch state {
        case .initializing:
            print("initializing")
        case .connecting(let string):
            print("connecting:", string)
        case .connected:
            print("connected")
        case .disconnecting:
            print("disconnecting")
        case .disconnected:
            print("disconnected")
        }
    }
     
    func send(data: Data) {
        guard let channel else { return }
        var buffer = channel.allocator.buffer(capacity: data.count)
        buffer.writeBytes(data)
        _ = channel.writeAndFlush(buffer)
    }
    
    public func receiveMessage(_ data: Data) {
        guard let separator = "\0".data(using: .utf8),
            let range = data.range(of: separator),
            let versionString = String(data: data.subdata(in: 0..<range.lowerBound),encoding: .utf8),
            let serverVersion = Int(versionString),
            let connectionTime = String(data: data.subdata(in: range.upperBound..<data.count-1), encoding: .utf8)
        else {
            self.delegate?.connection(self, didReceiveData: data)
            return
        }
        self.delegate?.connection(self, didConnect: connectionTime, toServer: serverVersion)
    }
    
    func disconnect() {
        stop(error: nil)
    }
    
    private func connectionDidFail(error: Error) {
        self.stop(error: error)
    }
    
    private func connectionDidEnd() {
        self.stop(error: nil)
    }
    
    public func disconnectSocket() -> EventLoopFuture<Void> {
        self.lock.withLock {
            if .connected != self.state {
                return self.group.next().makeFailedFuture(ClientError.notReady)
            }
            guard let channel = self.channel else {
                return self.group.next().makeFailedFuture(ClientError.notReady)
            }
            self.state = .disconnecting
            channel.closeFuture.whenComplete { _ in
                self.lock.withLock {
                    self.state = .disconnected
                }
            }
            channel.close(promise: nil)
            return channel.closeFuture
        }
    }
    
    private func stop(error: Error?) {
        disconnectSocket().whenComplete { result in
            switch result {
            case .success:
                self.didStopCallback?(error)
            case .failure(let failure):
                self.didStopCallback?(failure)
            }
            
            self.didStopCallback = nil
        }
    }
    
    private func createGreeting() -> Data {
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
        return greeting
    }
}
