//
//  IBPriceCondition.swift
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



public struct IBPriceCondition: OperatorCondition {

	public var value: Double
	
	public var argument: ConditionOperator

	public enum TriggerType: Int, Codable, CustomStringConvertible {
		case doubleBidAsk       = 1
		case last               = 2
		case doubleLast         = 3
		case bidAsk             = 4
		case lastBidAsk         = 7
		case midPoint           = 8
		
		public var description: String {
			switch self {
			case .doubleBidAsk:     return "double bid / ask"
			case .last:             return "ask"
			case .doubleLast:       return "double last"
			case .bidAsk:           return "bid / ask"
			case .lastBidAsk:       return "last bid / ask"
			case .midPoint:         return "mid point"
			}
		}
	}
	
	public var triggerType: TriggerType

	public var contractID: Int
	
	public var market: String
	
	public static func isGreater (_ value: Double, trigger: TriggerType, contractID: Int, market: String) -> IBPriceCondition {
		return IBPriceCondition(value: value, argument: .isGreater, triggerType: trigger,  contractID: contractID, market: market)
	}
	
	public static func isLess (_ value: Double, trigger: TriggerType, contractID: Int, market: String) -> IBPriceCondition {
		return IBPriceCondition(value: value, argument: .isLess, triggerType: trigger,  contractID: contractID, market: market)
	}
	
	public var type: IBConditionType { return .price }

	
}

extension IBPriceCondition: CustomStringConvertible {

	public var description: String {
		return String(format:"Price %@ %.2f %@", argument.description, value, triggerType.description )
	}

}

extension IBPriceCondition: Codable {
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(argument)
		try container.encode(value)
		try container.encode(contractID)
		try container.encode(market)
		try container.encode(triggerType)
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.argument = try container.decode(ConditionOperator.self)
		self.value = try container.decode(Double.self)
		self.contractID = try container.decode(Int.self)
		self.market = try container.decode(String.self)
		self.triggerType = try container.decode(TriggerType.self)

	}
	
}
