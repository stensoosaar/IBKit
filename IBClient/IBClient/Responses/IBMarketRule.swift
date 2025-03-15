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



public struct IBMarketRule: IBEvent {

	struct PriceIncrement: IBDecodable {
		var lowerBound: Double
		var step: Double

		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			self.lowerBound = try container.decode(Double.self)
			self.step = try container.decode(Double.self)
		}
	}

	var marketRuleId: Int
	var values: [PriceIncrement] = []
	
}

extension IBMarketRule: IBDecodable{
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		marketRuleId = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		for _ in 0..<count{
			let value = try container.decode(PriceIncrement.self)
			values.append(value)
		}
	}
}

