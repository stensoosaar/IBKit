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

public enum IBResponseType: Int, Decodable {
	case TICK_PRICE = 1
	case TICK_SIZE = 2
	case ORDER_STATUS = 3
	case ERROR = 4
	case OPEN_ORDER = 5
	case ACCT_VALUE = 6
	case PORTFOLIO_VALUE = 7
	case ACCT_UPDATE_TIME = 8
	case NEXT_VALID_ID = 9
	case CONTRACT_DATA = 10
	case EXECUTION_DATA = 11
	case MARKET_DEPTH = 12
	case MARKET_DEPTH_L2 = 13
	case NEWS_BULLETINS = 14
	case MANAGED_ACCTS = 15
	case RECEIVE_FA = 16
	case HISTORICAL_DATA = 17
	case BOND_CONTRACT_DATA = 18
	case SCANNER_PARAMETERS = 19
	case SCANNER_DATA = 20
	case TICK_OPTION_COMPUTATION = 21
	case TICK_GENERIC = 45
	case TICK_STRING = 46
	case TICK_EFP = 47
	case CURRENT_TIME = 49
	case REAL_TIME_BARS = 50
	case FUNDAMENTAL_DATA = 51
	case CONTRACT_DATA_END = 52
	case OPEN_ORDER_END = 53
	case ACCT_DOWNLOAD_END = 54
	case EXECUTION_DATA_END = 55
	case DELTA_NEUTRAL_VALIDATION = 56
	case TICK_SNAPSHOT_END = 57
	case MARKET_DATA_TYPE = 58
	case COMMISSION_REPORT = 59
	case POSITION_SIZE = 61
	case POSITION_SIZE_END = 62
	case ACCOUNT_SUMMARY = 63
	case ACCOUNT_SUMMARY_END = 64
	case POSITION_SIZE_MULTI = 71
	case POSITION_SIZE_MULTI_END = 72
	case ACCOUNT_UPDATE_MULTI = 73
	case ACCOUNT_UPDATE_MULTI_END = 74
	case OPTION_PARAMETER = 75
	case OPTION_PARAMETER_END = 76
	case SOFT_DOLLAR_TIERS = 77
	case FAMILY_CODES = 78
	case SYMBOL_SAMPLES = 79
	case MKT_DEPTH_EXCHANGES = 80
	case TICK_REQ_PARAMS = 81
	case SMART_COMPONENTS = 82
	case NEWS_ARTICLE = 83
	case TICK_NEWS = 84
	case NEWS_PROVIDERS = 85
	case HISTORICAL_NEWS = 86
	case HISTORICAL_NEWS_END = 87
	case HEAD_TIMESTAMP = 88
	case HISTOGRAM_DATA = 89
	case HISTORICAL_DATA_UPDATE = 90
	case REROUTE_MKT_DATA_REQ = 91
	case REROUTE_MKT_DEPTH_REQ = 92
	case MARKET_RULE = 93
	case ACCOUNT_PNL = 94
	case POSITION_PNL = 95
	case HISTORICAL_TICKS = 96
	case HISTORICAL_TICKS_BID_ASK = 97
	case HISTORICAL_TICKS_LAST = 98
	case TICK_BY_TICK = 99
	case ORDER_BOUND = 100
	case COMPLETED_ORDER = 101
	case COMPLETED_ORDERS_END = 102
	case REPLACE_FA_END = 103
	case WSH_META_DATA = 104
	case WSH_EVENT_DATA = 105
	case HISTORICAL_SCHEDULE = 106
	case USER_INFO = 107
}

extension IBResponseType{
	var objectType: Decodable.Type? {
		switch self {
		case .ERROR: return IBError.self
		case .MANAGED_ACCTS: return IBManagedAccounts.self
		case .NEXT_VALID_ID: return IBNextRequestID.self
		case .ACCOUNT_SUMMARY: return IBAccountSummary.self
		case .ACCOUNT_SUMMARY_END: return IBAccountSummaryEnd.self
		case .ACCOUNT_UPDATE_MULTI: return IBAccountUpdateMulti.self
		case .ACCOUNT_UPDATE_MULTI_END: return IBAccountUpdateMultiEnd.self
		case .ACCT_UPDATE_TIME: return IBAccountUpdateTime.self
		case .ACCT_VALUE: return IBAccountUpdate.self
		case .ACCT_DOWNLOAD_END: return IBAccountUpdateEnd.self
		case .ACCOUNT_PNL: return IBAccountPNL.self
		case .POSITION_PNL: return IBPositionPNL.self
		case .CURRENT_TIME: return IBServerTime.self
		case .PORTFOLIO_VALUE: return IBPositionUpdate.self
		case .POSITION_SIZE: return IBPositionSize.self
		case .POSITION_SIZE_END: return IBPositionSizeEnd.self
		case .POSITION_SIZE_MULTI: return IBPositionSizeMulti.self
		case .POSITION_SIZE_MULTI_END: return IBPositionSizeMultiEnd.self
		case .OPEN_ORDER: return IBOpenOrder.self
		case .OPEN_ORDER_END: return IBOpenOrderEnd.self
		case .MARKET_RULE: return IBMarketRule.self
		case .ORDER_BOUND: return IBOrderBounds.self
		case .ORDER_STATUS: return IBOrderStatus.self
		case .COMPLETED_ORDER: return IBOrderCompletion.self
		case .COMPLETED_ORDERS_END: return IBOrderCompletionEnd.self
		case .EXECUTION_DATA: return IBOrderExecution.self
		case .EXECUTION_DATA_END: return IBOrderExecutionEnd.self
		case .COMMISSION_REPORT: return IBCommissionReport.self
		case .SYMBOL_SAMPLES: return IBContractSearchResult.self
		case .CONTRACT_DATA: return IBContractDetails.self
		case .CONTRACT_DATA_END: return IBContractDetailsEnd.self
		case .SCANNER_PARAMETERS: return IBScannerParameters.self
		case .SCANNER_DATA:	return IBScannerData.self
		case .FUNDAMENTAL_DATA: return IBFinancialReport.self
		case .HEAD_TIMESTAMP: return IBHeadTimestamp.self
		case .BOND_CONTRACT_DATA: return IBBondDetails.self
		case .OPTION_PARAMETER: return IBOptionChain.self
		case .OPTION_PARAMETER_END: return IBOptionChainEnd.self
		case .MARKET_DEPTH: return IBMarketDepth.self
		case .MARKET_DEPTH_L2: return IBMarketDepthL2.self
		case .NEWS_BULLETINS: return IBBulletin.self
		case .TICK_PRICE: return TickDecoder.self
		case .TICK_SIZE: return TickDecoder.self
		case .TICK_GENERIC: return TickDecoder.self
		case .TICK_STRING: return TickDecoder.self
		case .TICK_OPTION_COMPUTATION: return TickOptionComputation.self
		case .TICK_EFP: return TickEFP.self
		case .TICK_NEWS: return TickNews.self
		case .HISTORICAL_DATA: return IBPriceHistory.self
		case .REAL_TIME_BARS: return IBPriceBarUpdate.self
		case .HISTORICAL_DATA_UPDATE: return IBPriceBarHistoryUpdate.self
		case .MARKET_DATA_TYPE: return IBCurrentMarketDataType.self
		case .MKT_DEPTH_EXCHANGES: return IBMarketDepthExchanges.self
		case .TICK_REQ_PARAMS: return TickParameters.self
		case .NEWS_ARTICLE: return IBNewsArticle.self
		case .NEWS_PROVIDERS: return IBNewsProviders.self
		case .HISTORICAL_NEWS: return IBHistoricalNews.self
		case .HISTORICAL_NEWS_END: return IBHistoricalNewsEnd.self
		case .HISTOGRAM_DATA: return IBHistoricalNewsEnd.self
		case .HISTORICAL_SCHEDULE: return IBHistoricalSchedule.self
		case .HISTORICAL_TICKS: return IBHistoricalTick.self
		case .HISTORICAL_TICKS_BID_ASK: return IBHistoricalTickBidAsk.self
		case .HISTORICAL_TICKS_LAST: return IBHistoricalTickLast.self
		case .TICK_BY_TICK: return IBTickByTick.self
		case .WSH_META_DATA: return IBWSHMeta.self
		case .WSH_EVENT_DATA: return IBWSHEventData.self
		case .SOFT_DOLLAR_TIERS: return nil
		case .REROUTE_MKT_DATA_REQ: return nil
		case .REROUTE_MKT_DEPTH_REQ: return nil
		case .DELTA_NEUTRAL_VALIDATION: return nil
		case .TICK_SNAPSHOT_END: return nil
		case .SMART_COMPONENTS: return nil
		case .RECEIVE_FA: return nil
		case .FAMILY_CODES: return nil
		case .REPLACE_FA_END: return nil
		case .USER_INFO: return nil
		}
	}
}
