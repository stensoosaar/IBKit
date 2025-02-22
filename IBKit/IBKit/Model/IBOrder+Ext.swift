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
    
    /// Creates a **Trailing Stop Order**
    /// - Parameters:
    ///   - stopOffset: The offset amount from the market price where the stop-loss should trail.
    ///   - action: `.buy` or `.sell`
    ///   - quantity: Number of shares/contracts
    ///   - contract: The asset contract
    ///   - account: IB account ID
    ///   - tif: Time In Force (default `.day`)
    ///   - hidden: Whether the order should be hidden
    ///   - extendedTrading: Whether it should execute outside regular trading hours
    static func trailingStop(stopOffset: Double, action: IBAction, quantity: Double, contract: IBContract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
        IBOrder(contract: contract, action: action, totalQuantity: quantity, orderType: .TRAILING, lmtPrice: nil, auxPrice: stopOffset, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
    }
}

