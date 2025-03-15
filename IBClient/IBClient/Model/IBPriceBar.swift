//
//  IBPriceBar.swift
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


public struct IBPriceBar: IBObject, Sendable {
	public var date: Date
	public var open: Double
	public var high: Double
	public var low: Double
	public var close: Double
	public var volume: Double?
	public var vwap: Double?
	public var count: Int?
}

extension IBPriceBar: IBDecodable {
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.date = try container.decode(Date.self)
		self.open = try container.decode(Double.self)
		self.high = try container.decode(Double.self)
		self.low = try container.decode(Double.self)
		self.close = try container.decode(Double.self)
		self.volume = try container.decodeOptional(Double.self)
		self.vwap = try container.decodeOptional(Double.self)
		self.count = try container.decodeOptional(Int.self)
	}
}
