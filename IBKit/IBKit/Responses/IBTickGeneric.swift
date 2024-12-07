//
//  File.swift
//  
//
//  Created by Sten Soosaar on 11.05.2024.
//

import Foundation

/*
 - Option Implied Volatility
 - Index Future Premium
 - Shortable
 - Halted
 - Trade Count
 - Trade Rate
 - Volume Rate
 - RT Historical Volatility
 - Bond Factor Multiplier
 - Estimated IPO - Midpoint
 - Final IPO Price
*/

struct IBTickGeneric: Decodable{
	
	var tick: any IBAnyMarketData

	init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		let requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		let value = try container.decode(Double.self)
		
		switch type {
		case .Shortable:
			tick = IBShortable(requestID: requestID, type: type, value: value)
		default:
			tick = IBTick(requestID: requestID, type: type, value: value, date: Date())
		}
		
	}
	
	
}
