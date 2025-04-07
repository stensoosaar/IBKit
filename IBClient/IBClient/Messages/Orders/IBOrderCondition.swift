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




public struct IBOrderCondition: IBCodable, Sendable {
	
	public enum Connector: Int, Codable, Hashable, Sendable {
		case and = 1
		case or = 0
	}
	
	public enum Argument: Int, Codable, Sendable {
		case isGreater = 1
		case isLess = 0
	}
	
	public enum ConditionType: IBCodable, Sendable {
		case price(_ argument: Argument, price: Double, trigger: IBOrder.TriggerMethod, contractID: Int, exchange: IBExchange)
		case time(_ argument: Argument, date: Date)
		case margin(_ argument: Argument, value: Double)
		case execution(_ type: IBSecuritiesType, symbol: String, market: IBExchange)
		case volume (_ argument: Argument, value: Double, contractID: Int, exchange: IBExchange)
		case changePerCent(_ argument: Argument, value: Double, contractID: Int, exchange: IBExchange)
		
		var rawValue: Int {
			switch self {
			case .price: return 1
			case .time: return 3
			case .margin: return 4
			case .execution: return 5
			case .volume: return 6
			case .changePerCent: return 7
			}
		}
		
		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			let type = try container.decode(Int.self)
			switch type{
			case 1:
				let argument = try container.decode(IBOrderCondition.Argument.self)
				let value = try container.decode(Double.self)
				let trigger = try container.decode(IBOrder.TriggerMethod.self)
				let contractID = try container.decode(Int.self)
				let exchange = try container.decode(IBExchange.self)
				self = .price(argument, price: value, trigger: trigger, contractID: contractID, exchange: exchange)
			case 3:
				let argument = try container.decode(IBOrderCondition.Argument.self)
				let value = try container.decode(Date.self)
				self = .time(argument, date: value)
			case 4:
				let argument = try container.decode(IBOrderCondition.Argument.self)
				let value = try container.decode(Double.self)
				self = .margin(argument, value: value)
			case 5:
				let type = try container.decode(IBSecuritiesType.self)
				let symbol = try container.decode(String.self)
				let market = try container.decode(IBExchange.self)
				self = .execution(type, symbol: symbol, market: market)
			case 6:
				let argument = try container.decode(IBOrderCondition.Argument.self)
				let value = try container.decode(Double.self)
				let contractID = try container.decode(Int.self)
				let exchange = try container.decode(IBExchange.self)
				self = .volume(argument, value: value, contractID: contractID, exchange: exchange)
			default:
				let argument = try container.decode(IBOrderCondition.Argument.self)
				let value = try container.decode(Double.self)
				let contractID = try container.decode(Int.self)
				let exchange = try container.decode(IBExchange.self)
				self = .changePerCent(argument, value: value, contractID: contractID, exchange: exchange)
			}

		}
		
		public func encode(to encoder: IBEncoder) throws {
			var container = encoder.unkeyedContainer()
			try container.encode(self.rawValue)
			switch self{
			case .price(let argument, let price, let trigger, let contractID, let exchange):
				try container.encode(self.rawValue)
				try container.encode(argument)
				try container.encode(price)
				try container.encode(contractID)
				try container.encode(exchange)
				try container.encode(trigger)
			case .time(let argument, let date):
				try container.encode(self.rawValue)
				try container.encode(argument)
				try container.encode(date)
			case .margin(let  argument, let value):
				try container.encode(self.rawValue)
				try container.encode(argument)
				try container.encode(value)
			case .execution(let contractType, let symbol, let market):
				try container.encode(self.rawValue)
				try container.encode(contractType)
				try container.encode(market)
				try container.encode(symbol)
			case .volume(let argument, let value, let contractID, let exchange):
				try container.encode(self.rawValue)
				try container.encode(argument)
				try container.encode(value)
				try container.encode(contractID)
				try container.encode(exchange)
			case .changePerCent(let argument, let value, let contractID, let exchange):
				try container.encode(self.rawValue)
				try container.encode(argument)
				try container.encode(value)
				try container.encode(contractID)
				try container.encode(exchange)
			}

		}
		
	}
		
	public var buffer:[ConditionType] = []
	
	public var count: Int { buffer.count }
	
	public init(_ condition: ConditionType){
		buffer.append(condition)
	}
	
	mutating public func and(_ condition: ConditionType){
		buffer.append(condition)
	}
	
	
	mutating public func or(_ condition: ConditionType){
		buffer.append(condition)
	}
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let count = try container.decode(Int.self)

		for _ in 0..<count {
			
			
		}
		
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(buffer.count)
		for element in buffer{
		}
	}
	
}
