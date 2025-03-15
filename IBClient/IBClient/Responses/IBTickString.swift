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

/**
 Option Bid Exchange
 Option Ask Exchange
 Bid Exchange
 Ask Exchange
 Last Exchange

 Last Timestamp
 Last Regulatory Time
 Delayed Last Timestamp
 
 RT Volume (Time & Sales)
 RT Trade Volume

 IB Dividends
 News
 
 */


struct IBTickString: IBEvent {
	var requestID: Int
	var tick: any IBMarketData
}

extension IBTickString: IBDecodable{
	
	init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_  = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		
		switch type {
			
		case .LastTimestamp, .LastRegulatoryTime, .DelayedLastTimestamp:
			let timeInterval = try container.decode(Double.self)
			tick = IBTickTimestamp(type: type, value: timeInterval)
				
		case .Dividends:
			let report = try container.decode(IBDividend.Report.self)
			tick = IBDividend(type: .Dividends, value: report)
			
		case .RTTradeVolume, .RTVolumeTimeAndSales:
			let report = try container.decode(IBRealTimeSales.LastTrade.self)
			tick = IBRealTimeSales(type: type, value: report)
				
		case .OptionBidExchange, .OptionAskExchange, .BidExchange, .AskExchange, .LastExchange:
			let exchange = try container.decode(String.self)
			tick = IBTickExchange(type: type, value: exchange)
			
		default:
			throw IBError.decodingError("unknown tick string of type \(type) received")
		}
		
	}
	
}


public struct IBDividend: IBMarketData {
	
	public struct Report: IBDecodable, Sendable {
		public var paidDividends: String?
		public var expectedDividends: String?
		public var nextDividendDate: String?
		public var nextDividend: String?

		public init(from decoder: IBDecoder) throws {
			
			var container = try decoder.unkeyedContainer()
			let components = try container.decode(String.self).components(separatedBy: ",")
			guard components.count == 4  else {
				throw  IBError.decodingError("failed to decode dividend info")
			}
			paidDividends = components[0]
			expectedDividends = components[1]
			nextDividendDate = components[2]
			nextDividend = components[3]
		}
		
	}
	
	public typealias TickValue = Report
	public let type: IBTickType
	public let value: TickValue
	
}


public struct IBRealTimeSales: IBMarketData{

	public struct LastTrade: IBDecodable, Sendable {
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
				throw  IBError.decodingError("failed to decode real time sales info")
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
	public let type: IBTickType
	public let value: TickValue

}





public struct IBTickTimestamp: IBMarketData {
	public typealias TickValue = TimeInterval
	public var type: IBTickType
	public var value: TickValue

}


public struct IBTickExchange: IBMarketData{
	public typealias TickValue = String
	public var type: IBTickType
	public var value: TickValue
}


