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



struct TickPriceParser: Decodable{
		
	public var ticks: [IBTick] = []

	init(from decoder: Decoder) throws {
		
		guard let decoder = decoder as? IBDecoder,
			  let serverVersion = decoder.serverVersion else {
			throw IBError.codingError("No server version found. Check the connection!")
		}

		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		let requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)

		var attr: [IBTickAttribute] = []
		let mask = try container.decode(Int.self)
		
		if serverVersion >= IBServerVersion.PAST_LIMIT{
			if mask & 1 != 0 { attr.append(.canAutoExecute)}
			if mask & 2 != 0 { attr.append(.pastLimit)}
		}
		
		if serverVersion >= IBServerVersion.PRE_OPEN_BID_ASK{
			if mask & 4 != 0 {attr.append(.preOpen)}
		}
		
		ticks.append(IBTick(requestID: requestID, date:Date(), type: type, value: price, attributes: attr.isEmpty ? nil : attr))

		var sizeType: IBTickType?
		
		if type == .BidPrice {
			sizeType = .BidSize
		} else if type == .AskPrice{
			sizeType = .AskSize
		} else if type == .LastPrice {
			sizeType = .LastSize
		} else if type == .DelayedBid{
			sizeType = .DelayedBidSize
		} else if type == .DelayedAsk {
			sizeType = .DelayedAskSize
		} else if type == .DelayedLast{
			sizeType = .DelayedLastSize
		}
		
		if size > 0 && sizeType != nil {
			ticks.append(IBTick(requestID: requestID, date: Date(), type: sizeType!, value: size, attributes: nil))
		}
		
	}
	
	
	
}




struct IBTickStringParser: Decodable {
	
	public var requestID: Int
	public var type: IBTickType
	public var value: String
	
	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_  = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)
		self.value = try container.decode(String.self)
	}
	
	/*
	var event: AnyObject{
		
		switch type {
			case .LastTimestamp, .LastRegulatoryTime, .DelayedLastTimestamp:
				let value = try container.decode(Double.self)
				let lastTimestamp = Date(timeIntervalSince1970: value)
				
			case .Dividends:
				let components = stringValue.components(separatedBy: ",")
				guard components.count == 4 else { throw IBError.codingError("failed to read dividend message")}
				
				let last12MonthDividends = Double(components[0])
				let last12MonthDividends = Double(components[1])
				(decoder as? IBDecoder)?.dateFormatter.dateFormat = "yyyyMMdd"
				nextDividendDate = (decoder as? IBDecoder)?.dateFormatter.date(from: components[2])
				last12MonthDividends = Double(components[3])
				
			case .RTTradeVolume, .RTVolumeTimeAndSales:
				let components = try container.decode(String.self).components(separatedBy: ";")
				guard components.count == 6 else { throw IBError.codingError("failed to read dividend message")}
				lastTradePrice = Double(components[0])
				lastTradeSize = Double(components[1])
				if let lastTradeTimestamp = Double(components[2]) {
					lastTradeDate = Date(timeIntervalSince1970: lastTradeTimestamp)
				} else {
					throw IBError.codingError("failed to read \(self.type) message")
				}
				totalVolume = Double(components[3])
				vwap = Double(components[4])
				filledBySingleMarketMaker = Int(components[5]) == 1 ? true : false
				
			case .OptionBidExchange, .OptionAskExchange, .BidExchange, .AskExchange, .LastExchange:
				exchange = try container.decode(String.self)
			case .News:
				news = try container.decode(String.self)
			default:
				break
		}
		
	}
	*/
}


struct HistoricalTickParser: Decodable{
	
	public var requestID: Int
	public var ticks: [IBTick] = []
	public var done: Bool
	
	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)

		let tickCount = try container.decode(Int.self)
		for _ in 0..<tickCount {
			let time = try container.decode(Double.self)
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)
			ticks.append(contentsOf: [
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .LastPrice, value: price),
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .LastSize, value: size)
			])
		}

		done = try container.decode(Bool.self)

	}
}


struct HistoricalTicksBidAskPerser: Decodable{
	
	public var requestID: Int
	public var ticks: [IBTick] = []
	public var done: Bool

	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)

		let tickCount = try container.decode(Int.self)
		for _ in 0..<tickCount {
			let time = try container.decode(Double.self)
			let mask = try container.decode(Int.self)
			var attr: [IBTickAttribute] = []
			if mask & 1 != 0 { attr.append(.askPastHigh)}
			if mask & 2 != 0 { attr.append(.bidPastLow)}
			let priceBid = try container.decode(Double.self)
			let priceAsk = try container.decode(Double.self)
			let sizeBid = try container.decode(Double.self)
			let sizeAsk = try container.decode(Double.self)
			
			ticks.append(contentsOf: [
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .BidSize, value: sizeBid),
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .AskSize, value: sizeAsk),
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .BidPrice, value: priceBid),
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .AskPrice, value: priceAsk)
			])
			
		}
		
		done = try container.decode(Bool.self)

	}
}


struct HistoricalTicksLastParser: Decodable{
	
	public var requestID: Int
	public var ticks: [IBTick] = []
	public var done: Bool

	
	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)

		let tickCount = try container.decode(Int.self)
		for _ in 0..<tickCount {

			let time = try container.decode(Double.self)
			
			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.pastLimit)}
			if mask & 2 != 0 { attr.append(.unreported)}

			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)
			let exchange = try container.decode(String.self)
			_ = try container.decode(String.self)
			ticks.append(contentsOf: [
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .LastPrice, value: price, exchange: exchange),
				IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .LastSize, value: size, exchange: exchange)
			])

		}

		done = try container.decode(Bool.self)

	}
}


struct TickByTickParser: Decodable, IBIndexedEvent{

	public var requestID: Int
	public var time: Double
	public var ticks: [IBTick] = []
	
	init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		time = try container.decode(Double.self)
		let tickType = try container.decode(Int.self)

		if tickType == 1 || tickType == 2 {
			// Last or AllLast
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)

			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.pastLimit)}
			if mask & 2 != 0 { attr.append(.unreported)}

			let exchange = try container.decode(String.self)
			_ = try container.decode(String.self)
			ticks.append(IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .LastPrice, value: price, exchange: exchange))
			ticks.append(IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .LastSize, value: size, exchange: exchange))

		} else if tickType == 3{
			// BidAsk
			let bidPrice = try container.decode(Double.self)
			let askPrice = try container.decode(Double.self)
			let bidSize = try container.decode(Double.self)
			let askSize = try container.decode(Double.self)
			
			ticks.append(IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .BidPrice, value: bidPrice))
			ticks.append(IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .AskPrice, value: askPrice))
			ticks.append(IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .BidSize, value: bidSize))
			ticks.append(IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .AskSize, value: askSize))
			
			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.bidPastLow)}
			if mask & 2 != 0 { attr.append(.askPastHigh)}

		} else if tickType == 4 {
			//MidPoint
			let midPoint = try container.decode(Double.self)
			ticks.append(IBTick(requestID: requestID, date: Date(timeIntervalSince1970: time), type: .MarkPrice, value: midPoint))

		}
	}
}


