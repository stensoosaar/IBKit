//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation

public struct IBServerError: IBResponse, IBEvent, IBIndexedEvent, IBDecodable {
	public let requestID: Int
	public let error: IBError
		
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.error = try container.decode(IBError.self)
	}
	
}
