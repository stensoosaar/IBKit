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
import IBClient


extension IBPositionSizeMulti{
	func convert() -> Position {
		return Position(
			contract: contract,
			accountName: accountName,
			units: position,
			marketPrice: 0,
			marketValue: 0,
			averageCost: avgCost,
			unrealizedPNL: 0,
			realizedPNL: 0
		)
	}
}


public class Position {
	
	public let contract: IBContract
	public let accountName: String
	public var units: Double = 0
	public var marketPrice: Double = 0
	public var marketValue: Double = 0
	public var averageCost: Double = 0
	public var costPerUnit: Double = 0
	public var unrealizedPNL: Double = 0
	public var realizedPNL: Double = 0
	
	public init(
		contract: IBContract,
		accountName: String,
		units: Double = 0,
		marketPrice:Double = 0,
		marketValue: Double = 0,
		averageCost: Double = 0,
		unrealizedPNL: Double = 0,
		realizedPNL: Double = 0)
	{
		self.contract = contract
		self.accountName = accountName
		self.units = units
		self.marketPrice = marketPrice
		self.marketValue = marketValue
		self.averageCost = averageCost
		self.unrealizedPNL = unrealizedPNL
		self.realizedPNL = realizedPNL
		self.costPerUnit = averageCost / units
	}
	
}


extension Position: Hashable, Equatable{
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(accountName)
		hasher.combine(contract.id)
		hasher.combine(contract.securitiesType)
		hasher.combine(contract.symbol)
		hasher.combine(contract.currency)
		hasher.combine(contract.expiration)
		hasher.combine(contract.strike)
		hasher.combine(contract.multiplier)
	}
	
	public static func == (lhs: Position, rhs: Position) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
	
}


extension Position: CustomStringConvertible {
	public var description: String {
		return "\(contract.symbol)/\(contract.currency)\t\(units) @ \(averageCost) \(unrealizedPNL)"
	}
}

