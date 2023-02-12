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

/**
 First data point date for respective contract / bar source combination
 */
public struct IBHeadTimestamp: Decodable, IBMarketEvent {
	
	public var requestID: Int
	
	public var date: Date
	
	public enum CodingKeys: CodingKey {
		case reqId
		case date
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		self.date = try container.decode(Date.self)
	}
	
}


public struct IBPriceHistory: Decodable, IBMarketEvent {
	
	public var requestID: Int
	public var interval: DateInterval
	public var prices: [IBPriceBar] = []
	
	public init(from decoder: Decoder) throws {
		
		guard let decoder = decoder as? IBDecoder else {
			throw IBError.invalidValue("IB Decoder needed for decoding")
		}
		
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		decoder.setDateFormat(format: "yyyyMMdd HH:mm:ss")
		let startDate = try container.decode(Date.self)
		let endDate = try container.decode(Date.self)
		self.interval = DateInterval(start: startDate, end: endDate)
		let count = try container.decode(Int.self)
		decoder.setDateFormat(format: "yyyyMMdd")
		
		for _ in 0..<count {
			let obj = try container.decode(IBPriceBar.self)
			prices.append(obj)
		}

	}
	
}


public struct IBPriceHistoryUpdate: Decodable, IBMarketEvent {
	
	public var requestID: Int
	public var prices: [IBPriceBar] = []
	
	public init(from decoder: Decoder) throws {
		
		guard let decoder = decoder as? IBDecoder else {
			throw IBError.invalidValue("IB Decoder needed for decoding")
		}
		
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		
		let count = try container.decode(Int.self)
		if count == -1{return}
		
		decoder.setDateFormat(format: "yyyyMMdd")
		for _ in 0..<count {
			let obj = try container.decode(IBPriceBar.self)
			prices.append(obj)
		}

	}
	
}


public struct IBPriceBarUpdate: Decodable, IBMarketEvent {
	
	public var requestID: Int
	public var bar: IBPriceBar
	
	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.bar = try container.decode(IBPriceBar.self)
		
	}
}


public struct IBMarketRule: IBSystemEvent, Decodable {
	
	var marketRuleId: Int
	
	struct PriceIncrement{
		var lowerBound: Double
		var step: Double
	}
	
	var values: [PriceIncrement] = []
	
	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		marketRuleId = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		for _ in 0..<count{
			let lowerBound = try container.decode(Double.self)
			let step = try container.decode(Double.self)
			values.append(PriceIncrement(lowerBound: lowerBound, step: step))
		}
		
	}
	
	
}




// MARK: - Tick events


struct MarketDataType: Decodable, IBMarketEvent {
	
	public var requestID: Int
	public var type: IBMarketDataType
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		self.type = try container.decode(IBMarketDataType.self)
	}
	
}

//Decoding error decodingError(message: "cant unwrap Int from 0.01, cursor: 3")	Optional("81\010027\00.01\0\00\0")

public struct IBTickParameters: Decodable, IBMarketEvent {
	
	public var requestID: Int
	public var tickSize: Double
	public var BBOExchange: String
	public var snapshotPermissions: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		tickSize = try container.decode(Double.self)
		BBOExchange = try container.decode(String.self)
		snapshotPermissions = try container.decode(Int.self)
	}
	
}



/// Exchange of physicals
///
/// A private agreement between two parties allowing for one party to swap a futures contract for the actual underlying asse

struct IBEFPEvent: Decodable, IBMarketEvent {
	
	public var requestID: Int
	
	public var type: IBTickType
	
	public var points: Double
	
	public var pointsFormatted: String
	
	public var impliedPrice: Double
	
	public var holded: Int
	
	public var futureLastTradeDate: Date
	
	public var dividendImpact: Double
	
	public var dividendsToLastTradeDate: Double
	
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)
		self.points = try container.decode(Double.self)
		self.pointsFormatted = try container.decode(String.self)
		self.impliedPrice = try container.decode(Double.self)
		self.holded = try container.decode(Int.self)
		self.futureLastTradeDate = try container.decode(Date.self)
		self.dividendImpact = try container.decode(Double.self)
		self.dividendsToLastTradeDate = try container.decode(Double.self)
	}
	
}


struct IBOptionComputationEvent: Decodable, IBMarketEvent{
	
	public var requestID: Int
	
	public var type: IBTickType
	
	public var impliedVolatility: Double?
	
	public var dividendNPV: Double?
	
	public var delta: Double?
	
	public var optionPrice: Double?
	
	public var pvDividend: Double?
	
	public var gamma: Double?
	
	public var vega: Double?
	
	public var theta: Double?
	
	public var underlyingPrice: Double?
	
	public enum CalculationBase: Int, Codable {
		case returnBased 	= 0
		case priceBased		= 1
	}

	public var calculationBase: CalculationBase?
	
	
	public init(from decoder: Decoder) throws {
		
		guard let decoder = decoder as? IBDecoder,
			  let serverVersion = decoder.serverVersion else {
			throw IBError.codingError("No server version found. Check the connection!")
		}

		var container = try decoder.unkeyedContainer()

		let version = serverVersion < IBServerVersion.PRICE_BASED_VOLATILITY ? try container.decode(Int.self) : serverVersion

		self.requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)

		if serverVersion >= IBServerVersion.PRICE_BASED_VOLATILITY {
			calculationBase = try container.decode(CalculationBase.self)
		}

		let iv = try container.decode(Double.self)
		self.impliedVolatility = iv < 0 ? nil : iv
	
		let d = try container.decode(Double.self)
		self.delta = d == -2 ? nil : d

		if version >= 6 ||  type == .ModelOptionComputation || type == .DelayedModelOption {
			
			let op = try container.decode(Double.self)
			optionPrice = op == -1 ? nil : op
			
			let dnpv = try container.decode(Double.self)
			dividendNPV = dnpv == -1 ? nil : dnpv
			
		}

		if version >= 6 {
		
			let gammaValue = try container.decode(Double.self)
			self.gamma = gammaValue == -2 ? nil : gammaValue
		
			
			let vegaValue = try container.decode(Double.self)
			self.vega = vegaValue == -2 ? nil : vegaValue
			
			let thetaValue = try container.decode(Double.self)
			self.theta = thetaValue == -2 ? nil : thetaValue

			let undPriceValue = try container.decode(Double.self)
			self.underlyingPrice = undPriceValue == -1 ? nil : undPriceValue

		}
		
	}
	
}


struct TickPriceParser: Decodable{
		
	public var ticks: [IBTickEvent] = []

	init(from decoder: Decoder) throws {
		
		guard let decoder = decoder as? IBDecoder,
			  let serverVersion = decoder.serverVersion else {
			throw IBError.codingError("No server version found. Check the connection!")
		}

		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		let reqId = try container.decode(Int.self)
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
		
		ticks.append(IBTickEvent(reqId: reqId, date:Date(), type: type, value: price, attributes: attr.isEmpty ? nil : attr))

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
			ticks.append(IBTickEvent(reqId: reqId, date: Date(), type: sizeType!, value: size, attributes: nil))
		}
		
	}
	
	
	
}


public struct IBTickEvent: IBMarketEvent {
	
	public var requestID: Int
	public var date: Date
	public var type: IBTickType
	public var value: Double
	public var exchange: String?
	public var attributes: [IBTickAttribute]?
	
	internal init(reqId:Int, date:Date, type: IBTickType, value:Double, exchange: String? = nil, attributes:[IBTickAttribute]?=nil){
		self.requestID = reqId
		self.date = date
		self.type = type
		self.value = value
		self.exchange = exchange
		self.attributes = attributes
	}
	
}


extension IBTickEvent: Decodable {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_  = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)
		self.value = try container.decode(Double.self)
		self.date = Date()
		self.attributes = nil
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
	public var ticks: [IBTickEvent] = []
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
				IBTickEvent(reqId: requestID, date: Date(timeIntervalSince1970: time), type: .DelayedLast, value: price),
				IBTickEvent(reqId: requestID, date: Date(timeIntervalSince1970: time), type: .DelayedLastSize, value: size)
			])
		}

		done = try container.decode(Bool.self)

	}
}


struct HistoricalTicksBidAskPerser: Decodable{
	
	public var reqId: Int
	public var ticks: [IBTickEvent] = []
	public var done: Bool

	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		reqId = try container.decode(Int.self)

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
				IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .DelayedBidSize, value: sizeBid),
				IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .DelayedAskSize, value: sizeAsk),
				IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .DelayedBid, value: priceBid),
				IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .DelayedAsk, value: priceAsk)
			])
			
		}
		
		done = try container.decode(Bool.self)

	}
}


struct HistoricalTicksLastParser: Decodable{
	
	public var reqId: Int
	public var ticks: [IBTickEvent] = []
	public var done: Bool

	
	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		reqId = try container.decode(Int.self)

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
				IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .DelayedLast, value: price, exchange: exchange),
				IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .DelayedLastSize, value: size, exchange: exchange)
			])

		}

		done = try container.decode(Bool.self)

	}
}


struct TickByTickParser: Decodable{

	public var reqId: Int
	public var time: Double
	public var ticks: [IBTickEvent] = []
	
	init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		reqId = try container.decode(Int.self)
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
			ticks.append(IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .LastPrice, value: price, exchange: exchange))
			ticks.append(IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .LastSize, value: size, exchange: exchange))

		} else if tickType == 3{
			// BidAsk
			let bidPrice = try container.decode(Double.self)
			let askPrice = try container.decode(Double.self)
			let bidSize = try container.decode(Double.self)
			let askSize = try container.decode(Double.self)
			
			ticks.append(IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .BidPrice, value: bidPrice))
			ticks.append(IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .AskPrice, value: askPrice))
			ticks.append(IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .BidSize, value: bidSize))
			ticks.append(IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .AskSize, value: askSize))
			
			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.bidPastLow)}
			if mask & 2 != 0 { attr.append(.askPastHigh)}

		} else if tickType == 4 {
			//MidPoint
			let midPoint = try container.decode(Double.self)
			ticks.append(IBTickEvent(reqId: reqId, date: Date(timeIntervalSince1970: time), type: .MarkPrice, value: midPoint))

		}
	}
}


