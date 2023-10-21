//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBPriceBarUpdate: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	public var bar: IBPriceBar
	
	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.bar = try container.decode(IBPriceBar.self)
		
	}
}



