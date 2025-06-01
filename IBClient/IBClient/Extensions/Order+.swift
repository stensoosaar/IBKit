//
//  Order+.swift
//  IBKit
//
//  Created by Sten Soosaar on 01.06.2025.
//

import Foundation
import TWS


public extension Order {
	
	
	static func market(_ action: Action, quantity: Double, contract: Contract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> Order {
		var temp = Order()
		temp.action = action
		temp.totalQuantity = quantity
		temp.orderType = .market
		temp.lmtPrice = nil
		temp.auxPrice = nil
		temp.tif = tif
		temp.outsideRth = extendedTrading
		temp.hidden = hidden
		temp.accountName = account
		return temp
	}

	static func limit(_ limit: Double, action: Action, quantity: Double,  contract: Contract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading:  Bool = false) -> Order {
		var temp = Order()
		temp.action = action
		temp.totalQuantity = quantity
		temp.orderType = .limit
		temp.lmtPrice = nil
		temp.auxPrice = nil
		temp.tif = tif
		temp.outsideRth = extendedTrading
		temp.hidden = hidden
		temp.accountName = account
		return temp
	}

	
	static func stop(_ stop: Double, action: Action, quantity: Double,  contract: Contract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> Order {
		var temp = Order()
		temp.action = action
		temp.totalQuantity = quantity
		temp.orderType = .stop
		temp.lmtPrice = nil
		temp.auxPrice = nil
		temp.tif = tif
		temp.outsideRth = extendedTrading
		temp.hidden = hidden
		temp.accountName = account
		return temp
	}
	
	static func stopLimit(stop: Double, limit: Double, action: Action, quantity: Double,  contract: Contract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> Order {
		var temp = Order()
		temp.action = action
		temp.totalQuantity = quantity
		temp.orderType = .stopLimit
		temp.lmtPrice = nil
		temp.auxPrice = nil
		temp.tif = tif
		temp.outsideRth = extendedTrading
		temp.hidden = hidden
		temp.accountName = account
		return temp
	}
	
	/// Creates a **Trailing Stop Order**
	/// - Parameters:
	///   - stop: The stop price where the stop-loss should start the trail.
	///   - action: `.buy` or `.sell`
	///   - quantity: Number of shares/contracts
	///   - contract: The asset contract
	///   - account: IB account ID
	///   - tif: Time In Force (default `.day`)
	///   - hidden: Whether the order should be hidden
	///   - extendedTrading: Whether it should execute outside regular trading hours
	static func trailingStop(stop: Double, limit: Double, action: Action, quantity: Double, contract: Contract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> Order {
		var temp = Order()
		temp.action = action
		temp.totalQuantity = quantity
		temp.orderType = .trailing
		temp.lmtPrice = limit
		temp.auxPrice = abs(limit - stop)
		temp.tif = tif
		temp.outsideRth = extendedTrading
		temp.hidden = hidden
		temp.accountName = account
		temp.outsideRth = extendedTrading
		return temp
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
	static func trailingStop(stopOffset: Double, limit: Double, action: Action, quantity: Double, contract: Contract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> Order {
		var temp = Order()
		temp.action = action
		temp.totalQuantity = quantity
		temp.orderType = .trailing
		temp.lmtPrice = limit
		temp.auxPrice = stopOffset
		temp.tif = tif
		temp.outsideRth = extendedTrading
		temp.hidden = hidden
		temp.accountName = account
		temp.outsideRth = extendedTrading
		return temp
	}
}

