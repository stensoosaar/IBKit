//
//  File.swift
//  
//
//  Created by Sten Soosaar on 18.04.2024.
//

import Foundation


public struct IBPriceHistoryRequest: IBIndexedRequest, IBEncodable {
	let version: Int = 6
	public let type: IBRequestType = .historicalData
	public let requestID: Int
	public let contract: IBContract
	public let size: IBBarSize
	public let source: IBBarSource
	public let lookback: DateInterval
	public let extendedTrading: Bool
	public let includeExpired: Bool
	
	/// Requests price history for contract
	/// - Parameter requestID: request ID
	/// - Parameter contract: contract description
	/// - Parameter size: price bar resolution
	/// - Parameter source: data type to build a bar
	/// - Parameter interval: date interval
	/// - Parameter extendedTrading: use only data from regular trading hours
	/// - Returns: IBPriceHistory event
	
	public init(requestID: Int, contract: IBContract, size: IBBarSize, source: IBBarSource, lookback: DateInterval, extendedTrading: Bool, includeExpired: Bool = false) {
		self.requestID = requestID
		self.contract = contract
		self.size = size
		self.source = source
		self.lookback = lookback
		self.extendedTrading = extendedTrading
		self.includeExpired = includeExpired
	}


	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBClientError.encodingError("Server value expected")
		}
				
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.historicalData)
		
		if serverVersion <= IBServerVersion.SYNT_REALTIME_BARS {
			try container.encode(version)
		}
				
		try container.encode(requestID)
		try container.encode(contract)
		try container.encode(includeExpired)
		
		let test = Calendar.current.compare(Date(), to: lookback.end, toGranularity: .day) == .orderedAscending
		

		if test == true {
			try container.encodeOptional("")
		} else {
			try container.encodeOptional(Date())
		}
		
		try container.encode(size)
		try container.encode(lookback.twsDescription)
		try container.encode(extendedTrading)
		try container.encode(source)
		try container.encode(1)
		
		if contract.securitiesType == .combo {
			if let legs = contract.comboLegs{
				try container.encode(legs.count)
				for leg in legs{
					try container.encode(leg.conId)
					try container.encode(leg.ratio)
					try container.encode(leg.action)
					try container.encode(leg.exchange)
				}
				
			} else {
				try container.encode(0)
			}
		}
		
		try container.encode(test)
		try container.encode("")
	}
	
}
