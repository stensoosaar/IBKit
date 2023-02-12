//
//  IBClient+Prices.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
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


public extension IBClient {
	
	
	func requestMarketRule(_ reqId: Int) throws {
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.marketRule)
		try container.encode(reqId)
		try send(encoder: encoder)
	}
	
	
	
	func setMarketDataType(_ type: IBMarketDataType ) throws {

		let version = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.marketDataType)
		try container.encode(version)
		try container.encode(type)
		try send(encoder: encoder)
		
	}
	
	
	/// Requests first datapoint date for specific dataset
	/// - Parameter reqId: request ID
	/// - Parameter contract: contract description
	/// - Parameter barSource: data type to build a bar
	/// - Parameter useRTH: use only data from regular trading hours
	/// - Returns: FirstDatapoint event
	
	func firstDatapointDate(_ reqId: Int, contract: IBContract, barSource: IBBarSource = .trades , useRTH: Bool = false) throws {
		
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.headTimestamp)
		try container.encode(reqId)
		try container.encode(contract)
		try container.encode(contract.isExpired)
		try container.encode(useRTH)
		try container.encode(barSource)
		// format date 1: date string, 2: unix timestamp
		try container.encode(1)

		try send(encoder: encoder)

	}
	
	
	/// Requests first datapoint date for specific dataset
	/// - Parameter reqId: request ID
	/// - Parameter contract: contract description
	/// - Parameter barSize: what resolution one bar should be
	/// - Parameter barSource: data type to build a bar
	/// - Parameter lookback: IBDuration.
	/// - Parameter useRTH: use only data from regular trading hours
	/// - Returns: PriceHistory event. If IBDuration continousUpdates selected, also PriceBar event of requested resolution will be included as they occur

	func requestPriceHistory(_ reqId: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: IBDuration, useRTH: Bool = false, includeExpired: Bool = false) throws {
		
		let version: Int = 6
		
		let encoder = IBEncoder(serverVersion: serverVersion)
		
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.historicalData)
		
		if serverVersion <= IBServerVersion.SYNT_REALTIME_BARS {
			try container.encode(version)
		}
				
		try container.encode(reqId)
		try container.encode(contract)
		try container.encode(includeExpired)

		encoder.setDateFormat(format: "yyyyMMdd HH:mm:ss")
		try container.encodeOptional(lookback.endDate)
		try container.encode(size)
		try container.encode(lookback.description)
		try container.encode(useRTH)
		try container.encode(barSource)
		
		// format date 1: date string, 2: unix timestamp
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
		
		try container.encode(lookback.endDate == nil)
		try container.encode("")
		try send(encoder: encoder)

	}
	
	
	func subscribeRealTimeBar(_ reqId: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, useRTH: Bool = false) throws {
		
		assert([IBBarSource.trades, IBBarSource.bid, IBBarSource.ask, IBBarSource.midpoint].contains(barSource), "Only TRADES, BID; ASK; MIDPOINT are valid source types")
		
		let adjustedSize = IBBarSize.fiveSeconds
		if size != adjustedSize {print("only 5 sec bars are supported")}
		
		let version: Int = 3
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.realTimeBars)
		try container.encode(version)
		try container.encode(reqId)
		try container.encode(contract)
		try container.encode(adjustedSize.seconds)
		try container.encode(barSource)
		try container.encode(useRTH)
		try container.encode("")
		try send(encoder: encoder)

	}
	
	func unsubscribeRealTimeBar(_ reqId: Int) throws {
			
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelRealTimeBars)
		try container.encode(reqId)
		try send(encoder: encoder)

	}
	
	
	internal func requestMarketData(reqId: Int, contract:IBContract, events: [IBTickType]?=nil, snapshot: Bool, regulatory: Bool) throws {
				
		let version: Int = 11
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.marketData)
		try container.encode(version)
		try container.encode(reqId)
		try container.encode(contract)

		if contract.securitiesType == .combo {
			if let legs = contract.comboLegs{
				try container.encode(legs.count)
				for leg in legs {
					try container.encode(leg.conId)
					try container.encode(leg.ratio)
					try container.encode(leg.action)
					try container.encode(leg.exchange)
				}
			} else {
				try container.encode(0)
			}
		}
															
		if serverVersion >= IBServerVersion.DELTA_NEUTRAL {
			if let temp = contract.deltaNeutralContract {
				try container.encode(true)
				try container.encode(temp.conId)
				try container.encode(temp.delta)
				try container.encode(temp.price)
			} else{
				try container.encode(false)
			}
		}
		
		let list: String = events?.compactMap({"\($0.rawValue)"}).joined(separator: ",") ?? ""
		try container.encode(list)
		try container.encode(snapshot)

		if serverVersion >= IBServerVersion.REQ_SMART_COMPONENTS {
			try container.encode(regulatory)
		}

		if serverVersion >= IBServerVersion.LINKING{
			try container.encode("")
		}
		
		try send(encoder: encoder)

	}

	
	
	/// subscribes live quote events including bid / ask / last trade and respective sizes
	/// - Parameter reqId:
	/// - Parameter contract:
	/// - Parameter snapshot:
	/// - Parameter regulatory:
	
	func subscribeMarketData(_ reqId: Int, contract: IBContract, snapshot: Bool = false, regulatory: Bool = false) throws {
		try requestMarketData(reqId: reqId, contract: contract, events: [], snapshot: snapshot, regulatory: regulatory)
	}

	
	func unsubscribeMarketData(_ reqId: Int) throws {
		let version: Int = 2
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelMarketData)
		try container.encode(version)
		try container.encode(reqId)
		try send(encoder: encoder)
	}


	func subscribeMarketDepth(_ reqId: Int, contract: IBContract, rows: Int, smart: Bool = false) throws {
		
		let version = 5
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.marketDepth)
		try container.encode(version)
		try container.encode(reqId)
		
		try container.encode(contract)
		
		try container.encode(rows)
		
		if self.serverVersion >= IBServerVersion.SMART_DEPTH {
			try container.encode(smart)
		}
		
		if self.serverVersion >= IBServerVersion.LINKING {
			try container.encode("")
		}
		
		print(String(data:encoder.data, encoding: .ascii)!.debugDescription)

		try send(encoder: encoder)
	
	}


	func unsubscribeMarketDepth(_ reqId: Int) throws {
			
		let version = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelMarketDepth)
		try container.encode(version)
		try container.encode(reqId)
		try send(encoder: encoder)

	}

	
	
	// MARK: - Real time  tick data
	
	
	enum TickByTickType: String, Codable {
		case last 		= "Last"
		case allLast 	= "AllLast"
		case BidAsk		= "BidAsk"
		case midPoint	= "MidPoint"
	}
	
	
	func requestTickByTick(_ reqId: Int, contract: IBContract, tickType: TickByTickType, tickCount: Int, ignoreSize: Bool = true) throws {
	
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.tickByTickData)
		try container.encode(reqId)
		try container.encode(contract)
		try container.encode(tickType)
	 
		if serverVersion >= IBServerVersion.TICK_BY_TICK_IGNORE_SIZE{
			try container.encode(tickCount)
			try container.encode(ignoreSize)
		}
	 
		try send(encoder: encoder)

	}


	func cancelTickByTickData(_ reqId: Int) throws {
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelTickByTickData)
		try container.encode(reqId)
		try send(encoder: encoder)
	}
	
	enum IBTickSource: String, Encodable {
		case trades			= "TRADES"
		case midpoint		= "MIDPOINT"
		case bidAsk			= "BID_ASK"
	}
	
	/// High Resolution Historical Data
	/// - Parameter requestId: id of the request
	/// - Parameter contract: Contract object that is subject of query.
	/// - Parameter numberOfTicks, Number of distinct data points. Max is 1000 per request.
	/// - Parameter fromDate: requested period's starttime
	/// - Parameter whatToShow, (Bid_Ask, Midpoint, or Trades) Type of data requested.
	/// - Parameter useRth, Data from regular trading hours (1), or all available hours (0).
	/// - Parameter ignoreSize: Omit updates that reflect only changes in size, and not price. Applicable to Bid_Ask data requests.
		
	func historicalTicks(_ reqId: Int, contract: IBContract, numberOfTicks: Int, fromDate date: Date, whatToShow: IBTickSource, useRth: Bool, ignoreSize: Bool) throws {

		assert(numberOfTicks <= 1000, "Up to 1000 ticks allowed per request")
		
		let encoder = IBEncoder(serverVersion: serverVersion)
		encoder.setDateFormat(format: "yyyyMMdd HH:mm:ss")
		
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.tickHistory)
						
		try container.encode(reqId)
		try container.encode(contract.self)
		try container.encode(contract.isExpired)
		// start date. only start or end date is allowed
		try container.encode(date)
		// enddate placeholder. only start or end date is allowed
		try container.encode("")
		try container.encode(numberOfTicks)
		try container.encode(whatToShow)
		try container.encode(useRth)
		try container.encode(ignoreSize)
		try container.encode("")
		
		try send(encoder: encoder)
			
	}
	
}
