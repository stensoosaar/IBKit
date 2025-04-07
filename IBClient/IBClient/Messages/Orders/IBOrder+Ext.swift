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
    ///   - stop: The stop price where the stop-loss should start the trail.
    ///   - action: `.buy` or `.sell`
    ///   - quantity: Number of shares/contracts
    ///   - contract: The asset contract
    ///   - account: IB account ID
    ///   - tif: Time In Force (default `.day`)
    ///   - hidden: Whether the order should be hidden
    ///   - extendedTrading: Whether it should execute outside regular trading hours
    static func trailingStop(stop: Double, limit: Double, action: IBAction, quantity: Double, contract: IBContract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
        IBOrder(
            contract: contract,
            action: action,
            totalQuantity: quantity,
            orderType: .TRAILING,
            lmtPrice: limit,
            auxPrice: abs(limit - stop),
            tif: tif,
            outsideRth: extendedTrading,
            hidden: hidden,
            account: account
        )
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
    static func trailingStop(stopOffset: Double, limit: Double, action: IBAction, quantity: Double, contract: IBContract, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
        IBOrder(
            contract: contract,
            action: action,
            totalQuantity: quantity,
            orderType: .TRAILING,
            lmtPrice: limit,
            auxPrice: stopOffset,
            tif: tif,
            outsideRth: extendedTrading,
            hidden: hidden,
            account: account
        )
    }
}

