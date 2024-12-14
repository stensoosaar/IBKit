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
public struct IBHeadTimestamp: IBResponse, IBIndexedEvent, Sendable {
	
	public let requestID: Int
	
	public let date: Date
		
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		self.date = try container.decode(Date.self)
	}
	
}
