//
//  IBResponse.swift
//  IBKit
//
//  Created by Sten Soosaar on 14.12.2024.
//


//
//  IBEvent.swift
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


public struct IBResponse {
	public var type: IBResponseType
	public var id: Int? = nil
	public var result: Result<IBEvent, IBError>
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
		let typeRawValue = try container.decode(Int.self)
		guard let type = IBResponseType(rawValue: typeRawValue)
		else { throw IBError.decodingError("bad response type") }
		self.type = type
		
		switch type {

		case .ERROR:
			_ = try container.decode(Int.self)
			self.id = try container.decode(Int.self)
			let error = try container.decode(IBError.self)
			self.result = .failure(error)
						
		case .MANAGED_ACCTS:
			self.id = nil
			let object = try container.decode(IBManagedAccounts.self)
			self.result = .success(object)
			
		case .NEXT_VALID_ID:
			self.id = nil
			let object = try container.decode(IBNextRequestID.self)
			self.result = .success(object)
						
		case .ACCOUNT_SUMMARY:
			self.id = try decoder.decode(Int.self)
			let object = try container.decode(IBAccountSummary.self)
			//self.id = object.requestID
			self.result = .success(object)
			
		case .ACCOUNT_SUMMARY_END:
			_ = try container.decode(Int.self)
			self.id = try decoder.decode(Int.self)
			let object = try container.decode(IBAccountSummaryEnd.self)
			self.result = .success(object)
			
		case .ACCOUNT_UPDATE_MULTI:
			_ = try container.decode(Int.self)
			self.id = try decoder.decode(Int.self)
			let object = try decoder.decode(IBAccountUpdateMulti.self)
			//self.id = object.requestID
			self.result = .success(object)

		case .ACCOUNT_UPDATE_MULTI_END:
			self.id = try decoder.decode(Int.self)
			let object = try decoder.decode(IBAccountUpdateMultiEnd.self)
			self.result = .success(object)

		case .ACCT_UPDATE_TIME:
			let object = try decoder.decode(IBAccountUpdateTime.self)
			self.result = .success(object)

		case .ACCT_VALUE:
			let object = try decoder.decode(IBAccountUpdate.self)
			self.result = .success(object)

		case .ACCT_DOWNLOAD_END:
			let object = try decoder.decode(IBAccountUpdateEnd.self)
			self.result = .success(object)

		case .ACCOUNT_PNL:
			self.id = try decoder.decode(Int.self)
			let object = try decoder.decode(IBAccountPNL.self)
			self.result = .success(object)

		case .POSITION_PNL:
			self.id = try decoder.decode(Int.self)
			let object = try decoder.decode(IBPositionPNL.self)
			self.result = .success(object)

		case .CURRENT_TIME:
			let object = try container.decode(IBServerTime.self)
			self.result = .success(object)

		case .PORTFOLIO_VALUE:
			let object = try decoder.decode(IBPositionUpdate.self)
			self.id = nil
			self.result = .success(object)

		case .POSITION_DATA:
			let object = try decoder.decode(IBPositionSize.self)
			self.id = nil
			self.result = .success(object)

		case .POSITION_END:
			self.id = try decoder.decode(Int.self)
			let object = try decoder.decode(IBPositionSizeEnd.self)
			self.id = object.requestID
			self.result = .success(object)

		case .POSITION_MULTI:
			_ = try container.decode(Int.self)
			self.id = try decoder.decode(Int.self)
			let object = try decoder.decode(IBPositionSizeMulti.self)
			self.result = .success(object)

		case .POSITION_MULTI_END:
			_ = try container.decode(Int.self)
			self.id = try decoder.decode(Int.self)
			let object = try decoder.decode(IBPositionSizeMultiEnd.self)
			self.result = .success(object)
			
		case .OPEN_ORDER:
			let object = try decoder.decode(IBOpenOrder.self)
			self.id = object.requestID
			self.result = .success(object)

		case .OPEN_ORDER_END:
			let object = try container.decode(IBOpenOrderEnd.self)
			self.id = nil
			self.result = .success(object)

		case .MARKET_RULE:
			let object = try decoder.decode(IBMarketRule.self)
			self.id = nil
			self.result = .success(object)

		case .ORDER_BOUND:
			let object = try decoder.decode(IBOrderBounds.self)
			self.id = object.orderID
			self.result = .success(object)

		case .ORDER_STATUS:
			let object = try decoder.decode(IBOrderStatus.self)
			self.id = object.requestID
			self.result = .success(object)

		case .COMPLETED_ORDER:
			let object = try decoder.decode(IBOrderCompletion.self)
			self.id = object.requestID
			self.result = .success(object)

		case .COMPLETED_ORDERS_END:
			let object = try decoder.decode(IBOrderCompletionEnd.self)
			self.id = nil
			self.result = .success(object)

		case .EXECUTION_DATA:
			let object = try decoder.decode(IBOrderExecution.self)
			self.id = object.requestID
			self.result = .success(object)

		case .EXECUTION_DATA_END:
			let object = try decoder.decode(IBOrderExecutionEnd.self)
			self.id = object.requestID
			self.result = .success(object)
			
		case .COMMISSION_REPORT:
			let object = try decoder.decode(IBCommissionReport.self)
			self.id = nil
			self.result = .success(object)

		case .SYMBOL_SAMPLES:
			let object = try decoder.decode(IBContractSearchResult.self)
			self.id = object.requestID
			self.result = .success(object)

		case .CONTRACT_DATA:
			let object = try decoder.decode(IBContractDetails.self)
			self.id = object.requestID
			self.result = .success(object)

		case .CONTRACT_DATA_END:
			let object = try decoder.decode(IBContractDetailsEnd.self)
			self.id = object.requestID
			self.result = .success(object)
			
		case .SCANNER_PARAMETERS:
			let object = try decoder.decode(IBScannerParameters.self)
			self.id = nil
			self.result = .success(object)

		case .SCANNER_DATA:
			let object = try decoder.decode(IBScannerData.self)
			self.id = object.requestID
			self.result = .success(object)

		case .FUNDAMENTAL_DATA:
			let object = try decoder.decode(IBFinancialReport.self)
			self.id = object.requestID
			self.result = .success(object)

		case .HEAD_TIMESTAMP:
			let object = try decoder.decode(IBHeadTimestamp.self)
			self.id = object.requestID
			self.result = .success(object)

		case .BOND_CONTRACT_DATA:
			let object = try decoder.decode(IBBondDetails.self)
			self.id = object.requestID
			self.result = .success(object)

		case .OPTION_PARAMETER:
			let object = try decoder.decode(IBOptionChain.self)
			self.id = object.requestID
			self.result = .success(object)

		case .OPTION_PARAMETER_END:
			let object = try decoder.decode(IBOptionChainEnd.self)
			self.id = object.requestID
			self.result = .success(object)

		case .MARKET_DEPTH:
			let object = try decoder.decode(IBMarketDepth.self)
			self.id = object.requestID
			self.result = .success(object)

		case .MARKET_DEPTH_L2:
			let object = try decoder.decode(IBMarketDepthL2.self)
			self.id = object.requestID
			self.result = .success(object)

		case .NEWS_BULLETINS:
			let object = try decoder.decode(IBBulletin.self)
			self.id = nil
			self.result = .success(object)

		case .TICK_PRICE:
			let object = try decoder.decode(IBTickPrice.self)
			self.id = object.requestID
			self.result = .success(object.tick)

		case .TICK_SIZE:
			let object = try decoder.decode(IBTickSize.self)
			self.id = object.requestID
			self.result = .success(object.tick)

		case .TICK_GENERIC:
			let object = try decoder.decode(IBTickGeneric.self)
			self.id = object.requestID
			self.result = .success(object.tick)

		case .TICK_STRING:
			let object = try decoder.decode(IBTickString.self)
			self.id = object.requestID
			self.result = .success(object.tick)

		case .TICK_OPTION_COMPUTATION:
			let object = try decoder.decode(IBOptionComputation.self)
			self.id = object.requestID
			self.result = .success(object)

		case .TICK_EFP:
			let object = try decoder.decode(IBTickEFP.self)
			self.id = object.requestID
			self.result = .success(object)

		case .HISTORICAL_DATA:
			let object = try decoder.decode(IBPriceHistory.self)
			self.id = object.requestID
			self.result = .success(object)

		case .REAL_TIME_BARS:
			let object = try decoder.decode(IBPriceBarUpdate.self)
			self.id = object.requestID
			self.result = .success(object)
			
		case .HISTORICAL_DATA_UPDATE:
			let object = try decoder.decode(IBPriceBarHistoryUpdate.self)
			self.id = object.requestID
			self.result = .success(object)

		case .MARKET_DATA_TYPE:
			let object = try decoder.decode(IBCurrentMarketDataType.self)
			self.id = object.requestID
			self.result = .success(object)

		case .MKT_DEPTH_EXCHANGES:
			let object = try decoder.decode(IBMarketDepthExchanges.self)
			self.id = nil
			self.result = .success(object)

		case .TICK_REQ_PARAMS:
			let object = try decoder.decode(IBTickParameters.self)
			self.id = object.requestID
			self.result = .success(object)
			
		case .NEWS_ARTICLE:
			let object = try decoder.decode(IBNewsArticle.self)
			self.id = object.requestID
			self.result = .success(object)

		case .TICK_NEWS:
			let object = try decoder.decode(IBNews.self)
			self.id = object.tickerID
			self.result = .success(object)

		case .NEWS_PROVIDERS:
			let object = try decoder.decode(IBNewsProviders.self)
			self.id = nil
			self.result = .success(object)

		case .HISTORICAL_NEWS:
			let object = try decoder.decode(IBHistoricalNews.self)
			self.id = object.requestID
			self.result = .success(object)

		case .HISTORICAL_NEWS_END:
			let object = try decoder.decode(IBHistoricalNewsEnd.self)
			self.id = object.requestID
			self.result = .success(object)

		case .HISTOGRAM_DATA:
			let object = try decoder.decode(IBHistoricalNewsEnd.self)
			self.id = object.requestID
			self.result = .success(object)

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
			
		case .HISTORICAL_SCHEDULE:
			let object = try decoder.decode(IBHistoricalSchedule.self)
			self.id = object.requestID
			self.result = .success(object)

		case .HISTORICAL_TICKS:
			let object = try decoder.decode(IBHistoricalTick.self)
			self.id = object.requestID
			self.result = .success(object)

		case .HISTORICAL_TICKS_BID_ASK:
			let object = try decoder.decode(IBHistoricalTickBidAsk.self)
			self.id = object.requestID
			self.result = .success(object)

		case .HISTORICAL_TICKS_LAST:
			let object = try decoder.decode(IBHistoricalTickLast.self)
			self.id = object.requestID
			self.result = .success(object)

		case .TICK_BY_TICK:
			let object = try decoder.decode(IBTickByTick.self)
			self.id = object.requestID
			self.result = .success(object)

		case .WSH_META_DATA:
			let object = try decoder.decode(IBWSHMeta.self)
			self.id = object.requestID
			self.result = .success(object)

		case .WSH_EVENT_DATA:
			let object = try decoder.decode(IBWSHEventData.self)
			self.id = nil
			self.result = .success(object)

		default:
			throw IBError.decodingError("catched unsupported message: \(type)")
		}
		
	}
	
}

