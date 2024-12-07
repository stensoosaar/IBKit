//
//  File.swift
//  
//
//  Created by Sten Soosaar on 07.05.2024.
//

import Foundation


struct IBHistoricalTickBidAsk: Decodable {
	
	public var ticks: [IBTick] = []
	public var done: Bool

	init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		let requestID = try container.decode(Int.self)

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
				IBTick(requestID: requestID, type: .BidSize, value: sizeBid, date: Date(timeIntervalSince1970: time)),
				IBTick(requestID: requestID, type: .AskSize, value: sizeAsk, date: Date(timeIntervalSince1970: time)),
				IBTick(requestID: requestID, type: .BidPrice, value: priceBid, date: Date(timeIntervalSince1970: time)),
				IBTick(requestID: requestID, type: .AskPrice, value: priceAsk, date: Date(timeIntervalSince1970: time))
			])
			
		}
		
		done = try container.decode(Bool.self)

	}
}
