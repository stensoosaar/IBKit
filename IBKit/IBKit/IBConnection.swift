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




class IBConnection {
	
	let connection: NWConnection
	let queue = DispatchQueue(label: "IB Connection Queue")
	
	init(_ connection: NWConnection) {
		self.connection = connection
	}
	
	var didStopCallback: ((Error?) -> Void)? = nil
	
	var delegate: IBConnectionDelegate?
	
	func start() {
		connection.stateUpdateHandler = stateDidChange(to:)
		connection.start(queue: queue)
	}
	
	private func stateDidChange(to state: NWConnection.State) {
		switch state {
		case .waiting(let error):
			connectionDidFail(error: error)
		case .ready:
			receiveNextMessage()
		case .failed(let error):
			connectionDidFail(error: error)
		case .cancelled:
			print("Cancelled")
		default:
			break
		}
	}
	
	public func receiveNextMessage() {
				
		connection.receive(minimumIncompleteLength: 4, maximumLength: 4) { (messageLengthData, _, isComplete, _) in
			
			if isComplete == true { return }
						
			guard let data = messageLengthData else { fatalError("cant read message length")}
			
			let length = Int.fromBytes(data: data)
			
			self.connection.receive(minimumIncompleteLength: length, maximumLength: length) { (data, _, isComplete, error) in
				guard let data = data else { fatalError("cant read message")}
				self.delegate?.connection(self.connection, didReceiveData: data)
				self.receiveNextMessage()
			}
			
		}
		
	}
	 
	func send(data: Data) {
					
		connection.send(content: data, completion: .contentProcessed( { error in
			if let error = error {
				self.connectionDidFail(error: error)
				return
			}
		}))
		
	}
	
	func stop() {
		stop(error: nil)
	}
	
	private func connectionDidFail(error: Error) {
		self.stop(error: error)
	}
	
	private func connectionDidEnd() {
		self.stop(error: nil)
	}
	
	private func stop(error: Error?) {
		self.connection.stateUpdateHandler = nil
		self.connection.cancel()
		if let didStopCallback = self.didStopCallback {
			self.didStopCallback = nil
			didStopCallback(error)
		}
	}
}
