//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


//Decoding error decodingError(message: "cant unwrap Int from 0.01, cursor: 3")	Optional("81\010027\00.01\0\00\0")

public struct IBTickParameters: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	public var tickSize: Double
	public var BBOExchange: String
	public var snapshotPermissions: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		tickSize = try container.decode(Double.self)
		BBOExchange = try container.decode(String.self)
		snapshotPermissions = try container.decode(Int.self)
	}
	
}
