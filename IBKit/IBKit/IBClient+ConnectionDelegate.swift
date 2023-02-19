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
import Network


extension IBClient: IBConnectionDelegate {
	
	func connection(_ connection: NWConnection, didReceiveData data: Data) {
		
		guard let serverVersion = serverVersion else {
			
			guard let comps = String(data: data, encoding: .utf8)?.components(separatedBy: "\0").dropLast(),
				  let versionString = comps.first, let timestampString = comps.last, let version = Int(versionString)
			else {
				fatalError("Cant parse Handshake")
			}
			
			self.serverVersion = version
			self.connectionTime = timestampString
			print("Client connected at \(timestampString), server version \(self.serverVersion ?? 0)")
			return
			
		}
		
		let decoder = IBDecoder(serverVersion: serverVersion)
			
		guard let responseValue = try? decoder.decode(Int.self, from: data),
			let responseType = IBResponseType(rawValue: responseValue)
		else {
			print("Unknown response type \(String(data: data, encoding: .utf8).debugDescription)")
			return
		}
				
		do {
			
			switch responseType {
					
				case .ERR_MSG:
					let object = try decoder.decode(IBServerError.self)
					systemEventFeed.send(object)
					
				case .NEXT_VALID_ID:
					let object = try decoder.decode(IBNextRequestIdentifier.self)
					_nextValidID = object.value
					
				case .CURRENT_TIME:
					let object = try decoder.decode(IBServerTime.self)
					systemEventFeed.send(object)
					
				case .SYMBOL_SAMPLES:
					let object = try decoder.decode(IBContractSearchResult.self)
					self.systemEventFeed.send(object)
					
				case .MANAGED_ACCTS:
					let object = try decoder.decode(IBManagedAccounts.self)
					self.accountEventFeed.send(object)
					
				case .PNL:
					let object = try decoder.decode(IBAccountPNL.self)
					self.accountEventFeed.send(object)
					
				case .ACCOUNT_SUMMARY:
					let object = try decoder.decode(IBAccountSummary.self)
					self.accountEventFeed.send(object)
					
				case .ACCOUNT_SUMMARY_END:
					let object = try decoder.decode(IBAccountSummaryEnd.self)
					self.accountEventFeed.send(object)
					
				case .ACCOUNT_UPDATE_MULTI:
					let object = try decoder.decode(IBAccountSummaryMulti.self)
					self.accountEventFeed.send(object)
					
				case .ACCOUNT_UPDATE_MULTI_END:
					let object = try decoder.decode(IBAccountSummaryMultiEnd.self)
					self.accountEventFeed.send(object)
					
				case .POSITION_DATA:
					let object = try decoder.decode(IBPosition.self)
					self.accountEventFeed.send(object)
					
				case .POSITION_END:
					let object = try decoder.decode(IBPositionEnd.self)
					self.accountEventFeed.send(object)
					
				case .PNL_SINGLE:
					let object = try decoder.decode(IBPositionPNL.self)
					self.accountEventFeed.send(object)
					
				case .POSITION_MULTI:
					let object = try decoder.decode(IBPositionMulti.self)
					self.accountEventFeed.send(object)
					
				case .POSITION_MULTI_END:
					let object = try decoder.decode(IBPositionMultiEnd.self)
					self.accountEventFeed.send(object)
										
				case .OPEN_ORDER:
					let object = try decoder.decode(IBOpenOrder.self)
					self.accountEventFeed.send(object)
					
				case .ORDER_STATUS:
					let object = try decoder.decode(IBOrderStatus.self)
					self.accountEventFeed.send(object)
					
				case .COMPLETED_ORDER:
					let object = try decoder.decode(IBCompletedOrders.self)
					self.accountEventFeed.send(object)
					
				case .COMPLETED_ORDERS_END:
					let object = try decoder.decode(IBCompletedOrdersEnd.self)
					self.accountEventFeed.send(object)
					
				case .EXECUTION_DATA:
					let object = try decoder.decode(IBExecution.self)
					self.accountEventFeed.send(object)
					
				case .EXECUTION_DATA_END:
					let object = try decoder.decode(IBExecutionEnd.self)
					self.accountEventFeed.send(object)
					
				case .COMMISSION_REPORT:
					let object = try decoder.decode(IBCommissionReport.self)
					self.accountEventFeed.send(object)
					
				case .CONTRACT_DATA:
					let object = try decoder.decode(IBContractDetails.self)
					self.marketEventFeed.send(object)
					
				case .CONTRACT_DATA_END:
					let object = try decoder.decode(IBContractDetailsEnd.self)
					self.marketEventFeed.send(object)
					
				case .SECURITY_DEFINITION_OPTION_PARAMETER:
					let object = try decoder.decode(IBOptionChain.self)
					self.marketEventFeed.send(object)
					
				case .SECURITY_DEFINITION_OPTION_PARAMETER_END:
					let object = try decoder.decode(IBOptionChainEnd.self)
					self.marketEventFeed.send(object)
					
				case .FUNDAMENTAL_DATA:
					let object = try decoder.decode(IBFinancialReport.self)
					self.marketEventFeed.send(object)
										
				case .HEAD_TIMESTAMP:
					let object = try decoder.decode(IBHeadTimestamp.self)
					self.marketEventFeed.send(object)
					
				case .HISTORICAL_DATA:
					let object = try decoder.decode(IBPriceHistory.self)
					self.marketEventFeed.send(object)
					
				case .HISTORICAL_DATA_UPDATE:
					let object = try decoder.decode(IBPriceHistoryUpdate.self)
					self.marketEventFeed.send(object)
					
				case .REAL_TIME_BARS:
					let object = try decoder.decode(IBPriceBarUpdate.self)
					self.marketEventFeed.send(object)
					
					
				//TODO: market rule to conform protocol
				case .MARKET_RULE:
					let object = try decoder.decode(IBMarketRule.self)
					print(object)
					//self.marketEvents.send(object)
					
				case .TICK_PRICE:
					let object = try decoder.decode(TickPriceParser.self)
					object.ticks.forEach({ self.marketEventFeed.send($0) })
					
				case .TICK_SIZE:
					let object = try decoder.decode(IBTickEvent.self)
					self.marketEventFeed.send(object)
					
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
					object.ticks.forEach({ self.marketEventFeed.send($0) })
					
				case .HISTORICAL_TICKS_BID_ASK:
					let object = try decoder.decode(HistoricalTicksBidAskPerser.self)
					object.ticks.forEach({ self.marketEventFeed.send($0) })
					
				case .HISTORICAL_TICKS_LAST:
					let object = try decoder.decode(HistoricalTicksLastParser.self)
					object.ticks.forEach({ self.marketEventFeed.send($0) })
					
				case .TICK_BY_TICK:
					let object = try decoder.decode(TickByTickParser.self)
					object.ticks.forEach({ self.marketEventFeed.send($0) })
					
				case .TICK_EFP:
					let object = try decoder.decode(IBEFPEvent.self)
					self.marketEventFeed.send(object)
					
				case .TICK_OPTION_COMPUTATION:
					let object = try decoder.decode(IBOptionComputationEvent.self)
					self.marketEventFeed.send(object)
					
				case .TICK_REQ_PARAMS:
					let object = try decoder.decode(IBTickParameters.self)
					self.marketEventFeed.send(object)
					
				case .MARKET_DATA_TYPE:
					let object = try decoder.decode(MarketDataType.self)
					self.marketEventFeed.send(object)
					
				case .TICK_GENERIC:
					print(decoder.buffer)
					
				case .NEWS_BULLETINS:
					let object = try decoder.decode(NewsBulletin.self)
					print(object)
					
				default:
					print("response type \(responseType) not handled")
			}
			
		} catch {
			print(error.localizedDescription)
		}
		
	}
	
}
