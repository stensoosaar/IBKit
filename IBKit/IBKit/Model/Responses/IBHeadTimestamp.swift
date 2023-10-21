//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



/**
 First data point date for respective contract / bar source combination
 */
public struct IBHeadTimestamp: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	
	public var date: Date
	
	public enum CodingKeys: CodingKey {
		case reqId
		case date
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		self.date = try container.decode(Date.self)
	}
	
}
