//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBNewsBulletin: IBResponse, IBEvent {
	
	public var messageID: Int
	public var messageType: Int
	public var message: String
	public var source: String
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		messageID = try container.decode(Int.self)
		messageType = try container.decode(Int.self)
		message = try container.decode(String.self)
		source = try container.decode(String.self)
	}
	
}
