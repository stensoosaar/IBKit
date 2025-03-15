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
 Bid Size
 Ask Size
 Last Size
 Delayed Bid Size
 Delayed Ask Size
 Delayed Last Size
 
 Volume
 Average Volume
 Open Interest
 Option Call Open Interest
 Option Put Open Interest
 Option Call Volume
 Option Put Volume
 Auction Volume
 Auction Imbalance
 Regulatory Imbalance
 Short-Term Volume 3 Minutes
 Short-Term Volume 5 Minutes
 Short-Term Volume 10 Minutes
 Delayed Volume
 Futures Open Interest
 Average Option Volume
 Shortable Shares
 */


public struct IBTickSize: IBEvent {
	public let requestID: Int
	public var tick: IBMarketData
}
	
extension IBTickSize: IBDecodable{
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		let value = try container.decode(Double.self)
		let date = Date()
		
		switch type{
		case .BidSize:
			tick = IBSizeQuote(type: .bid, size: value, date: date)
		case .AskSize:
			tick = IBSizeQuote(type: .ask, size: value, date: date)
		case .LastSize:
			tick = IBSizeQuote(type: .trade, size: value, date: date)
		default:
			tick = IBTick(type: type, value: value, date: date)
		}


	}
}


