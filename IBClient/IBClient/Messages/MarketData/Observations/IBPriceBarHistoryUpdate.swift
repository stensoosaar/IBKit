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


public struct IBPriceBarHistoryUpdate: AnyMarketData {
	public let bar: IBPriceBar
}


extension IBPriceBarHistoryUpdate: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let barCount = try container.decode(Int.self)
		let date = try container.decode(Date.self)
		let open = try container.decode(Double.self)
		let close = try container.decode(Double.self)
		let high = try container.decode(Double.self)
		let low = try container.decode(Double.self)
		let wap = try container.decodeOptional(Double.self)
		let volume = try container.decodeOptional(Double.self)
			
		bar = IBPriceBar(
			date: date,
			open: open,
			high: high,
			low: low,
			close: close,
			volume: volume,
			vwap: wap,
			count: barCount
		)
	}
}


extension IBResponseWrapper where T == IBPriceBarHistoryUpdate {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}
