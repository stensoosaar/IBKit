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


public struct IBMarketDataRequest: Identifiable, IBCancellableRequest {
	
	public enum EventType: Int, Encodable {
		case OptionVolume = 100
		case OptionOpenInterest = 101
		case OptionHistoricalVolatility = 104
		case AverageOptionVolume = 105
		case OptionImpliedVolatility = 106
		case IndexFuturePremium = 162
		case HighLowVolumeStats = 165
		case Auction = 225
		case MarkPrice = 232
		case RTVolumeTimeAndSales = 233
		case Shortable = 236
		case News = 292
		case TradeCount = 293
		case TradeRate = 294
		case VolumeRate = 295
		case LastRTHTrade = 318
		case RTTradeVolume = 375
		case RTHistoricalVolatility = 411
		case Dividends = 456
		case BondFactorMultiplier = 460
		case IPDData = 586
		case FuturesOpenInterest = 588
		case ShortTermVolume = 595
		case NAVBidAsk = 576
		case ETFNavLast = 577
		case ETFNavClose = 578
		case ETFNavHighLow = 614
		case ETFNavFrozenLast = 623
		case CreditmanSlowMarkPrice = 619
	}
	
	public let id: Int
	public let type: IBRequestType = .marketData
	public let contract:IBContract
	public let events: [EventType]
	public let snapshot: Bool
	public let regulatory: Bool
	private let version: Int = 11
	
	/// Creates new live data request
	/// - Parameters:
	///	 - id: unique request id
	///  - contract: contract
	///  - events: events to be subscribed
	///  - snapshot:  whatever
	///  - regulatory: whetever

	public init(id: Int, contract: IBContract, events: [EventType] = [], snapshot: Bool = false, regulatory: Bool = false) {
		self.id = id
		self.contract = contract
		self.events = events
		self.snapshot = snapshot
		self.regulatory = regulatory
	}
	
	public var cancel: any IBRequest{
		return IBMarketDataCancellation(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBError.encodingError("Server value expected")
		}

		var container = encoder.unkeyedContainer()
		
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
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
		
		let list: String = events.compactMap({"\($0.rawValue)"}).joined(separator: ",")
		try container.encode(list)
		try container.encode(snapshot)

		if serverVersion >= IBServerVersion.REQ_SMART_COMPONENTS {
			try container.encode(regulatory)
		}

		if serverVersion >= IBServerVersion.LINKING{
			try container.encode("")
		}

	}
	
}




public struct IBMarketDataCancellation: IBRequest, Identifiable{
	
	public var id: Int
	public let type: IBRequestType = .cancelMarketData
	private let version: Int = 2

	public init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
}

