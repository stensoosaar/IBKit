//
//  IBTickEvent.swift
//  IBKit
//
//  Created by Sten Soosaar on 30.03.2025.
//

import Foundation


/*
public struct IBTickEvent<T>: IBEvent {
	var type: IBTickType
	var payload: T
}


extension IBTickEvent: Decodable{
	public init(from decoder: IBDecoder){}
}


extension IBResponseWrapper where T == IBTickEvent<TickEFP> {
	
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		let tickType = try container.decode(IBTickType.self)
		
		
		


	}
}


extension IBResponseWrapper where T == IBTickEvent<Shortable> {
	
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		
		
		


	}
}
*/
