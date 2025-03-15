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


public struct IBPriceHistoryRequest: IBRequest {
	let version: Int = 6
	public let type: IBRequestType = .historicalData
	public let id: Int?
	public let contract: IBContract
	public let size: IBBarSize
	public let source: IBBarSource
	public let lookback: DateInterval
	public let extendedTrading: Bool
	public let includeExpired: Bool
	
	/// Requests price history for contract
	/// - Parameter id: request ID
	/// - Parameter contract: contract description
	/// - Parameter size: price bar resolution
	/// - Parameter source: data type to build a bar
	/// - Parameter interval: date interval
	/// - Parameter extendedTrading: use only data from regular trading hours
	/// - Returns: IBPriceHistory event
	
	public init(id: Int, contract: IBContract, size: IBBarSize, source: IBBarSource, lookback: DateInterval, extendedTrading: Bool, includeExpired: Bool = false) {
		self.id = id
		self.contract = contract
		self.size = size
		self.source = source
		self.lookback = lookback
		self.extendedTrading = extendedTrading
		self.includeExpired = includeExpired
	}
	
}

extension IBPriceHistoryRequest: IBEncodable {

	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBError.encodingError("Server value expected")
		}
				
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.historicalData)
		
		if serverVersion <= IBServerVersion.SYNT_REALTIME_BARS {
			try container.encode(version)
		}
				
		try container.encode(id)
		try container.encode(contract)
		try container.encode(includeExpired)
		
		let test = Calendar.current.compare(Date(), to: lookback.end, toGranularity: .day) == .orderedAscending
		

		if test == true {
			try container.encodeOptional("")
		} else {
			try container.encodeOptional(lookback.end)
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




public struct IBPriceHistoryCancellationRequest: IBRequest{
	public let version: Int = 1
	public let type: IBRequestType = .cancelHistoricalData
	public var id: Int?
	
	public init(id: Int) {
		self.id = id
	}
}

extension IBPriceHistoryCancellationRequest: IBEncodable {
    public func encode(to encoder: IBEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(type)
        try container.encode(version)
        try container.encode(id)
    }
}
