//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBMarketRule: IBResponse, IBEvent {
	
	var marketRuleId: Int
	
	struct PriceIncrement: IBDecodable {
		var lowerBound: Double
		var step: Double
	}
	
	var values: [PriceIncrement] = []
	
	public init(from decoder: IBDecoder) throws {
		
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

