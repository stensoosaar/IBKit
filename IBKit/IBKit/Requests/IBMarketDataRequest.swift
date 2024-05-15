//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation






public struct IBMarketDataRequest: IBIndexedRequest{
	
	public enum SubscriptionType: Int, Encodable {
	case OptionVolume					= 100
	case OptionOpenInterest				= 101
	case OptionHistoricalVolatility		= 104
	case AverageOptionVolume			= 105
	case OptionImpliedVolatility		= 106
	case IndexFuturePremium				= 162
	case HighLowVolumeStats				= 165
	case Auction						= 225
	case MarkPrice						= 232
	case RTVolumeTimeAndSales			= 233
	case Shortable						= 236
	case News							= 292
	case TradeCount						= 293
	case TradeRate						= 294
	case VolumeRate						= 295
	case LastRTHTrade					= 318
	case RTTradeVolume					= 375
	case RTHistoricalVolatility			= 411
	case Dividends						= 456
	case BondFactorMultiplier			= 460
	case IPDData						= 586
	case FuturesOpenInterest			= 588
	case ShortTermVolume				= 595
	case NAVBidAsk						= 576
	case ETFNavLast						= 577
	case ETFNavClose					= 578
	case ETFNavHighLow					= 614
	case ETFNavFrozenLast				= 623
	case CreditmanSlowMarkPrice			= 619
	}
	
	
	public let version: Int = 11
	public var requestID: Int
	public var type: IBRequestType = .marketData
	public var contract:IBContract
	public var events: [SubscriptionType]
	public var snapshot: Bool
	public var regulatory: Bool
	
	public init(requestID: Int, contract: IBContract, events: [SubscriptionType], snapshot: Bool = false, regulatory: Bool = false) {
		self.requestID = requestID
		self.contract = contract
		self.events = events
		self.snapshot = snapshot
		self.regulatory = regulatory
	}

	public init(requestID: Int, contract: IBContract, snapshot: Bool = false, regulatory: Bool = false) {
		self.requestID = requestID
		self.contract = contract
		self.events = []
		self.snapshot = snapshot
		self.regulatory = regulatory
	}

	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBClientError.encodingError("Server value expected")
		}

		var container = encoder.unkeyedContainer()
		
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
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


public struct IBMarketDataCancellationRequest: IBIndexedRequest{
	
	public let version: Int = 2
	public var type: IBRequestType = .cancelMarketData
	public var requestID: Int
	
	public init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelMarketData)
		try container.encode(version)
		try container.encode(requestID)
	}
	
}
