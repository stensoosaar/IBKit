//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBNewsBulletin: IBResponse, IBEvent, Sendable {
	
	public let messageID: Int
	public let messageType: Int
	public let message: String
	public let source: String
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		messageID = try container.decode(Int.self)
		messageType = try container.decode(Int.self)
		message = try container.decode(String.self)
		source = try container.decode(String.self)
	}
	
}
