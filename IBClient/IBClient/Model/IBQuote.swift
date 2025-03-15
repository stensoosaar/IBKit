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


public enum IBQuoteType: Int, Codable, Sendable, CustomStringConvertible {
	case bid = 0
	case ask = 1
	case trade = 2
	case mark = 3
	
	public var description: String{
		switch self {
		case .bid: return "BID"
		case .ask: return "ASK"
		case .trade: return "TRADE"
		case .mark: return "MARK"
		}
	}
	
}


public protocol AnyQuote: IBMarketData {
	var type: IBQuoteType {get}
	var date: Date {get}
}


public struct IBQuote: AnyQuote {
	public var type: IBQuoteType
	public var price: Double
	public var size: Double
	public var date: Date
	public var exchange: String?
	public var delayed: Bool = false
}


public struct IBPriceQuote: AnyQuote {
	public var type: IBQuoteType
	public var price: Double
	public var date: Date
	public var exchange: String?
	public var delayed: Bool = false
}


public struct IBSizeQuote: AnyQuote {
	public var type: IBQuoteType
	public var size: Double
	public var date: Date
	public var exchange: String?
	public var delayed: Bool = false
}


public struct IBYieldQuote: AnyQuote {
	public var type: IBQuoteType
	public var yield: Double
	public var date: Date
	public var exchange: String?
	public var delayed: Bool = false
}
