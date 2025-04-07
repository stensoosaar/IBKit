//
//  IBBarSource.swift
//  IBKit
//
//  Created by Sten Soosaar on 27.02.2025.
//


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




public enum IBBarSource: String, Encodable, Sendable {
	case trades = "TRADES"
	case midpoint = "MIDPOINT"
	case bid = "BID"
	case ask = "ASK"
	case bidAsk = "BID_ASK"
	case adjustedLast = "ADJUSTED_LAST"
	case historicalVolatility = "HISTORICAL_VOLATILITY"
	case impliedOptionVolatility = "OPTION_IMPLIED_VOLATILITY"
	case rebateRate = "REBATE_RATE"
	case feeRate = "FEE_RATE"
	case yieldBid = "YIELD_BID"
	case yieldAsk = "YIELD_ASK"
	case yieldBidAsk = "YIELD_BID_ASK"
	case yieldLast = "YIELD_LAST"
	case schedule = "SCHEDULE"
	case aggTrades = "AGGTRADES"
}


