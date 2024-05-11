//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBTickParameters: IBResponse, IBIndexedEvent {
	
	public var requestID: Int
	public var tickSize: Double
	public var BBOExchange: String
	public var snapshotPermissions: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		tickSize = try container.decode(Double.self)
		BBOExchange = try container.decode(String.self)
		snapshotPermissions = try container.decode(Int.self)
	}
	
}

