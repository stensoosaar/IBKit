//
//  IBRequestAsync.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.02.2025.
//

import Foundation
import Combine
//import AsyncAlgorithms


public protocol IBRequestAsync {
	
	func subscribePriceQuote(_ requestID: Int, contract: IBContract, snapshot: Bool, regulatory: Bool) throws -> AsyncThrowingStream<any IBAnyMarketData, Error>
	func subscribeRealTimeBar(_ requestID: Int, contract: IBContract, barSource: IBBarSource, extendedTrading: Bool) throws -> AsyncThrowingStream<IBPriceBarUpdate, Error>

}


public extension IBRequestAsync where Self: IBAnyClient {
	
	func subscribePriceQuote(_ requestID: Int, contract: IBContract, snapshot: Bool = false, regulatory: Bool = false) throws -> AsyncThrowingStream<any IBAnyMarketData, Error> {
		
		let request = IBMarketDataRequest(requestID: requestID, contract: contract, events: [], snapshot: snapshot, regulatory: regulatory)
		try send(request: request)

		return AsyncThrowingStream { continuation in
			let cancellable = self.eventFeed
				.compactMap { $0 as? IBIndexedEvent }
				.filter { $0.requestID == requestID }
				.sink(receiveValue: { response in
					switch response {
					case let event as IBTick:
						continuation.yield(event)
					case let event as IBTickParameters:
						continuation.yield(event)
					case let event as IBCurrentMarketDataType:
						continuation.yield(event)
					case let event as IBTickExchange:
						continuation.yield(event)
					case let event as IBServerError:
						continuation.finish(throwing: event.error)
					default:
						fatalError("\(#function) unknown event type received\n\(response)")
					}
				})

			continuation.onTermination = { _ in
				cancellable.cancel()
			}
		}
	}
	
	func subscribeRealTimeBar(_ requestID: Int, contract: IBContract, barSource: IBBarSource, extendedTrading: Bool = true) throws -> AsyncThrowingStream<IBPriceBarUpdate, Error> {
		
		let request = IBRealTimeBarRequest(requestID: requestID, contract: contract, source: barSource, extendedTrading: extendedTrading)
		try send(request: request)
		
		return AsyncThrowingStream { continuation in
			let cancellable = self.eventFeed
				.compactMap { $0 as? IBIndexedEvent }
				.filter { $0.requestID == requestID }
				.sink( receiveValue: { response in
					print(response)
					switch response {
					case let event as IBPriceBarUpdate:
						continuation.yield(event)
					case let event as IBServerError:
						continuation.finish(throwing: event.error)
					default:
						fatalError("\(#function) unknown event type received")
					}
				})
			
			continuation.onTermination = { _ in
				cancellable.cancel()
			}

		}
	}
	
}
