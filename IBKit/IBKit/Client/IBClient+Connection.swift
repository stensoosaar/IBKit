//
//  IBClient+ConnectionDelegate.swift
// 	IBKit
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


extension IBClient: IBConnectionDelegate {
	
	func connection(_ connection: IBConnection, didConnect date: String, toServer version: Int) {
		self.connectionTime = date
		self.serverVersion = version
	}
	
	func connection(_ connection: IBConnection, didStopCallback error: Error?) {
		self.subject.send(completion: .finished)
	}
	
	
	func connection(_ connection: IBConnection, didReceiveData data: Data) -> IBServerError? {
				
		do {
			
			let decoder = IBDecoder(serverVersion)
			let responseValue = try decoder.decode(Int.self, from: data)
			let responseType = IBResponseType(rawValue: responseValue)
			
			switch responseType {
				
			case .ERR_MSG:
				let object = try decoder.decode(IBServerError.self)
				if object.requestID != -1 { removeRequest(object) }

				switch object.code {
				case 1100...1300: 	return object
				case 501...504: 	print("client error \(object)")
				case 2100...2169: 	print("warning \(object)")
				default: 			subject.send(object)
				}
				
			case .NEXT_VALID_ID:
				let object = try decoder.decode(IBNextRequestID.self)
				_nextValidID = object.value
				
			case .CURRENT_TIME:
				let object = try decoder.decode(IBServerTime.self)
				subject.send(object)
				
			case .ACCT_VALUE:
				let object = try decoder.decode(IBAccountUpdate.self)
				self.subject.send(object)
				
			case .ACCT_UPDATE_TIME:
				let object = try decoder.decode(IBAccountUpdateTime.self)
				self.subject.send(object)
				
			case .PORTFOLIO_VALUE:
				let object = try decoder.decode(IBPortfolioValue.self)
				self.subject.send(object)
				
			case .ACCT_DOWNLOAD_END:
				let object = try decoder.decode(IBAccountUpdateEnd.self)
				self.subject.send(object)
				
			case .SYMBOL_SAMPLES:
				let object = try decoder.decode(IBContractSearchResult.self)
				self.subject.send(object)
				
			case .MANAGED_ACCTS:
				let object = try decoder.decode(IBManagedAccounts.self)
				self.subject.send(object)
				
			case .PNL:
				let object = try decoder.decode(IBAccountPNL.self)
				self.subject.send(object)
				
			case .ACCOUNT_SUMMARY:
				let object = try decoder.decode(IBAccountSummary.self)
				self.subject.send(object)
				
			case .ACCOUNT_SUMMARY_END:
				let object = try decoder.decode(IBAccountSummaryEnd.self)
				self.subject.send(object)
				
			case .ACCOUNT_UPDATE_MULTI:
				let object = try decoder.decode(IBAccountSummaryMulti.self)
				self.subject.send(object)
				
			case .ACCOUNT_UPDATE_MULTI_END:
				let object = try decoder.decode(IBAccountSummaryMultiEnd.self)
				self.subject.send(object)
				
			case .POSITION_DATA:
				let object = try decoder.decode(IBPosition.self)
				self.subject.send(object)
				
			case .POSITION_END:
				let object = try decoder.decode(IBPositionEnd.self)
				self.subject.send(object)
				
			case .PNL_SINGLE:
				let object = try decoder.decode(IBPositionPNL.self)
				self.subject.send(object)
				
			case .POSITION_MULTI:
				let object = try decoder.decode(IBPositionMulti.self)
				self.subject.send(object)
				
			case .POSITION_MULTI_END:
				let object = try decoder.decode(IBPositionMultiEnd.self)
				self.subject.send(object)
				
			case .OPEN_ORDER:
				let object = try decoder.decode(IBOpenOrder.self)
				self.subject.send(object)
				
			case .OPEN_ORDER_END:
				let object = try decoder.decode(IBOpenOrderEnd.self)
				self.subject.send(object)
				
			case .ORDER_STATUS:
				let object = try decoder.decode(IBOrderStatus.self)
				self.subject.send(object)
				
			case .COMPLETED_ORDER:
				let object = try decoder.decode(IBOrderCompletion.self)
				self.subject.send(object)
				
			case .COMPLETED_ORDERS_END:
				let object = try decoder.decode(IBOrderCompetionEnd.self)
				self.subject.send(object)
				
			case .EXECUTION_DATA:
				let object = try decoder.decode(IBOrderExecution.self)
				self.subject.send(object)
				
			case .EXECUTION_DATA_END:
				let object = try decoder.decode(IBOrderExecutionEnd.self)
				self.subject.send(object)
				
			case .COMMISSION_REPORT:
				let object = try decoder.decode(IBCommissionReport.self)
				self.subject.send(object)
				
			case .CONTRACT_DATA:
				let object = try decoder.decode(IBContractDetails.self)
				self.subject.send(object)
				
			case .CONTRACT_DATA_END:
				let object = try decoder.decode(IBContractDetailsEnd.self)
				self.subject.send(object)
				
			case .SECURITY_DEFINITION_OPTION_PARAMETER:
				let object = try decoder.decode(IBOptionChain.self)
				self.subject.send(object)
				
			case .SECURITY_DEFINITION_OPTION_PARAMETER_END:
				let object = try decoder.decode(IBOptionChainEnd.self)
				self.subject.send(object)
				
			case .FUNDAMENTAL_DATA:
				let object = try decoder.decode(IBFinancialReport.self)
				self.subject.send(object)
				
			case .HEAD_TIMESTAMP:
				let object = try decoder.decode(IBHeadTimestamp.self)
				self.subject.send(object)
				removeRequest(object)
				
			case .HISTORICAL_DATA:
				let object = try decoder.decode(IBPriceHistory.self)
				self.subject.send(object)
				removeRequest(object)
				
			case .HISTORICAL_DATA_UPDATE:
				let response = try decoder.decode(IBPriceBarHistoryUpdate.self)
				let object = IBPriceBarUpdate(requestID: response.requestID, bar: response.bar)
				self.subject.send(object)
				
			case .REAL_TIME_BARS:
				let object = try decoder.decode(IBPriceBarUpdate.self)
				self.subject.send(object)
				
			case .MARKET_RULE:
				let object = try decoder.decode(IBMarketRule.self)
				self.subject.send(object)
				
				// TODO: - mask as quote type.
			case .MARKET_DATA_TYPE:
				let object = try decoder.decode(IBCurrentMarketDataType.self)
				self.subject.send(object)
				
			case .TICK_REQ_PARAMS:
				let object = try decoder.decode(IBTickParameters.self)
				self.subject.send(object)
				
			case .NEWS_BULLETINS:
				let object = try decoder.decode(IBNewsBulletin.self)
				self.subject.send(object)
				
			case .MARKET_DEPTH:
				let object = try decoder.decode(IBMarketDepth.self)
				self.subject.send(object)
				
			case .MARKET_DEPTH_L2:
				let object = try decoder.decode(IBMarketDepthLevel2.self)
				self.subject.send(object)
				
			case .TICK_PRICE:
				let object = try decoder.decode(IBTickPrice.self)
				object.tick.forEach({self.subject.send($0)})
				
			case .TICK_SIZE:
				let object = try decoder.decode(IBTickSize.self)
				self.subject.send(object.tick)
				
			case .TICK_GENERIC:
				let object = try decoder.decode(IBTickGeneric.self)
				self.subject.send(object.tick)
				
			case .TICK_STRING:
				let object = try decoder.decode(IBTickString.self)
				self.subject.send(object.tick)
				
			case .HISTORICAL_TICKS:
				let object = try decoder.decode(IBHistoricTick.self)
				object.ticks.forEach({self.subject.send($0)})
				removeRequest(object)
				
			case .HISTORICAL_TICKS_BID_ASK:
				let object = try decoder.decode(IBHistoricalTickBidAsk.self)
				object.ticks.forEach({self.subject.send($0)})
				removeRequest(object)
				
			case .HISTORICAL_TICKS_LAST:
				let object = try decoder.decode(IBHistoricalTickLast.self)
				object.ticks.forEach({self.subject.send($0)})
				removeRequest(object)
				
			case .TICK_BY_TICK:
				let object = try decoder.decode(IBTickByTick.self)
				object.ticks.forEach({self.subject.send($0)})
				
			case .TICK_EFP:
				let object = try decoder.decode(IBEFPEvent.self)
				self.subject.send(object)
				
			case .TICK_OPTION_COMPUTATION:
				let object = try decoder.decode(IBOptionComputation.self)
				self.subject.send(object)
								
			case .RECEIVE_FA:
				break
			case .BOND_CONTRACT_DATA:
				break
			case .SCANNER_PARAMETERS:
				break
			case .SCANNER_DATA:
				break
			case .DELTA_NEUTRAL_VALIDATION:
				break
			case .TICK_SNAPSHOT_END:
				break
			case .VERIFY_MESSAGE_API:
				break
			case .VERIFY_COMPLETED:
				break
			case .DISPLAY_GROUP_LIST:
				break
			case .DISPLAY_GROUP_UPDATED:
				break
			case .VERIFY_AND_AUTH_MESSAGE_API:
				break
			case .VERIFY_AND_AUTH_COMPLETED:
				break
			case .SOFT_DOLLAR_TIERS:
				break
			case .FAMILY_CODES:
				break
			case .MKT_DEPTH_EXCHANGES:
				break
			case .SMART_COMPONENTS:
				break
			case .NEWS_ARTICLE:
				break
			case .TICK_NEWS:
				break
			case .NEWS_PROVIDERS:
				break
			case .HISTORICAL_NEWS:
				break
			case .HISTORICAL_NEWS_END:
				break
			case .HISTOGRAM_DATA:
				break
			case .REROUTE_MKT_DATA_REQ:
				break
			case .REROUTE_MKT_DEPTH_REQ:
				break
			case .ORDER_BOUND:
				break
			case .REPLACE_FA_END:
				break
			case .WSH_META_DATA:
				break
			case .WSH_EVENT_DATA:
				break
			case .HISTORICAL_SCHEDULE:
				break
			case .USER_INFO:
				break
			default:
				break
			}
		} catch {
			let message = String(data: data, encoding: .utf8)
			print("FAILED TO DECODE MESSAGE: \(message), error: \(error.localizedDescription)")
		}
		
		return nil
	}
	
	
}
