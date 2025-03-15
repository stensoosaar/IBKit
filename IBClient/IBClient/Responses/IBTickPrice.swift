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


/**
 Bid Price
 Ask Price
 Last Price
 Mark Price
 Bid Yield
 Ask Yield
 Last Yield
 Last RTH Trade
 Delayed Bid
 Delayed Ask
 Delayed Last
 Delayed Bid Option
 Delayed Ask Option
 Delayed Last Option
 ETF Nav Bid
 ETF Nav Ask
 ETF Nav Last
 ETF Nav Frozen Last
 
 High
 Low
 Close Price
 Open Tick
 Low 13 Weeks
 High 13 Weeks
 Low 26 Weeks
 High 26 Weeks
 Low 52 Weeks
 High 52 Weeks
 Auction Price
 Delayed High Price
 Delayed Low Price
 Delayed Close
 Delayed Open
 Creditman mark price
 Creditman slow mark price
 Delayed Model Option
 ETF Nav Close
 ETF Nav Prior Close
 ETF Nav High
 ETF Nav Low
 
 */


public struct IBTickPrice: IBEvent {
	public var requestID: Int
	public var tick: any IBMarketData
}

extension IBTickPrice: IBDecodable{

	public init(from decoder: IBDecoder) throws {
				
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		let mask = try container.decode(Int.self)
		let date = Date()


		var attr: [IBTickAttribute] = []
		
		if decoder.serverVersion >= IBServerVersion.PAST_LIMIT {
			if mask & 1 != 0 { attr.append(.canAutoExecute)}
			if mask & 2 != 0 { attr.append(.pastLimit)}
		}
		
		if decoder.serverVersion >= IBServerVersion.PRE_OPEN_BID_ASK {
			if mask & 4 != 0 {attr.append(.preOpen)}
		}
		
		
		switch type{
		case .BidPrice:
			tick = IBQuote(type: .bid, price: price, size: size, date: date)
		case .AskPrice:
			tick = IBQuote(type: .ask, price: price, size: size, date: date)
		case .LastPrice:
			tick = IBQuote(type: .trade, price: price, size: size, date: date)
		case .DelayedBid:
			tick = IBQuote(type: .bid, price: price, size: size, date: date, delayed: true)
		case .DelayedAsk:
			tick = IBQuote(type: .ask, price: price, size: size, date: date, delayed: true)
		case .DelayedLast:
			tick = IBQuote(type: .trade, price: price, size: size, date: date, delayed: true)
		case .BidYield:
			tick = IBYieldQuote(type: .bid, yield: price, date: date)
		case .AskYield:
			tick = IBYieldQuote(type: .ask, yield: price, date: date)
		case .LastYield:
			tick = IBYieldQuote(type: .trade, yield: price, date: date)
		default:
			tick = IBTick(type: type, value: price, date: date)
		}
		
		
		
	}
	
}

