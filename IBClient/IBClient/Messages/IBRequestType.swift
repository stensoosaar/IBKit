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

public enum IBRequestType: Int, Encodable, Sendable {
	case marketData = 1
	case cancelMarketData = 2
	case placeOrder = 3
	case cancelOrder = 4
	case openOrders = 5
	case accountData = 6
	case executions = 7
	case nextId = 8
	case contractData = 9
	case marketDepth = 10
	case cancelMarketDepth = 11
	case newsBulletins = 12
	case cancelNewsBulletins = 13
	case serverLogLevel = 14
	case autoOpenOrders = 15
	case allOpenOrders = 16
	case managedAccounts = 17
	case financialAdvisor = 18
	case replaceFinancialAdvisor = 19
	case historicalData = 20
	case exerciseOptions = 21
	case scannerSubscription = 22
	case cancelScannerSubscription = 23
	case scannerParameters = 24
	case cancelHistoricalData = 25
	case serverTime = 49
	case realTimeBars = 50
	case cancelRealTimeBars = 51
	case fundamentalData = 52
	case cancelFundamentalData = 53
	case impliedVolatility = 54
	case optionPrice = 55
	case cancelImpliedVolatility = 56
	case cancelOptionPrice = 57
	case globalCancel = 58
	case marketDataType = 59
	case positions = 61
	case accountSummary = 62
	case cancelAccountSummary = 63
	case cancelPositions = 64
	case verifyRequest = 65
	case verifyMessage = 66
	case queryDisplayGroups = 67
	case groupEvents = 68
	case updatedisplayGroup = 69
	case cancelGroupEvents = 70
	case startAPI = 71
	case verifyAndAuthentRequest = 72
	case verifyAndAuthentMessage = 73
	case positionsMulti = 74
	case cancelPositionsMulti = 75
	case accountUpdatesMulti = 76
	case cancelAccountUpdatesMulti = 77
	case optionParameters = 78
	case softDollarTiers = 79
	case familyCodes = 80
	case matchingSymbols = 81
	case marketDepthExchanges = 82
	case smartComponents = 83
	case newsArticle = 84
	case newsProviders = 85
	case historicalNews = 86
	case headTimestamp = 87
	case histogramData = 88
	case cancelHistogramData = 89
	case cancelHeadTimestamp = 90
	case marketRule = 91
	case accountPNL = 92
	case cancelAccountPNL = 93
	case singlePNL = 94
	case cancelSinglePNL = 95
	case tickHistory = 96
	case tickByTickData = 97
	case cancelTickByTickData = 98
	case completedOrders = 99
	case WSH_META_DATA = 100
	case CANCEL_WSH_META_DATA = 101
	case WSH_EVENT_DATA = 102
	case CANCEL_WSH_EVENT_DATA = 103
	case requestUserInfo = 104
}


extension IBRequestType{
	
	var isCancellable: Bool {
		switch self{
		case .accountPNL: return true
		case .accountSummary: return true
		case .accountUpdatesMulti: return true
		case .fundamentalData: return true
		case .historicalData: return true
		case .histogramData: return true
		case .headTimestamp: return true
		case .impliedVolatility: return true
		case .marketData: return true
		case .marketDepth: return true
		case .newsBulletins: return	true
		case .optionPrice: return true
		case .positions: return true
		case .positionsMulti: return true
		case .placeOrder: return true
		case .realTimeBars: return true
		case .scannerSubscription: return true
		case .singlePNL: return true
		case .tickByTickData: return true
		case .WSH_META_DATA: return true
		case .WSH_EVENT_DATA: return true
		default: return false
		}
	}
}
