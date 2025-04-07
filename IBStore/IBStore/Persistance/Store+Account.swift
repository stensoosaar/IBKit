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
import DuckDB
import IBClient
import TabularData

//MARK: - Account Store
extension Store{

	@discardableResult
	public func upsertAccounts(_ accounts: [AccountSummary]) -> [AccountSummary]{
	
		
			
		// udpate index
		do {
			let perf = try Appender(connection: connection, table: "performance")
			for item in accounts{
				try perf.append(item.updatedAt.ISO8601Format())
				try perf.append(Double(0))
				try perf.append(Double(0))
				try perf.append(item.netLiquidation)
				try perf.append(item.name)
			}
			try perf.flush()

		} catch{
			print(error)
		}

		return accounts
	}
	
	func fetchAccounts(identifiers: [String]) throws -> DataFrame {
		
		let result = try connection.query("""
			SELECT * FROM accounts;
		""")
		
		let names = result[0].cast(to: String.self)
		let types = result[1].cast(to: String.self)
		let currencies = result[2].cast(to: String.self)
		let net_assets = result[3].cast(to: Double.self)
		let ims = result[4].cast(to: Double.self)
		let mms = result[5].cast(to: Double.self)
		let buying_power = result[6].cast(to: Double.self)
		let available_funds  = result[7].cast(to: Double.self)
		let excess_liquidity = result[8].cast(to: Double.self)
		let total_positions = result[9].cast(to: Double.self)
		let unrealised_pnl = result[10].cast(to: Double.self)
		let cushion = result[11].cast(to: Double.self)
		let leverage = result[12].cast(to: Double.self)
		let average_gain = result[13].cast(to: Double.self)
		let average_loss = result[14].cast(to: Double.self)
		let hit_rate = result[15].cast(to: Double.self)
		let high_watermark = result[16].cast(to: Double.self)
		let profit_factor = result[17].cast(to: Double.self)
		let updated_at = result[18].cast(to: DuckDB.Date.self)
		let created_at = result[19].cast(to: DuckDB.Date.self)

		let frame = DataFrame(columns:[
			TabularData.Column(names).eraseToAnyColumn(),
			TabularData.Column(types).eraseToAnyColumn(),
			TabularData.Column(currencies).eraseToAnyColumn(),
			TabularData.Column(net_assets).eraseToAnyColumn(),
			TabularData.Column(ims).eraseToAnyColumn(),
			TabularData.Column(mms).eraseToAnyColumn(),
			TabularData.Column(buying_power).eraseToAnyColumn(),
			TabularData.Column(available_funds).eraseToAnyColumn(),
			TabularData.Column(excess_liquidity).eraseToAnyColumn(),
			TabularData.Column(total_positions).eraseToAnyColumn(),
			TabularData.Column(unrealised_pnl).eraseToAnyColumn(),
			TabularData.Column(cushion).eraseToAnyColumn(),
			TabularData.Column(leverage).eraseToAnyColumn(),
			TabularData.Column(average_gain).eraseToAnyColumn(),
			TabularData.Column(average_loss).eraseToAnyColumn(),
			TabularData.Column(hit_rate).eraseToAnyColumn(),
			TabularData.Column(high_watermark).eraseToAnyColumn(),
			TabularData.Column(profit_factor).eraseToAnyColumn(),
			TabularData.Column(updated_at).eraseToAnyColumn()
		])
		
		return frame
		
	}
		
}
