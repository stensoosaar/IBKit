//
//  File.swift
//  
//
//  Created by Sten Soosaar on 26.04.2024.
//

import Foundation


public struct IBPriceBarHistoryUpdate: IBResponse {
	
	public var requestID: Int
	public var bar: IBPriceBar
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		let barCount = try container.decode(Int.self)

		let date = try container.decode(Date.self)
		let open = try container.decode(Double.self)
		let high = try container.decode(Double.self)
		let low = try container.decode(Double.self)
		let close = try container.decode(Double.self)
		let wap = try container.decodeOptional(Double.self)
		let volume = try container.decodeOptional(Double.self)
			
		bar = IBPriceBar(
			date: date,
			open: open,
			high: high,
			low: low,
			close: close,
			volume: volume,
			wap: wap,
			count: barCount
		)
	}
		
	
}
