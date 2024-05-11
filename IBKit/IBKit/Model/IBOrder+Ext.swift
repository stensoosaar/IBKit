//
//  File.swift
//  
//
//  Created by Sten Soosaar on 11.05.2024.
//

import Foundation

public extension IBOrder {
	
	
	static func market(_ action: IBAction, quantity: Double, contract: IBContract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
		return IBOrder(contract: contract, action: action, totalQuantity: quantity, orderType: .MARKET, lmtPrice: nil, auxPrice: nil, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}

	static func limit(_ limit: Double, action: IBAction, quantity: Double,  contract: IBContract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading:  Bool = false) -> IBOrder {
		return IBOrder(contract: contract, action: action, totalQuantity: quantity, orderType: .LIMIT, lmtPrice: limit, auxPrice: nil, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}

	
	static func stop(_ stop: Double, action: IBAction, quantity: Double,  contract: IBContract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
		return IBOrder(contract: contract, action: action, totalQuantity: quantity, orderType: .STOP, lmtPrice: nil, auxPrice: stop, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}
	
	static func stopLimit(stop: Double, limit: Double, action: IBAction, quantity: Double,  contract: IBContract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
		return IBOrder(contract: contract, action: action, totalQuantity: quantity, orderType: .STOP_LIMIT, lmtPrice: limit, auxPrice: stop, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}
		
}

