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
	
	
	func connection(_ connection: IBConnection, didReceiveData data: Data) {
		
		let decoder = IBDecoder(serverVersion: serverVersion)
			
		guard let responseValue = try? decoder.decode(Int.self, from: data),
			let responseType = IBResponseType(rawValue: responseValue) else {
			print("Unknown response type \(String(data: data, encoding: .utf8).debugDescription)")
			return
		}
				
		do {
			
			switch responseType {
					
				case .ERR_MSG:
					let object = try decoder.decode(IBServerError.self)
					subject.send(object)
					
				case .NEXT_VALID_ID:
					let object = try decoder.decode(IBNextRequestID.self)
					_nextValidID = object.value
					
				case .CURRENT_TIME:
					let object = try decoder.decode(IBServerTime.self)
					subject.send(object)
				
				case .ACCT_VALUE:
					let object = try decoder.decode(IBAccountValue.self)
				self.subject.send(object)

				case .ACCT_UPDATE_TIME:
					let object = try decoder.decode(IBAccountUpdateTime.self)
					self.subject.send(object)

				case .PORTFOLIO_VALUE:
					let object = try decoder.decode(IBPortfolioValue.self)
					self.subject.send(object)

				case .ACCT_DOWNLOAD_END:
					let object = try decoder.decode(IBAccountValueEnd.self)
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
					
				case .ORDER_STATUS:
					let object = try decoder.decode(IBOrderStatus.self)
					self.subject.send(object)
					
				case .COMPLETED_ORDER:
					let object = try decoder.decode(IBOrderCompetion.self)
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
					
				case .HISTORICAL_DATA:
					let object = try decoder.decode(IBPriceHistory.self)
					self.subject.send(object)
					
				case .HISTORICAL_DATA_UPDATE:
					let object = try decoder.decode(IBPriceBarUpdate.self)
					self.subject.send(object)
					
				case .REAL_TIME_BARS:
					let object = try decoder.decode(IBPriceBarUpdate.self)
					self.subject.send(object)
					
					
				//TODO: market rule to conform protocol
				case .MARKET_RULE:
					let object = try decoder.decode(IBMarketRule.self)
					self.subject.send(object)
					
				case .TICK_PRICE:
					let object = try decoder.decode(TickPriceParser.self)
					object.ticks.forEach({ self.subject.send($0) })
					
				case .TICK_SIZE:
					let object = try decoder.decode(IBTick.self)
					self.subject.send(object)
					
				//TODO: tick string to conform protocol
				case .TICK_STRING:
					let object = try decoder.decode(IBTickStringParser.self)
					if object.type == .LastTimestamp{
						print("\(#function)", object)
					} else {
						print("\(#function)", object)
					}
					
				case .HISTORICAL_TICKS:
					let object = try decoder.decode(HistoricalTickParser.self)
					object.ticks.forEach({ self.subject.send($0) })
					
				case .HISTORICAL_TICKS_BID_ASK:
					let object = try decoder.decode(HistoricalTicksBidAskPerser.self)
					object.ticks.forEach({ self.subject.send($0) })
					
				case .HISTORICAL_TICKS_LAST:
					let object = try decoder.decode(HistoricalTicksLastParser.self)
					object.ticks.forEach({ self.subject.send($0) })
					
				case .TICK_BY_TICK:
					let object = try decoder.decode(TickByTickParser.self)
					object.ticks.forEach({ self.subject.send($0) })
					
				case .TICK_EFP:
					let object = try decoder.decode(IBEFPEvent.self)
					self.subject.send(object)
					
				case .TICK_OPTION_COMPUTATION:
					let object = try decoder.decode(IBOptionComputation.self)
					self.subject.send(object)
					
				case .TICK_REQ_PARAMS:
					let object = try decoder.decode(IBTickParameters.self)
					self.subject.send(object)
					
				case .MARKET_DATA_TYPE:
					let object = try decoder.decode(IBCurrentMarketDataType.self)
					self.subject.send(object)
					
				case .TICK_GENERIC:
					print(decoder.buffer)
					
				case .NEWS_BULLETINS:
					let object = try decoder.decode(IBNewsBulletin.self)
					print(object)
					
				default:
					print("response \(responseType) not handled")
			}
			
		} catch {
			print(error.localizedDescription)
		}
		
	}
	
}
