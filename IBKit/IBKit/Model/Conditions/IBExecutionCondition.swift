//
//  IBExecutionCondition.swift
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


public struct IBExecutionCondition: AnyCondition {
	
	public var securitiesType: IBSecuritiesType
	public var market: String
	public var symbol: String
	
	public init(type: IBSecuritiesType, symbol: String, market: String){
		self.securitiesType = type
		self.symbol = symbol
		self.market = market
	}
	
	public var type: IBConditionType { return .execution }

}

extension IBExecutionCondition: CustomStringConvertible {

	public var description: String {
		return String(format:"Execution %@ %@ %@", securitiesType.rawValue, symbol, market)
	}
	
}

extension IBExecutionCondition: Codable {
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(securitiesType)
		try container.encode(market)
		try container.encode(symbol)
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.securitiesType = try container.decode(IBSecuritiesType.self)
		self.market = try container.decode(String.self)
		self.symbol = try container.decode(String.self)

	}
	
}
