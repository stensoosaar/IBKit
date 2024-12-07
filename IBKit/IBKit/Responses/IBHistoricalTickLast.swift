//
//  File.swift
//  
//
//  Created by Sten Soosaar on 07.05.2024.
//

import Foundation




struct IBHistoricalTickLast: Decodable {
	
	var requestID: Int
	var ticks: [any IBAnyMarketData] = []
	var done: Bool

	
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
			
			let temp: [any IBAnyMarketData] = [
				IBTick(requestID: requestID, type: .LastPrice, value: price, date: Date(timeIntervalSince1970: time)),
				IBTick(requestID: requestID, type: .LastSize, value: size, date: Date(timeIntervalSince1970: time)),
				IBTickExchange(requestID: requestID, type: .LastExchange, value: exchange)
			]
			
			ticks.append(contentsOf: temp)

		}

		done = try container.decode(Bool.self)

	}
}
