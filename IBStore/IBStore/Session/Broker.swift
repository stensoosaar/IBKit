/*
 MIT License

 Copyright (c) 2016-2025 Sten Soosaar

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


import Foundation
import IBClient
import Combine
import TWS


public class Broker: IBClient{
	
	
	public override func onConnection() {
		

	}
	
	
}


public extension Broker {
	
	func bulkDataTaskPublisher<T: IdentifiableRequest>(
		for requests: [T],
		count: Int
	) -> AnyPublisher<DataTaskResponse<T>, Never> {
		
		Publishers.Sequence(sequence: requests)
			.flatMap(maxPublishers: .max(count)) { request in
				self.dataTaskPublisher(for: request)
					.first()
					.map { event in
						DataTaskResponse(request: request, result: .success(event))
					}
					.catch { error -> Just<DataTaskResponse<T>> in
						print("⚠️ Request \(request.id) failed: \(error)")
						return Just(DataTaskResponse(request: request, result: .failure(error)))
					}
			}
			.eraseToAnyPublisher()
	}
	
	
	func historicalDataPublisher(
		contracts: [Contract],
		size: BarSize,
		source: BarSource,
		interval: DateInterval,
		extendedTrading: Bool = false,
		maxConcurrent max: Int = 3
	) -> AnyPublisher<DataTaskResponse<HistoricalDataRequest>, Never> {
		
		return self.nextIdPublisher(count: contracts.count)
			.map { ids in
				zip(contracts, ids).map { contract, id in
					HistoricalDataRequest(
						id: id,
						contract: contract,
						interval: interval,
						size: size,
						source: source,
						extendedTrading: extendedTrading
					)
				}
			}
			.flatMap { requests in
				self.bulkDataTaskPublisher(for: requests, count: max)
			}
			.eraseToAnyPublisher()
	}
	
	
	func fundamentalDataPublisher(
		contracts: [Contract],
		reportType: FundamentalDataRequest.ReportType,
		maxConcurrent max: Int = 3
	) -> AnyPublisher<DataTaskResponse<FundamentalDataRequest>, Never> {
		
		return self.nextIdPublisher(count: contracts.count)
			.map { ids in
				zip(contracts, ids).map { contract, id in
					FundamentalDataRequest(
						id: id,
						contract: contract,
						reportType: reportType
					)
				}
			}
			.flatMap { requests in
				self.bulkDataTaskPublisher(for: requests, count: max)
			}
			.eraseToAnyPublisher()
	}
	
	
	func contractDetailsPublisher(base:[Contract], types: [Contract.SecuritiesType]) -> AnyPublisher<DataTaskResponse<ContractDetailsRequest>, Never> {
		
		let contracts = base.flatMap { contract in
			types.map { type in
				var newContract = contract
				newContract.type = type
				return newContract
			}}
		
		return self.nextIdPublisher(count: contracts.count)
			.map { ids in
				zip(contracts, ids).map { contract, id in
					ContractDetailsRequest(id: id, contract: contract)
				}
			}
			.flatMap { requests in
				self.bulkDataTaskPublisher(for: requests, count: 3)
			}
			.eraseToAnyPublisher()

	}
	
	/*
	func accountBalancePublisher(for identifiers: [String]) -> AnyPublisher<DataTaskResponse<AccountUpdatesMultiRequest>, Never> {
		
	}
	
	func accountPNLPublisher(for identifiers: [String]) -> AnyPublisher<DataTaskResponse<AccountPNLRequest>, Never> {
		
	}

	/**
	 accountName and contractid pair
	 
	 */
	func positionSizePublisher() -> AnyPublisher<DataTaskResponse<PositionSizeMultiRequest>, Never> {
		
	}
	
	func positionPNLPublisher(for identifiers: [String]) -> AnyPublisher<DataTaskResponse<PositionPNLRequest>, Never> {
		
	}
	
	func marketDataPublisher(for contract: Contract) -> AnyPublisher<DataTaskResponse<MarketDataRequest>, Never> {
		
	}
	 */

}
