//
//  PriceEvents.swift
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




struct IBTickString: Decodable {
	
	var tick: any IBAnyMarketData
	
	init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()

		_  = try container.decode(Int.self)
		let requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		
		switch type {
			
		case .LastTimestamp, .LastRegulatoryTime, .DelayedLastTimestamp:
			let timeInterval = try container.decode(Double.self)
			tick = IBTickTimestamp(requestID: requestID, type: type, value: timeInterval)
				
		case .Dividends:
			let report = try container.decode(IBDividend.Report.self)
			tick = IBDividend(requestID: requestID, type: .Dividends, value: report)
			
		case .RTTradeVolume, .RTVolumeTimeAndSales:
			let report = try container.decode(IBRealTimeSales.LastTrade.self)
			tick = IBRealTimeSales(requestID: requestID, type: type, value: report)
				
		case .OptionBidExchange, .OptionAskExchange, .BidExchange, .AskExchange, .LastExchange:
			let exchange = try container.decode(String.self)
			tick = IBTickExchange(requestID: requestID, type: type, value: exchange)
			
		default:
			throw IBClientError.decodingError("unknown tick string of type \(type) received")
		}
		
	}
	
}

