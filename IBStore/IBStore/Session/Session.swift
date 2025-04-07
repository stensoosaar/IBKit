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

	public var broker: Broker
	
	public var store: Store
	
	private var cancellables = Set<AnyCancellable>()
	
	public let datePublisher = PassthroughSubject<Date,Never>()

	public init(id: Int, universe: URL) throws {
		self.broker = Broker(id: id, port: 7496)
		self.store = try Store.create()
		try store.blaah(universe)
		self.broker.store = store
	}
	
	public enum RunMode {
		case live
		case test
		case backtest(_ interval: DateInterval)
	}
	
}

extension Session {
	
	func subscribeQuotes(for contracts: [IBContract]) -> AnyPublisher<QuoteSummary, Error> {
		
		let publishers = contracts.compactMap { contract -> AnyPublisher<MarketData, Error>? in
			let request = IBMarketDataRequest(id: broker.nextRequestID, contract: contract)
			return broker.marketDataPublisher(for: request)
		}
		
		return Publishers.MergeMany(publishers)
			.tryMap { [weak self] in try self?.store.updateQuote(event: $0) }
			.compactMap { $0 }
			.eraseToAnyPublisher()
	}

	/*
	func subscribeBars(count: Int, in resolution: TimeInterval) -> AnyPublisher<MarketData,Error>{}
	
	func subscribeBars(count: Int, in resolution: TimeInterval, _ schedule: DispatchQueue.SchedulerTimeType.Stride ) -> AnyPublisher<MarketData,Error>{}
	
	func modelPublisher()->AnyPublisher<[Weight],Error>{}
	
	func accountModelPublisher() -> AnyPublisher<([AccountSummary], [Weight]), Error> {
			Publishers.CombineLatest(broker.accountSummaryPublisher, modelPublisher())
				.eraseToAnyPublisher()
	}
	*/
	
	
}


