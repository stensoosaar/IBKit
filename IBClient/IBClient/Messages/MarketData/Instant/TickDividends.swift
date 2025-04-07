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



/// Returns dividend information
public struct TickDividends: AnyTickEvent {
	
	/// The sum of dividends for the past 12 months.
	public var paid: Double
	
	/// The sum of dividends for the next 12 months.
	public var expected: Double
	
	/// The next dividend date
	public var nextDate: String
	
	/// The next single dividend amount.
	public var nextAmount: Double
	
}


extension TickDividends: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		decoder.dateDecodingStrategy = .eodPriceHistoryFormat
		let components = try container.decode(String.self).components(separatedBy: ",")
		guard components.count == 4,
			  let paid = Double(components[0]),
			  let expected = Double(components[1]),
			  let nextAmount = Double(components[3])
		else {
			throw  IBError.decodingError("failed to decode dividend info")
		}
		self.paid = paid
		self.expected = expected
		self.nextDate = components[2]
		self.nextAmount = nextAmount

	}
}
