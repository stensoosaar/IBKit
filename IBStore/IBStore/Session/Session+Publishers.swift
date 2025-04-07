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
import Combine
import IBClient


extension Session {


	public func contractDetailsPublisher(for contract: IBContract) -> AnyPublisher<IBContractDetails, Error> {
			
		let id = broker.nextRequestID
		let request = IBContractDetailsRequest(id: id, contract: contract)
		let subject = PassthroughSubject<IBContractDetails, Error>()
					
		let cancellable = broker.dataTaskPublisher(for: request)
			.first()
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
			.handleEvents(receiveCancel: { cancellable.cancel() })
			.eraseToAnyPublisher()

	}
	
	/*

	public func priceHistoryPublisher(contract: IBContract, resolution: IBBarSize, interval: DateInterval) throws -> AnyPublisher<IBPriceHistory, Error> {
		let id = broker.nextRequestID
		let request = IBPriceHistoryRequest(
			id: id,
			contract: contract,
			size: IBBarSize.fiveMinutes,
			source:  IBBarSource.trades,
			lookback: DateInterval.lookback(1, unit: .weekOfYear),
			extendedSession: true
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
		let request = IBRealTimeBarRequest(id: id, contract: contract, source: source, extendedSession: sessionType)
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
	
	*/
}
