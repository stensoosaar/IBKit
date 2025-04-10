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
import Combine


extension Store{
	
	
	private func createTempTable() throws {
				
		_ = try connection.execute("""
			CREATE TEMP TABLE IF NOT EXISTS temp_contracts (
				id INT32,
				type VARCHAR,
				symbol VARCHAR,
				currency VARCHAR,
				local_symbol VARCHAR,
				expiration DATE,
				strike DOUBLE,
				execution_right VARCHAR,
				multiplier VARCHAR,
				exchange VARCHAR,
				primary_exchange VARCHAR,
				trading_class VARCHAR,
				is_expired BOOL
			);
		""")
	}
	
	public func storeUniverse(_ url: URL) throws {

		try createTempTable()
		
		_ = try connection.execute("""
			CREATE TEMP TABLE contract_import AS
			SELECT * FROM read_csv('\(url.path())');
		""")
		
		let result = try connection.query("""
			SELECT column_name 
			FROM duckdb_columns() 
			WHERE table_name IN ('temp_contracts', 'contract_import') 
			GROUP BY column_name 
			HAVING COUNT(DISTINCT table_name) = 2
		""")
		
		let matchingColumns = result[0].cast(to: String.self).compactMap({$0}).joined(separator: ",")
		
		_ = try connection.execute("""
			insert into temp_contracts (\(matchingColumns))
			select \(matchingColumns) from contract_import;
			drop table contract_import;
		""")
				
	}
	
	public func storeUniverse(_ contracts: [IBContract]) throws {
		
		try createTempTable()
		
		let appender = try Appender(connection: connection, table: "temp_contracts")
		for contract in contracts {
			try appender.append(Int32(contract.id))
			try appender.append(contract.securitiesType.rawValue)
			try appender.append(contract.symbol)
			try appender.append(contract.currency)
			try appender.append(contract.localSymbol)
			try appender.append(contract.expiration?.ISO8601Format())
			try appender.append(contract.strike)
			try appender.append(contract.right?.rawValue)
			try appender.append(contract.multiplier)
			try appender.append(contract.exchange?.rawValue)
			try appender.append(contract.primaryExchange?.rawValue)
			try appender.append(contract.tradingClass)
			try appender.append(contract.isExpired)
			try appender.endRow()
		}
		try appender.flush()
		
	}
	
	public func fetchContracts(query: String? = nil) throws -> [IBContract] {
		
		// select which table to query depending on state.
		
		let query = """
			SELECT 
				CONCAT(
					COALESCE(CAST(tc.id AS TEXT), '0'), CHR(0),
					COALESCE(tc.symbol, ''), CHR(0),
					COALESCE(tc.type, ''), CHR(0),
					COALESCE(tc.expiration::TEXT, ''), CHR(0), 
					COALESCE(CAST(tc.strike AS TEXT), ''), CHR(0), 
					COALESCE(tc.execution_right, ''), CHR(0),
					COALESCE(CAST(tc.multiplier AS TEXT), ''), CHR(0),
					COALESCE(tc.exchange, ''), CHR(0),
					COALESCE(tc.currency, ''), CHR(0),
					COALESCE(tc.local_symbol, ''), CHR(0),
					COALESCE(tc.trading_class, ''), CHR(0),
					CHR(0)
				)
			FROM temp_contracts tc;
		"""
		let result = try connection.query(query)
		let column = result[0].cast(to: String.self)

		let decoder = IBDecoder()
		let contracts = try column.compactMap({ el -> IBContract? in
			guard let data = el?.data(using: .ascii) else {return nil}
			return try decoder.decode(IBContract.self, from: data)
			
		})
		
		return contracts
		
	}

	@discardableResult
	public func addContracts(_ contracts: [IBContractDetails]) throws -> [IBContractDetails]{
		
		let sql = """
			INSERT INTO contracts (
				id, type, base, quote, symbol, local_symbol, expiration, strike, execution_right,
				multiplier, destination_exchange, primary_exchange, time_zone_id,
				minimum_tick_size, size_increment, underlying_contract_id, name,
				regular_session, extended_session, 
				industry, category, subcategory, isin, subtype, updated_at, created_at
			)
			VALUES (
				$1, $2, $3, $4, $5, $6, $7, $8, $9,
				$10, $11, $12, $13,
				$14, $15, $16, $17,
				$18, $19,
				$20, $21, $22, $23, $24, $25, $26
			)
			ON CONFLICT(id) DO UPDATE SET
				type=$2,
				base=$3,
				quote=$4,
				symbol=$5,
				local_symbol=$6,
				expiration=$7,
				strike=$8,
				execution_right=$9,
				multiplier=$10,
				destination_exchange=$11,
				primary_exchange=$12,
				time_zone_id=$13,
				minimum_tick_size=$14,
				size_increment=$15,
				underlying_contract_id=$16,
				name=$17,
				regular_session=$18,
				extended_session=$19,
				industry=$20,
				category=$21,
				subcategory=$22,
				isin=$23,
				subtype=$24,
				updated_at=$25
		"""

		let statement = try PreparedStatement(connection: connection, query: sql)

		for contract in contracts {
						
			try statement.bind(Int32(contract.contractID), at: 1)
			try statement.bind(contract.type.rawValue, at: 2)
			try statement.bind(contract.symbol, at: 3)
			try statement.bind(contract.currency, at: 4)
			try statement.bind(contract.symbol, at: 5)
			try statement.bind(contract.localSymbol, at: 6)
			try statement.bind(contract.expiration?.ISO8601Format(), at: 7)
			try statement.bind(contract.strikePrice, at: 8)
			try statement.bind(contract.executionRight?.rawValue, at: 9)
			try statement.bind(contract.multiplier, at: 10)
			try statement.bind(contract.exchange?.rawValue, at: 11)
			try statement.bind(contract.primaryExchange?.rawValue, at: 12)
			try statement.bind(contract.timeZoneID, at: 13)
			try statement.bind(contract.minimumTick, at: 14)
			try statement.bind(contract.sizeIncrement, at: 15)
			try statement.bind(contract.underlyingContractID.map(Int32.init), at: 16)
			try statement.bind(contract.longName, at: 17)
			
			let regularSchedule = try contract.tradingHours?.blaah()
			let extendedSchedule = try contract.liquidHours?.blaah()

			try statement.bind(regularSchedule, at: 18)
			try statement.bind(extendedSchedule, at: 19)
			try statement.bind(contract.industry, at: 20)
			try statement.bind(contract.category, at: 21)
			try statement.bind(contract.subcategory, at: 22)
			try statement.bind(nil as String?, at: 23)
			try statement.bind(contract.stockType, at: 24)
			try statement.bind(Date().ISO8601Format(), at: 25)
			try statement.bind(Date().ISO8601Format(), at: 26)
			_ = try statement.execute()
		}
				
		return contracts
				
	}

	

}


