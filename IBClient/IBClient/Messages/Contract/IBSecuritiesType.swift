//
//  IBSecuritiesType.swift
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

public enum IBSecuritiesType: String, Codable, Sendable {
	case stock          	= "STK"
	case option         	= "OPT"
	case forex          	= "CASH"
	case index          	= "IND"
	case future         	= "FUT"
	case continousFuture	= "CONTFUT"
	case debt           	= "BOND"
	case fund           	= "FUND"
	case etf            	= "ETF"
	case commodity      	= "CMDTY"
	case warrant        	= "WAR"
	case combo          	= "BAG"
	case futureOption   	= "FOP"
	case news           	= "NEWS"
	case cfd            	= "CFD"
	case structuredProduct	= "IOPT"
	case crypto				= "CRYPTO"
	case ssf				= "SSF"
}


extension IBSecuritiesType: CustomStringConvertible {
	
	public var description: String {
		switch self{
			case .stock:          		return "STOCK"
			case .option:         		return "OPTION"
			case .forex:          		return "FOREX"
			case .index:          		return "INDEX"
			case .future:         		return "FUTURE"
			case .continousFuture:		return "CONT. FUTURE"
			case .debt:           		return "BOND"
			case .fund:           		return "FUND"
			case .etf:            		return "ETF"
			case .commodity:      		return "COMMODITY"
			case .warrant:        		return "WARRANT"
			case .combo:          		return "BAG"
			case .futureOption:   		return "FOP"
			case .news:           		return "NEWS"
			case .cfd:            		return "CFD"
			case .structuredProduct:	return "STRUCTURED PRODUCT"
			case .crypto:				return "CRYPTO"
			case .ssf:					return "WTF??"
		}
	}
	
}


extension IBSecuritiesType {
	
	internal var validBarTypes: [IBBarSource] {
		switch self {
			case .stock:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .historicalVolatility, .impliedOptionVolatility, .schedule]
				
			case .option:
				return [.trades, .midpoint, .bid, .ask, .bidAsk]
				
			case .forex:
				return [.midpoint, .bid, .ask, .bidAsk, .schedule]
			
			case .index:
				return [.trades, .historicalVolatility, .impliedOptionVolatility, .schedule]

			case .future, .continousFuture:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .schedule]

			case .debt:
				return [.midpoint, .bid, .ask, .bidAsk, .schedule]

			case .fund:
				return [.midpoint, .bid, .ask, .bidAsk, .schedule]

			case .etf:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .historicalVolatility, .impliedOptionVolatility, .schedule]

			case .commodity:
				return [.midpoint, .bid, .ask, .bidAsk, .schedule]

			case .warrant:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .schedule]

			case .combo:
				return []

			case .futureOption:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .schedule]

			case .news:
				return []

			case .cfd:
				return [.midpoint, .bid, .ask, .bidAsk, .schedule]

			case .structuredProduct:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .schedule]

			case .crypto:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .schedule]
				
			case .ssf:
				return [.trades, .midpoint, .bid, .ask, .bidAsk, .schedule]


		}
	}
	
}
