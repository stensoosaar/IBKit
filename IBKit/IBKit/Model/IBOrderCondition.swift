//
//  IBCondition.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		Redistributions of source code must retain the above copyright notice,
//		this list of conditions and the following disclaimer.
//
//		Redistributions in binary form must reproduce the above copyright
//		notice, this list of conditions and the following disclaimer in the
//		documentation and/or other materials provided with the distribution.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//	POSSIBILITY OF SUCH DAMAGE.
//



import Foundation




public struct IBOrderCondition: IBCodable {
	
	public enum Connector: Int, Codable, Hashable {
		case and 					= 1
		case or 					= 0
	}
	
	public enum Argument: Int, Codable {
		case isGreater 				= 1
		case isLess					= 0
	}
	
	public enum ConditionType: IBCodable {
		case price(_ argument: Argument, price: Double, trigger: IBOrder.TriggerMethod, contractID: Int, exchange: IBExchange)
		case time(_ argument: Argument, date: Date)
		case margin(_ argument: Argument, value: Double)
		case execution(_ type: IBSecuritiesType, symbol: String, market: IBExchange)
		case volume (_ argument: Argument, value: Double, contractID: Int, exchange: IBExchange)
		case changePerCent(_ argument: Argument, value: Double, contractID: Int, exchange: IBExchange)
		
		var rawValue: Int {
			switch self {
			case .price: 			return 1
			case .time: 			return 3
			case .margin: 			return 4
			case .execution: 		return 5
			case .volume: 			return 6
			case .changePerCent: 	return 7
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
