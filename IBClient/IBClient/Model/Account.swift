/*
 MIT License

 Copyright (c) 2016-2025 Sten Soosaar

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import TWS


/**
  Represents local mirror of your brokerage account
 */
open class Account {
	
/// The unique account name or identifier (IB account code).
	public let name: String

	/// The account type (e.g., "INDIVIDUAL", "IRA", "MARGIN").
	public var type: String?

	/// The base currency of the account (e.g., "USD").
	public var currency: String?

	/// The current unrealized profit and loss for the account.
	public var unrealisedPNL: Double = 0.0

	/// The total net liquidation value of the account.
	public var netAssets: Double = 0.0

	/// The initial margin requirement.
	public var initialMargin: Double = 0.0

	/// The maintenance margin requirement.
	public var maintenanceMargin: Double = 0.0

	/// The available buying power.
	public var buyingPower: Double = 0.0

	/// The available funds for trading.
	public var availableFunds: Double = 0.0

	/// The excess liquidity in the account.
	public var excessLiquidity: Double = 0.0

	/// The effective leverage of the account.
	public var leverage: Double = 0.0
	
	/// Last update date
	public var updatedAt: Date?

	/// The cushion (buffer) between margin and liquidation value.
	public var cushion: Double = 0.0
		
	public var rates: [String: Double] = [:]

	/// Dictionary of cash balances by currency. `"BASE": 0` Represents base currency.
	public var cash: [String: Double] = ["BASE": 0]

	/// Dictionary of open positions keyed by contract identifier.
	public var positions: [Int: Position] = [:]

	public var openOrders: [Order] = []
	
	public init(name: String) {
		self.name = name
	}
	
}

extension Account: Equatable, Hashable {

	public static func == (lhs: Account, rhs: Account) -> Bool {
		return lhs.name.uppercased() == rhs.name.uppercased()
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(name)
	}

}

extension Account {
	
	func update(from event: AccountPNL){
		
	}

	func update(from event: any AccountKeyValueUpdate){}
	
}
