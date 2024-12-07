//
//  File.swift
//  
//
//  Created by Sten Soosaar on 07.05.2024.
//

import Foundation


struct IBHistoricTick: Decodable{
	
	public var ticks: [IBTick] = []
	public var done: Bool
	
	init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let requestID = try container.decode(Int.self)

		let tickCount = try container.decode(Int.self)
		for _ in 0..<tickCount {
			let time = try container.decode(Double.self)
			let price = try container.decode(Double.self)
			let size = try container.decode(Double.self)
			ticks.append(contentsOf: [
				IBTick(requestID: requestID, type: .LastPrice, value: price, date: Date(timeIntervalSince1970: time)),
				IBTick(requestID: requestID, type: .LastSize, value: size, date: Date(timeIntervalSince1970: time))
			])
		}

		done = try container.decode(Bool.self)

	}
}
