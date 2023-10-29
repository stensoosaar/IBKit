//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBPriceHistory: Decodable, IBIndexedEvent {
	
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
		decoder.setDateFormat(format: "yyyyMMdd HH:mm:ss zzz")
		
		for _ in 0..<count {
			let obj = try container.decode(IBPriceBar.self)
			prices.append(obj)
		}

	}
	
}
