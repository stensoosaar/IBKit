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


extension Store {
	
	public func storePrices(event: IBPriceHistory, for contract: IBContract) throws {
		guard let contractID = contract.id else { throw IBError.invalidValue("missing contract id") }
		let appender = try Appender(connection: connection, table: "price_history")
		
		for item in event.prices{
			try appender.append(item.date.ISO8601Format())
			try appender.append(item.open)
			try appender.append(item.high)
			try appender.append(item.low)
			try appender.append(item.close)
			try appender.append(item.volume)
			try appender.append(Int32(item.count ?? 0))
			try appender.append(item.vwap)
			try appender.append(Int32(contractID))
			try appender.endRow()
		}
		
		try appender.flush()
		
	}
	
	public func fetchPrices(interval: DateInterval, resolution: IBBarSize, contract: IBContract) throws -> DataFrame {
		
		guard let contractID = contract.id else { throw IBError.invalidValue("missing contract id") }
	
		let query = """
			SELECT 
				time_bucket(interval '\(resolution.timeInterval)' SECONDS, timestamp) as timestamp,
				first(open) as open
				max(high) as high,
				min(low) as low,
				last(close) as close,
				sum(volume) as volume,
				sum(count) as count
			FROM prices
			WHERE 
				contract_id == \(contractID)
				AND timestamp BETWEEN \(interval.start.ISO8601Format()) 
				AND \(interval.end.ISO8601Format())
			GROUP BY timestamp;
		"""
		
		let response = try self.connection.query(query)
		
		let dateColumn = response[0].cast(to: Timestamp.self)
		let firstColumn = response[0].cast(to: Double.self)
		let maxColumn = response[0].cast(to: Double.self)
		let minColumn = response[0].cast(to: Double.self)
		let closeColumn = response[0].cast(to: Double.self)
		let volumeColumn = response[0].cast(to: Double.self)
		let countColumn = response[0].cast(to: Int.self)

		var dataframe = DataFrame(columns: [
			TabularData.Column(dateColumn).eraseToAnyColumn(),
			TabularData.Column(firstColumn).eraseToAnyColumn(),
			TabularData.Column(maxColumn).eraseToAnyColumn(),
			TabularData.Column(minColumn).eraseToAnyColumn(),
			TabularData.Column(closeColumn).eraseToAnyColumn(),
			TabularData.Column(volumeColumn).eraseToAnyColumn(),
			TabularData.Column(countColumn).eraseToAnyColumn(),
		])
		
		// TODO: add marketdata wrapper with contract id and metadata (resolution, interval etc)
		
		return dataframe
		
	}
	
	@discardableResult
	public func updateQuote(event: MarketData) throws -> QuoteSummary? {
		guard let contractID = event.contract.id else { throw IBError.invalidValue("missing contract id") }
		print(event)
		
		
		
		
		return nil
	}


}
