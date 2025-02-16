//
//  IBBarSource.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.02.2025.
//


import Foundation




public enum IBBarSource: String, Encodable, Sendable {
	case trades						= "TRADES"
	case midpoint					= "MIDPOINT"
	case bid						= "BID"
	case ask						= "ASK"
	case bidAsk						= "BID_ASK"
	case adjustedLast				= "ADJUSTED_LAST"
	case historicalVolatility		= "HISTORICAL_VOLATILITY"
	case impliedOptionVolatility	= "OPTION_IMPLIED_VOLATILITY"
	case rebateRate					= "REBATE_RATE"
	case feeRate					= "FEE_RATE"
	case yieldBid					= "YIELD_BID"
	case yieldAsk					= "YIELD_ASK"
	case yieldBidAsk				= "YIELD_BID_ASK"
	case yieldLast					= "YIELD_LAST"
	case schedule					= "SCHEDULE"
	case aggTrades					= "AGGTRADES"	
}
