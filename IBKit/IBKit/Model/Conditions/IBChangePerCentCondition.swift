//
//  IBChangePerCentCondition.swift
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


public struct IBChangePerCentCondition: OperatorCondition {
	
	public var value: Double
	public var contractID: Int
	public var market: String
	
	public var argument: ConditionOperator
	
	public static func isGreater (_ value: Double, contractID: Int, market: String) -> IBChangePerCentCondition {
		return IBChangePerCentCondition(value: value, argument: .isGreater, contractID: contractID, market: market)
	}
	
	public static func isLess (_ value: Double, contractID: Int, market: String) -> IBChangePerCentCondition {
		return IBChangePerCentCondition(value: value, argument: .isLess, contractID: contractID, market: market)
	}
	
	init(value: Double, argument: ConditionOperator, contractID: Int, market: String) {
		self.value = value
		self.argument = argument
		self.contractID = contractID
		self.market = market
	}

	public var type: IBConditionType { return .percentChange }

}

extension IBChangePerCentCondition: CustomStringConvertible{
	
	public var description: String {
		return String(format:"Change Per Cent %@ %.2f", argument.description, value)
	}
	
}

extension IBChangePerCentCondition: Codable {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		argument = try container.decode(ConditionOperator.self)
		value = try container.decode(Double.self)
		contractID = try container.decode(Int.self)
		market = try container.decode(String.self)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(argument)
		try container.encode(value)
		try container.encode(contractID)
		try container.encode(market)

	}
	
}
