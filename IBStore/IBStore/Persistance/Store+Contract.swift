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


extension Store{
	
	
	private func createTempTable() throws {
		
		print(#function)
		
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
	
	
	public func blaah(_ url: URL) throws {

		try createTempTable()
		
		let sql = """
		CREATE TEMP TABLE contract_import AS
			SELECT * FROM 
			read_csv('\(url.path())');
		"""
		
		_ = try connection.execute(sql)
		
		let result = try connection.query("""
			SELECT column_name 
			FROM duckdb_columns() 
			WHERE table_name IN ('contract_import', 'temp_contracts') 
			GROUP BY column_name 
			HAVING COUNT(DISTINCT table_name) = 2;
			""")
		
		let column = result[0].cast(to: String.self)
		
		_ = column.compactMap({ el -> String? in
			print(el)
			return nil
		})
		
		
	}
	
	public func storeUniverse(_ contracts: [IBContract]) throws {
		
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
	
	public func fetchContracts() throws -> [IBContract] {
		
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
					COALESCE(tc.destination_exchange, ''), CHR(0),
					COALESCE(tc.primary_exchange, ''), CHR(0),
					COALESCE(tc.currency, ''), CHR(0),
					COALESCE(tc.local_symbol, ''), CHR(0),
					COALESCE(tc.trading_class, ''), CHR(0),
					COALESCE(CAST(tc.is_expired AS TEXT), 'false'), CHR(0),
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

	public func addContracts(_ contracts: [IBContractDetails]) throws {
		
		let appender = try Appender(connection: connection, table: "contracts")
		
		for contract in contracts {
			try appender.append(Int32(contract.contractID))					// id INT32 NOT NULL UNIQUE,
			try appender.append(contract.type.rawValue)						// type VARCHAR NOT NULL,
			try appender.append(contract.symbol)							// base VARCHAR NOT NULL,
			try appender.append(contract.currency)							// quote VARCHAR NOT NULL,
			try appender.append(contract.symbol)							// symbol VARCHAR NOT NULL,
			try appender.append(contract.localSymbol)						// local_symbol VARCHAR NOT NULL,
			try appender.append(contract.expiration?.ISO8601Format())		// expiration DATE,
			try appender.append(contract.strikePrice)						// strike DOUBLE,
			try appender.append(contract.executionRight?.rawValue)			// execution_right VARCHAR,
			try appender.append(contract.multiplier)						// multiplier VARCHAR,
			try appender.append(contract.exchange?.rawValue)				// destination_exchange VARCHAR,
			try appender.append(contract.primaryExchange?.rawValue)			// primary_exchange VARCHAR,
			try appender.append(contract.timeZoneID)						// time_zone_id VARCHAR,
			try appender.append(contract.minimumTick)						// minimum_tick_size DOUBLE,
			try appender.append(contract.sizeIncrement)						// size_increment DOUBLE,
			try appender.append(Int32(contract.underlyingContractID))		//underlying_Contract_id INT32,
			try appender.append(contract.longName)							// ame VARCHAR,
			try appender.append(Date.empty()?.ISO8601Format())				// regular_session_open DATE,
			try appender.append(Double(nil))								// regular_session_duration DOUBLE,
			try appender.append(Date.empty()?.ISO8601Format())				// extened_session_open DATE,
			try appender.append(Double(nil))								// extended_session_duration DOUBLE,
			try appender.append(contract.industry)							// industry VARCHAR,
			try appender.append(contract.category)							// category VARCHAR,
			try appender.append(contract.subcategory)						// subcategory VARCHAR,
			try appender.append(String(nil))								// isin VARCHAR,
			try appender.append(contract.stockType)							// subtype VARCHAR,
			try appender.append(Date().ISO8601Format())						// created_at TIMESTAMP
			try appender.append(Date().ISO8601Format())						// updated_at TIMESTAMP
			try appender.endRow()

		}
		
		try appender.flush()
		
	}

}

