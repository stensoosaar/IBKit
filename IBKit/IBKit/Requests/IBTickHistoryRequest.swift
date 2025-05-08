//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBTickHistoryRequest: IBIndexedRequest, Hashable, Equatable {
	
	public enum TickSource: String, Encodable {
		case trades			= "TRADES"
		case midpoint		= "MIDPOINT"
		case bidAsk			= "BID_ASK"
	}

	
	public let version: Int = 3
	public let requestID: Int
	public var type: IBRequestType = .tickByTickData
	public var contract: IBContract
	public var source: TickSource
	public var count: Int
	public var interval: DateInterval
	public var extendedHours: Bool
	public var ignoreSize: Bool
	
	/// High Resolution Historical Data
	/// - Parameter requestId: id of the request
	/// - Parameter contract: Contract object that is subject of query.
	/// - Parameter numberOfTicks, Number of distinct data points. Max is 1000 per request.
	/// - Parameter fromDate: requested period's starttime
	/// - Parameter whatToShow, (Bid_Ask, Midpoint, or Trades) Type of data requested.
	/// - Parameter useRth, Data from regular trading hours (1), or all available hours (0).
	/// - Parameter ignoreSize: Omit updates that reflect only changes in size, and not price. Applicable to Bid_Ask data requests.
	
	public init(requestID: Int, contract: IBContract, count: Int, interval: DateInterval, source: TickSource, extendedHours: Bool, ignoreSize: Bool) {
		self.requestID = requestID
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
						
		try container.encode(requestID)
		try container.encode(contract)
		try container.encode(contract.isExpired)
		try container.encode(interval.start)
		try container.encode(interval.end)
		try container.encode(count)
		try container.encode(source)
		try container.encode(extendedHours.reverseValue())
		try container.encode(ignoreSize)
		try container.encode("")
		
	}
	
	
}
