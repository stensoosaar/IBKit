//
//  File.swift
//  
//
//  Created by Sten Soosaar on 07.05.2024.
//

import Foundation


struct IBTickByTick: Decodable {

	public var ticks: [any AnyMarketData] = []
	
	init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		let requestID = try container.decode(Int.self)
		let time = try container.decode(Double.self)
		let tickType = try container.decode(Int.self)

		if tickType == 1 || tickType == 2 {
			
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)

			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.pastLimit)}
			if mask & 2 != 0 { attr.append(.unreported)}

			let exchange = try container.decode(String.self)
			_ = try container.decode(String.self)
			ticks.append(IBTick(requestID: requestID, type: .LastPrice, value: price, date: Date(timeIntervalSince1970: time)))
			ticks.append(IBTick(requestID: requestID, type: .LastSize, value: size, date: Date(timeIntervalSince1970: time)))
			ticks.append(IBTickExchange(requestID: requestID, type: .LastExchange, value: exchange))

		} else if tickType == 3{
			
			let bidPrice = try container.decode(Double.self)
			let askPrice = try container.decode(Double.self)
			let bidSize = try container.decode(Double.self)
			let askSize = try container.decode(Double.self)
			
			ticks.append(IBTick(requestID: requestID, type: .BidPrice, value: bidPrice, date: Date(timeIntervalSince1970: time)))
			ticks.append(IBTick(requestID: requestID, type: .AskPrice, value: askPrice, date: Date(timeIntervalSince1970: time)))
			ticks.append(IBTick(requestID: requestID, type: .BidSize, value: bidSize, date: Date(timeIntervalSince1970: time)))
			ticks.append(IBTick(requestID: requestID, type: .AskSize, value: askSize, date: Date(timeIntervalSince1970: time)))
			
			var attr: [IBTickAttribute] = []
			let mask = try container.decode(Int.self)
			if mask & 1 != 0 { attr.append(.bidPastLow)}
			if mask & 2 != 0 { attr.append(.askPastHigh)}

		} else if tickType == 4 {
			
			let midPoint = try container.decode(Double.self)
			ticks.append(IBTick(requestID: requestID, type: .MarkPrice, value: midPoint, date: Date(timeIntervalSince1970: time)))

		}
	}
}

