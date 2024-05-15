//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation




public struct IBPriceBarUpdate: IBResponse, IBIndexedEvent {
	
	public var requestID: Int
	public var bar: IBPriceBar
	
	internal init(requestID: Int, bar: IBPriceBar) {
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



