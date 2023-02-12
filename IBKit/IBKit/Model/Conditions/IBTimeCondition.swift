//
//  IBTimeCondition.swift
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


public struct IBTimeCondition: OperatorCondition {
	
	public var value: Date
	public var argument: ConditionOperator
	
	public static func isGreater (_ value: Date) -> IBTimeCondition {
		return IBTimeCondition(value: value, argument: .isGreater)
	}
	
	public static func isLess (_ value: Date) -> IBTimeCondition {
		return IBTimeCondition(value: value, argument: .isLess)
	}
	
	static var dateFormatter: DateFormatter {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_US_POSIX")
		df.timeZone = TimeZone(abbreviation: "UTC")
		df.dateFormat = "yyyyMMdd HH:mm:ss zzz"
		return df
	}
	
	public var type: IBConditionType { return .time }

	
}


extension IBTimeCondition: CustomStringConvertible {

	public var description: String {
		let df = IBTimeCondition.dateFormatter
		return String(format:"Time %@ %@", argument.description, df.string(from: value))
	}
	
}


extension IBTimeCondition: Codable {
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(argument)
		if let encoder = encoder as? IBEncoder{ encoder.dateFormatter = IBTimeCondition.dateFormatter }
		try container.encode(value)
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.argument = try container.decode(ConditionOperator.self)
		if let decoder = decoder as? IBDecoder{ decoder.dateFormatter = IBTimeCondition.dateFormatter }
		self.value = try container.decode(Date.self)

	}
	
}
