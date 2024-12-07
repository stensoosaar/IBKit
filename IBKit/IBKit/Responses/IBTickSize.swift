//
//  File.swift
//  
//
//  Created by Sten Soosaar on 07.05.2024.
//

import Foundation


public struct IBTickSize: Decodable {
	
	public var tick: IBTick
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		let requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		let value = try container.decode(Double.self)
		let date = Date()
		tick = IBTick(requestID: requestID, type: type, value: value, date: date)
	}
	
}

