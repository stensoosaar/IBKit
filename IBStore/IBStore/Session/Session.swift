//
//  IBStore.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
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
import IBClient
import Combine



open class Session {
	
	public enum RunMode {
		case live
		case test
		case backtest(_ interval: DateInterval)
	}
	
	public var sessionType: RunMode

	public var broker: Broker
	
	public var store: Store
	
	public var dataNeed: [DataItem] = []
	
	var cancellables = Set<AnyCancellable>()
	
	var watchlistCancellables: [String: AnyCancellable] = [:]
	
	public let datePublisher = PassthroughSubject<Date,Never>()

	public init(id: Int, universe: URL, mode: RunMode) throws {
		self.broker = Broker(id: id, port: Broker.ConnectionType.workstation.livePort)
		self.store = try Store.create()
		try store.storeUniverse(universe)
		self.broker.store = store
		self.sessionType = mode
	}
	
}



extension Session {
	
	
	public func subscribeQuote(){
			
	}

	
}


