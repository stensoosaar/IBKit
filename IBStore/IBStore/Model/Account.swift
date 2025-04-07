//
//  IBStore.swift
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
import TabularData
import IBClient


public struct AccountSummary {
	public let name: String
	public let type: String
	public let currency: String
	public let netLiquidation: Double
	public let initialMargin: Double
	public let maintenanceMargin: Double
	public let buyingPower: Double
	public let availableFunds: Double
	public let excessLiquidity: Double
	public let totalPositions: Double
	public let unrealisedPNL: Double
	public let cushion: Double
	public let leverage: Double
	public let avgGain: Double
	public let avgLoss: Double
	public let hitRate: Double
	public let highWatermark: Double
	public let drawdown: Double
	public let profitFactor: Double
	public let cash: [Balance]
	public let updatedAt: Date
	public let positions: DataFrame
	
}


public class Account: Identifiable {
	
	public let name: String
	public var type: String?
	public var currency: String?
	public var unrealisedPNL:Double = 0.0
	public var netLiquidation: Double = 0.0{
		didSet { updateHighWatermark() }
	}
	public var initialMargin: Double = 0.0
	public var maintenanceMargin: Double = 0.0
	public var buyingPower: Double = 0.0
	public var availableFunds: Double = 0.0
	public var excessLiquidity: Double = 0.0
	public var leverage: Double = 0.0
	public var cushion: Double = 0.0
	public var cash: CashBook = CashBook ()
	public var positions: [String:Position] = [:]
	public var orders: [String:IBOrder] = [:]
	public var updatedAt: Date?

	// portfolio statistics
	private var totalTrades: Int = 0
	private var profitableTrades: Int = 0
	private var unprofitableTrades: Int = 0
	private var totalProfit: Double = 0
	private var totalLoss: Double = 0
	public private(set) var highWatermark: Double = 0
	public private(set) var avgGain: Double = 0
	public private(set) var avgLoss: Double = 0
	public private(set) var hitRate: Double = 0
	public private(set) var profitFactor: Double = 0
	public private(set) var drawdown: Double = 0

	public init(name: String) {
		self.name = name
	}
	
	private func updateHighWatermark(){
		highWatermark = max(highWatermark, netLiquidation)
	}
	
	func updateRate(_ rate: Double, for currency:String){
		if cash.balances.keys.contains(where: {$0 == currency}){
			cash.balances[currency]?.updateRate(rate)
		}
	}
	
}


extension Account{
	
	func updateTradeStatistics(_ realisedProfits: Double){
		totalTrades += 1
		profitableTrades = realisedProfits > 0 ? profitableTrades + 1 : profitableTrades
		unprofitableTrades = realisedProfits <= 0 ? unprofitableTrades + 1 : unprofitableTrades
		totalLoss += realisedProfits < 0 ? abs(realisedProfits) : 0
		totalProfit += realisedProfits > 0 ? realisedProfits : 0
		avgGain = Double(profitableTrades) > 0 ? totalProfit / Double(totalTrades) : 0.0
		avgLoss = Double(unprofitableTrades) > 0 ? totalLoss / Double(totalTrades) : 0.0
		hitRate = Double(totalTrades) > 0 ? Double(profitableTrades / totalTrades) : 0.0
		profitFactor = Double(totalLoss) > 0 ? (totalProfit / abs(totalLoss)) : 0.0
		drawdown = min(0, netLiquidation - highWatermark)
	}
	
}


extension Account: Hashable, Equatable {
	
	public static func == (lhd: Account, rhd: Account) -> Bool {
		return lhd.id == rhd.id
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
}


extension Account: ConvertibleObject{
		
	public func convert() -> AccountSummary {
				
		let contractIDColumn = Column(ColumnID("id", Int.self), contents: positions.values.map{$0.contract.id!})
		let contractBaseColumn = Column(ColumnID("base", String.self), contents: positions.values.map{$0.contract.symbol!})
		let contractQuoteColumn = Column(ColumnID("quote", String.self), contents: positions.values.map{$0.contract.currency})
		let unitsColumn = Column(ColumnID("units", Double.self), contents: positions.values.map{$0.units})
		let marketPriceColumn = Column(ColumnID("marketPrice",Double.self), contents: positions.values.map{$0.marketPrice})
		let marketValueColumn = Column(ColumnID("marketValue",Double.self), contents: positions.values.map{$0.marketValue})
		let averageCostColumn = Column(ColumnID("averageCost",Double.self), contents: positions.values.map{$0.averageCost})
		let costPerUnitColumn = Column(ColumnID("costPerUnit",Double.self), contents: positions.values.map{$0.costPerUnit})
		let unrealizedPNLColumn = Column(ColumnID("unrealizedPNL",Double.self), contents: positions.values.map{$0.unrealizedPNL})
		let realizedPNLColumn = Column(ColumnID("realizedPNL", Double.self), contents: positions.values.map{$0.realizedPNL})
		let weightColumn = Column(ColumnID("weight", Double.self), contents: positions.values.map{$0.marketValue / netLiquidation})

		let dataframe = DataFrame(columns: [
			contractIDColumn.eraseToAnyColumn(),
			contractBaseColumn.eraseToAnyColumn(),
			contractQuoteColumn.eraseToAnyColumn(),
			unitsColumn.eraseToAnyColumn(),
			costPerUnitColumn.eraseToAnyColumn(),
			averageCostColumn.eraseToAnyColumn(),
			marketPriceColumn.eraseToAnyColumn(),
			marketValueColumn.eraseToAnyColumn(),
			weightColumn.eraseToAnyColumn(),
			unrealizedPNLColumn.eraseToAnyColumn(),
			realizedPNLColumn.eraseToAnyColumn()
		])
		
		return AccountSummary(
			name: name,
			type: type ?? "",
			currency: currency ?? "UNKNOWN",
			netLiquidation: netLiquidation,
			initialMargin: initialMargin,
			maintenanceMargin: maintenanceMargin,
			buyingPower: buyingPower,
			availableFunds: availableFunds,
			excessLiquidity: excessLiquidity,
			totalPositions: marketValueColumn.sum(),
			unrealisedPNL: unrealizedPNLColumn.sum(),
			cushion: cushion,
			leverage: marketValueColumn.sum() / netLiquidation,
			avgGain: avgGain,
			avgLoss: avgLoss,
			hitRate: hitRate,
			highWatermark: highWatermark,
			drawdown: drawdown,
			profitFactor: profitFactor,
			cash: Array(cash.balances.values),
			updatedAt: updatedAt ?? Date(),
			positions: dataframe
		)
	}
	
}

