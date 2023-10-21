//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



struct IBCurrentMarketDataType: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	public var type: IBMarketDataType
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		self.type = try container.decode(IBMarketDataType.self)
	}
	
}
