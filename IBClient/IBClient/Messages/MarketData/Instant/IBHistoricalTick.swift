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


public struct IBHistoricalTick: IBEvent{
	public let ticks: [TickQuote]
	public let done: Bool
}


extension IBHistoricalTick: Decodable {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let tickCount = try container.decode(Int.self)
		var buffer:[TickQuote] = []
		for _ in 0..<tickCount {
			let time = try container.decode(Double.self)
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)
			let date = Date(timeIntervalSince1970: time)

			buffer.append(
				TickQuote(type: .Last, price: price, size: size, date: date, attributes: [])
			)
		}
		ticks = buffer
		done = try container.decode(Bool.self)
	}	
}



extension IBResponseWrapper where T == IBHistoricalTick {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}
