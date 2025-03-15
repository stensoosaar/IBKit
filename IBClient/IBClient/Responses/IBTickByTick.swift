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


struct IBTickByTick: IBEvent {
	public let requestID: Int
	public var ticks: [AnyQuote] = []
}

extension IBTickByTick: IBDecodable{
	
	init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		let time = try container.decode(Double.self)
		let tickType = try container.decode(Int.self)

		if tickType == 1 || tickType == 2 {
			
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)

			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.pastLimit)}
			if mask & 2 != 0 { attr.append(.unreported)}

			let exchange = try container.decode(String.self)
			_ = try container.decode(String.self)
			let temp = IBQuote(type:.trade, price: price, size: size, date:  Date(timeIntervalSince1970: time), exchange: exchange)
			ticks.append(temp)

		} else if tickType == 3{
			
			let bidPrice = try container.decode(Double.self)
			let askPrice = try container.decode(Double.self)
			let bidSize = try container.decode(Double.self)
			let askSize = try container.decode(Double.self)
			
			ticks.append(IBQuote(type:.bid, price: bidPrice, size: bidSize, date:  Date(timeIntervalSince1970: time)))
			ticks.append(IBQuote(type:.ask, price: askPrice, size: askSize, date:  Date(timeIntervalSince1970: time)))
			
			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.bidPastLow)}
			if mask & 2 != 0 { attr.append(.askPastHigh)}

		} else if tickType == 4 {
			let midPoint = try container.decode(Double.self)
			ticks.append(IBPriceQuote(type:.mark, price: midPoint, date:  Date(timeIntervalSince1970: time)))

		}
	}
}
