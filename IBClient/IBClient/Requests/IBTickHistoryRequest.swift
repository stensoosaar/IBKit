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


public struct IBTickHistoryRequest: IBRequest {
	
	public enum TickSource: String, Encodable {
		case trades			= "TRADES"
		case midpoint		= "MIDPOINT"
		case bidAsk			= "BID_ASK"
	}

	
	public let version: Int = 3
	public let id: Int?
	public var type: IBRequestType = .tickByTickData
	public var contract: IBContract
	public var source: TickSource
	public var count: Int
	public var interval: DateInterval
	public var extendedHours: Bool
	public var ignoreSize: Bool
	
	/// High Resolution Historical Data
	/// - Parameter id: id of the request
	/// - Parameter contract: Contract object that is subject of query.
	/// - Parameter numberOfTicks, Number of distinct data points. Max is 1000 per request.
	/// - Parameter fromDate: requested period's starttime
	/// - Parameter whatToShow, (Bid_Ask, Midpoint, or Trades) Type of data requested.
	/// - Parameter useRth, Data from regular trading hours (1), or all available hours (0).
	/// - Parameter ignoreSize: Omit updates that reflect only changes in size, and not price. Applicable to Bid_Ask data requests.
	
	public init(id: Int, contract: IBContract, count: Int, interval: DateInterval, source: TickSource, extendedHours: Bool, ignoreSize: Bool) {
		self.id = id
		self.contract = contract
		self.source = source
		self.count = count
		self.interval = interval
		self.extendedHours = extendedHours
		self.ignoreSize = ignoreSize
	}
	
	public func encode(to encoder: IBEncoder) throws {
				
		var container = encoder.unkeyedContainer()
		try container.encode(type)
						
		try container.encode(id)
		try container.encode(contract)
		try container.encode(contract.isExpired)
		try container.encode(interval.start)
		try container.encode(interval.end)
		try container.encode(count)
		try container.encode(source)
		try container.encode(extendedHours)
		try container.encode(ignoreSize)
		try container.encode("")
		
	}
	
	
}
