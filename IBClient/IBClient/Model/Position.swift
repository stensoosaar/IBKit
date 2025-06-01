//
//  Position.swift
//  IBKit
//
//  Created by Sten Soosaar on 22.05.2025.
//

import Foundation
import TWS


open class Position {
	
	public let contract: Contract
	
	public let accountName: String
	
	public var units: Double = 0
	
	public var unitPrice: Double = 0
	
	public var costValue: Double = 0
	
	public var marketPrice: Double = 0
	
	public var marketValue: Double = 0
	
	public var dailyPNL: Double = 0
	
	public var unrealizedPNL: Double = 0
	
	public var realizedPNL: Double = 0
		
	public init(contract: Contract, accountName: String){
		self.contract = contract
		self.accountName = accountName.uppercased()
	}
	
}


extension Position: Hashable {
	
	public static func == (lhs: Position, rhs: Position) -> Bool {
		lhs.accountName == rhs.accountName && lhs.contract == rhs.contract
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(accountName)
		hasher.combine(contract)
	}
}


extension Position: Identifiable {
	
	public var id: Int {
		return self.hashValue
	}
	
}


extension Position {
		
	func update(from update: PositionUpdate){
		units = update.units
		unitPrice = update.unitPrice
		marketPrice = update.marketPrice
		marketValue = update.marketValue
		unrealizedPNL = update.unrealizedPNL
		realizedPNL = update.realizedPNL
	}
	
	func update(from pnl: PositionPNL){
		units = pnl.units
		unrealizedPNL = pnl.unrealized
		realizedPNL = pnl.realized ?? realizedPNL
		marketValue = pnl.marketValue
	}
	
	func update(from update: AnyPositionSizeUpdate){
		units = update.units
		unitPrice = update.unitPrice
		costValue = units * unitPrice
	}
	
}
