//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBServerTime: Decodable, IBEvent {
	
	public let time: Date
	
	public init(from decoder: Decoder) throws {

		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		let unixTimestamp = try container.decode(Double.self)
		time = Date(timeIntervalSince1970: unixTimestamp)
	}
	
}

