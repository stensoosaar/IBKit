//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBPriceBarUpdate: IBDecodable, IBIndexedEvent {
	
	public var requestID: Int
	public var bar: IBPriceBar
	
	internal init(requestID: Int, bar: IBPriceBar){
		self.requestID = requestID
		self.bar = bar
	}
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		
		
		self.requestID = try container.decode(Int.self)
		self.bar = try container.decode(IBPriceBar.self)
		
	}
}


public struct IBPriceBarHistoryUpdate: IBDecodable {
	
	public var requestID: Int
	public var bar: IBPriceBar?
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		//_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		let count = try container.decode(Int.self)
		if count != -1 {
			let date = try container.decode(Date.self)
			let open = try container.decode(Double.self)
			let high = try container.decode(Double.self)
			let low = try container.decode(Double.self)
			let close = try container.decode(Double.self)
			let wap = try container.decodeOptional(Double.self)
			let volume = try container.decodeOptional(Double.self)
			let count = try container.decodeOptional(Int.self)
			
			bar = IBPriceBar(
				date: date,
				open: open, 
				high: high,
				low: low,
				close: close,
				volume: volume,
				wap: wap,
				count: count
			)
		}
		
	}

	
	
}
