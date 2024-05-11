//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBPriceHistory: IBResponse, IBIndexedEvent {
	
	public var requestID: Int
	public var interval: DateInterval
	public var prices: [IBPriceBar] = []
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		let startDate = try container.decode(Date.self)
		let endDate = try container.decode(Date.self)
		self.interval = DateInterval(start: startDate, end: endDate)
		let count = try container.decode(Int.self)
		
		for _ in 0..<count {
			let obj = try container.decode(IBPriceBar.self)
			prices.append(obj)
		}

	}
	
}

