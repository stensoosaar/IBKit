//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBNewsProviders: Decodable, IBEvent {
	
	public var values: [String:String] = [:]
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let count = try container.decode(Int.self)
		for _ in 0..<count {
			let code = try container.decode(String.self)
			let name = try container.decode(String.self)
			values[code] = name
		}
	}
	
}
