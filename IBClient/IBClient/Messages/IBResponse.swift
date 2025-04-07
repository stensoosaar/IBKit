//
//  IBClient.swift
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


struct IBResponseWrapper<T: Decodable>: Decodable {
	let id: Int?
	let result: T
}


public struct IBResponse: Identifiable {
	public var id: Int?
	public var type: IBResponseType
	public var result: Result<IBEvent, IBError>
	
	public var identifier: Int? {
		return id
	}
		
}


public extension IBResponse {
	
	func get() throws -> IBEvent {
		switch result {
		case .success(let object):
			return object
		case .failure(let error):
			throw error
		}
	}
	
	var error: IBError? {
		switch result {
		case .failure(let error):
			return error
		default:
			return nil
		}
	}
	
}


extension IBResponse: IBDecodable {

	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		type = try container.decode(IBResponseType.self)
		
		switch type {
				
		case .ERROR:
			let object = try IBResponseWrapper<IBError>(from: decoder)
			self.id = object.id
			self.result = .failure(object.result)
						
		case .MANAGED_ACCTS:
			let object = try IBResponseWrapper<IBManagedAccounts>(from: decoder)
			self.result = .success(object.result)
			
		case .NEXT_VALID_ID:
			let object = try IBResponseWrapper<IBNextRequestID>(from: decoder)
			self.result = .success(object.result)
						
		case .ACCOUNT_SUMMARY:
			let object = try IBResponseWrapper<IBAccountSummary>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)
			
		case .ACCOUNT_SUMMARY_END:
			let object = try IBResponseWrapper<IBAccountSummaryEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)
			
		case .ACCOUNT_UPDATE_MULTI:
			let object = try IBResponseWrapper<IBAccountUpdateMulti>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .ACCOUNT_UPDATE_MULTI_END:
			let object = try IBResponseWrapper<IBAccountUpdateMultiEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .ACCT_UPDATE_TIME:
			let object = try IBResponseWrapper<IBAccountUpdateTime>(from: decoder)
			self.result = .success(object.result)

		case .ACCT_VALUE:
			let object = try IBResponseWrapper<IBAccountUpdate>(from: decoder)
			self.result = .success(object.result)

		case .ACCT_DOWNLOAD_END:
			let object = try IBResponseWrapper<IBAccountUpdateEnd>(from: decoder)
			self.result = .success(object.result)

		case .ACCOUNT_PNL:
			let object = try IBResponseWrapper<IBAccountPNL>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .POSITION_PNL:
			let object = try IBResponseWrapper<IBPositionPNL>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .CURRENT_TIME:
			let object = try IBResponseWrapper<IBServerTime>(from: decoder)
			self.result = .success(object.result)

		case .PORTFOLIO_VALUE:
			let object = try IBResponseWrapper<IBPositionUpdate>(from: decoder)
			self.result = .success(object.result)

		case .POSITION_SIZE:
			let object = try IBResponseWrapper<IBPositionSize>(from: decoder)
			self.result = .success(object.result)

		case .POSITION_SIZE_END:
			let object = try IBResponseWrapper<IBPositionSizeEnd>(from: decoder)
			self.result = .success(object.result)

		case .POSITION_SIZE_MULTI:
			let object = try IBResponseWrapper<IBPositionSizeMulti>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .POSITION_SIZE_MULTI_END:
			let object = try IBResponseWrapper<IBPositionSizeMultiEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)
			
		case .OPEN_ORDER:
			let object = try IBResponseWrapper<IBOpenOrder>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .OPEN_ORDER_END:
			let object = try IBResponseWrapper<IBOpenOrderEnd>(from: decoder)
			self.result = .success(object.result)

		case .MARKET_RULE:
			let object = try IBResponseWrapper<IBMarketRule>(from: decoder)
			self.result = .success(object.result)

		case .ORDER_BOUND:
			let object = try IBResponseWrapper<IBOrderBounds>(from: decoder)
			self.result = .success(object.result)

		case .ORDER_STATUS:
			let object = try IBResponseWrapper<IBOrderStatus>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .COMPLETED_ORDER:
			let object = try IBResponseWrapper<IBOrderCompletion>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .COMPLETED_ORDERS_END:
			let object = try IBResponseWrapper<IBOrderCompletionEnd>(from: decoder)
			self.result = .success(object.result)

		case .EXECUTION_DATA:
			let object = try IBResponseWrapper<IBOrderExecution>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .EXECUTION_DATA_END:
			let object = try IBResponseWrapper<IBOrderExecutionEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)
			
		case .COMMISSION_REPORT:
			let object = try IBResponseWrapper<IBCommissionReport>(from: decoder)
			self.result = .success(object.result)

		case .SYMBOL_SAMPLES:
			let object = try IBResponseWrapper<IBContractSearchResult>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .CONTRACT_DATA:
			let object = try IBResponseWrapper<IBContractDetails>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .CONTRACT_DATA_END:
			let object = try IBResponseWrapper<IBContractDetailsEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)
			
		case .SCANNER_PARAMETERS:
			let object = try IBResponseWrapper<IBScannerParameters>(from: decoder)
			self.result = .success(object.result)

		case .SCANNER_DATA:
			let object = try IBResponseWrapper<IBScannerData>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .FUNDAMENTAL_DATA:
			let object = try IBResponseWrapper<IBFinancialReport>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .HEAD_TIMESTAMP:
			let object = try IBResponseWrapper<IBHeadTimestamp>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .BOND_CONTRACT_DATA:
			let object = try IBResponseWrapper<IBBondDetails>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .OPTION_PARAMETER:
			let object = try IBResponseWrapper<IBOptionChain>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .OPTION_PARAMETER_END:
			let object = try IBResponseWrapper<IBOptionChainEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .MARKET_DEPTH:
			let object = try IBResponseWrapper<IBMarketDepth>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .MARKET_DEPTH_L2:
			let object = try IBResponseWrapper<IBMarketDepthL2>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .NEWS_BULLETINS:
			let object = try IBResponseWrapper<IBBulletin>(from: decoder)
			self.result = .success(object.result)

		case .TICK_PRICE, .TICK_SIZE, .TICK_GENERIC, .TICK_STRING, .TICK_OPTION_COMPUTATION, .TICK_EFP:
			let fields = try decoder.decode(TickDecoder.self)
			self.id = fields.id
			self.result = .success(fields.result)

		case .HISTORICAL_DATA:
			let object = try IBResponseWrapper<IBPriceHistory>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .REAL_TIME_BARS:
			let object = try IBResponseWrapper<IBPriceBarUpdate>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)
			
		case .HISTORICAL_DATA_UPDATE:
			let object = try IBResponseWrapper<IBPriceBarHistoryUpdate>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .MARKET_DATA_TYPE:
			let object = try IBResponseWrapper<IBCurrentMarketDataType>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .MKT_DEPTH_EXCHANGES:
			let object = try IBResponseWrapper<IBMarketDepthExchanges>(from: decoder)
			self.result = .success(object.result)

		case .TICK_REQ_PARAMS:
			let object = try IBResponseWrapper<TickParameters>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)
			
		case .NEWS_ARTICLE:
			let object = try IBResponseWrapper<IBNewsArticle>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .TICK_NEWS:
			let object = try IBResponseWrapper<TickNews>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .NEWS_PROVIDERS:
			let object = try IBResponseWrapper<IBNewsProviders>(from: decoder)
			self.result = .success(object.result)

		case .HISTORICAL_NEWS:
			let object = try IBResponseWrapper<IBHistoricalNews>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .HISTORICAL_NEWS_END:
			let object = try IBResponseWrapper<IBHistoricalNewsEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .HISTOGRAM_DATA:
			let object = try IBResponseWrapper<IBHistoricalNewsEnd>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .HISTORICAL_SCHEDULE:
			let object = try IBResponseWrapper<IBHistoricalSchedule>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .HISTORICAL_TICKS:
			let object = try IBResponseWrapper<IBHistoricalTick>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .HISTORICAL_TICKS_BID_ASK:
			let object = try IBResponseWrapper<IBHistoricalTickBidAsk>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .HISTORICAL_TICKS_LAST:
			let object = try IBResponseWrapper<IBHistoricalTickLast>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .TICK_BY_TICK:
			let object = try IBResponseWrapper<IBTickByTick>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .WSH_META_DATA:
			let object = try IBResponseWrapper<IBWSHMeta>(from: decoder)
			self.id = object.id
			self.result = .success(object.result)

		case .WSH_EVENT_DATA:
			let object = try IBResponseWrapper<IBWSHEventData>(from: decoder)
			self.result = .success(object.result)
			
		/*
		case .SOFT_DOLLAR_TIERS:
			break

		case .REROUTE_MKT_DATA_REQ:
			break

		case .REROUTE_MKT_DEPTH_REQ:
			break
					
		case .DELTA_NEUTRAL_VALIDATION:
			break
			 
		case .TICK_SNAPSHOT_END:
			break
			
		case .SMART_COMPONENTS:
			break
		*/

		default:
			throw IBError.decodingError("catched unsupported message: \(type)")
		}

	}
	

}


