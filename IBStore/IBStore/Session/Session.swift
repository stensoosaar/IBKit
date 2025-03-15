//
//  Session.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.03.2025.
//

import Foundation
import IBClient
import Combine

public class Session: AnySession {
	
	public var broker: Broker
	
	public init(broker: Broker) {
		self.broker = broker
	}

}



extension Session {
			
	public func contractDetailsPublisher(for contract: IBContract) -> AnyPublisher<IBContractDetails, Error> {
			
		let id = broker.nextRequestID
		let request = IBContractDetailsRequest(id: id, contract: contract)
		let subject = PassthroughSubject<IBContractDetails, Error>()
					
		let cancellable = broker.dataTaskPublisher(for: request)
			.handleEvents(receiveOutput: { message in
				if message is IBContractDetailsEnd {
					subject.send(completion: .finished)
				}
			})
			.compactMap { $0 as? IBContractDetails }
			.sink { completion in
				subject.send(completion: .finished)
			} receiveValue: { payload in
				subject.send(payload)
			}

		return subject
			.handleEvents(receiveCancel: { cancellable.cancel() }) // Ensure cleanup
			.eraseToAnyPublisher()

	}
	

	public func priceHistoryPublisher(contract: IBContract) throws -> AnyPublisher<IBPriceHistory, Error> {
		let id = broker.nextRequestID
		let request = IBPriceHistoryRequest(
			id: id,
			contract: contract,
			size: IBBarSize.fiveMinutes,
			source:  IBBarSource.trades,
			lookback: DateInterval.lookback(1, unit: .weekOfYear),
			extendedTrading: true
		)

		return broker.dataTaskPublisher(for: request)
			.compactMap { $0 as? IBPriceHistory }
			.eraseToAnyPublisher()
	}
		
	
	func priceQuotePublisher(contract: IBContract) throws -> AnyPublisher<IBPriceQuote, Error> {
		let id = broker.nextRequestID
		let request = IBMarketDataRequest(id: id, contract: contract)
		return broker.dataTaskPublisher(for: request)
			.compactMap { $0 as? IBPriceQuote }
			.eraseToAnyPublisher()
	}
	
	
	func priceBarPublihser(contract: IBContract) throws -> AnyPublisher<IBPriceBarUpdate, Error> {
		let id = broker.nextRequestID
		let source = getBarSource(for: contract)
		let sessionType = getSessionType(for: contract)
		let request = IBRealTimeBarRequest(id: id, contract: contract, source: source, extendedTrading: sessionType)
		return broker.dataTaskPublisher(for: request)
			.compactMap { $0 as? IBPriceBarUpdate }
			.eraseToAnyPublisher()
	}
	
	
	private func getBarSource(for contract: IBContract) -> IBBarSource{
		let collection: [IBSecuritiesType] = [.cfd, .forex]
		return collection.contains(contract.securitiesType) ? .trades : .midpoint
	}
	
	
	private func getSessionType(for contract: IBContract) -> Bool{
		let collection: [IBSecuritiesType] = [.future, .forex]
		return collection.contains(contract.securitiesType) ? true : false
	}
	
	
}
