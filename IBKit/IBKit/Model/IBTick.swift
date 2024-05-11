//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public enum IBTickAttribute: String, IBDecodable {
	
	/// The Bid price is lower than the day's lowest value or the ask price is higher than the highest ask.
	case pastLimit 			= "pastLimit"
	
	/// The Bid is lower than day's lowest low.
	case bidPastLow			= "bidPastLow"
	
	/// The Ask is higher than day's highest ask.
	case askPastHigh 		= "askPastHigh"
	
	/// Whether the price tick is available for automatic execution or not
	case canAutoExecute 	= "canAutoExecute"
	
	/// The bid/ask price tick is from pre-open session.
	case preOpen 			= "preOpen"
	
	/// Trade is classified as 'unreportable' (e.g. odd lots, combos, derivative trades, etc)
	case unreported 		= "unreported"
	
}


extension Double: IBDecodable{}
extension Int: IBDecodable{}
extension String: IBDecodable {}



public protocol AnyMarketData: IBIndexedEvent {
	
	associatedtype ResultType: Any
	
	var requestID: Int 				{get}
	var type: IBTickType 			{get}
	var value: ResultType			{get}
	
}


public struct IBTick: AnyMarketData{
	
	public typealias ResultType = Double
	
	public var requestID: Int
	public var type: IBTickType
	public var value: Double
	public var date: Date

}

public struct IBTickTimestamp: AnyMarketData {
	public typealias TickValue = TimeInterval
	public var requestID: Int
	public var type: IBTickType
	public var value: TickValue

}



public struct IBTickExchange: AnyMarketData {
	public typealias TickValue = String
	public var requestID: Int
	public var type: IBTickType
	public var value: TickValue
}



public struct IBDividend: AnyMarketData {
	
	public struct Report: IBDecodable {
		public var paidDividends: String?
		public var expectedDividends: String?
		public var nextDividendDate: String?
		public var nextDividend: String?

		public init(from decoder: IBDecoder) throws {
			
			var container = try decoder.unkeyedContainer()
			let components = try container.decode(String.self).components(separatedBy: ",")
			guard components.count == 4  else {
				throw  IBClientError.decodingError("failed to decode dividend info")
			}
			paidDividends = components[0]
			expectedDividends = components[1]
			nextDividendDate = components[2]
			nextDividend = components[3]
		}
		
	}
	
	public typealias TickValue = Report
	public let requestID: Int
	public let type: IBTickType
	public let value: TickValue
	
}


public struct IBRealTimeSales: AnyMarketData{
	
	public struct LastTrade: IBDecodable {
		public var timestamp: String?
		public var price: String?
		public var size: String?
		public var totalVolume: String?
		public var vwap: String?
		public var filledBySingleMarketMaker: String?

		public init(from decoder: IBDecoder) throws {
			
			var container = try decoder.unkeyedContainer()
			let components = try container.decode(String.self).components(separatedBy: ";")
			guard components.count == 6  else {
				throw  IBClientError.decodingError("failed to decode dividend info")
			}
			price = components[0]
			size = components[1]
			timestamp = components[2]
			totalVolume = components[3]
			vwap = components[4]
			filledBySingleMarketMaker = components[5]
		}
		
	}
	
	public typealias TickValue = LastTrade
	public let requestID: Int
	public let type: IBTickType
	public let value: TickValue

}




public struct IBTradingStatus: AnyMarketData{
	
	public enum Status: Int, IBDecodable {
		case unknown 			= -1
		case active  			= 0
		case generalHalt 		= 1
		case volatilityHalt 	= 2
	}
	
	public typealias TickValue = Status
	public let requestID: Int
	public let type: IBTickType
	public let value: TickValue
}



public struct IBShortable: AnyMarketData{
	
	public typealias TickValue = Double
	public let requestID: Int
	public let type: IBTickType
	public let value: TickValue
	
	public enum Status {
		case shortable
		case locatable
		case notShortable
	}
	
	public var status: Status {
		switch value {
		case 0...1.5: 		return .notShortable
		case 1.5...2.5: 	return .locatable
		default:			return .shortable
		}
	}
	
	
}
