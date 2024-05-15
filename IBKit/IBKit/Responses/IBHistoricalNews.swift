//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBHistoricalNews: IBResponse, IBIndexedEvent {
	
	public var requestID: Int
	
	public var date: Date
	
	public var providerCode: String
	
	public var articleId: String
	
	public var headline: String
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		date = try container.decode(Date.self)
		providerCode = try container.decode(String.self)
		articleId = try container.decode(String.self)
		headline = try container.decode(String.self)
	}
	
}


public struct IBHistoricalNewsEnd: IBResponse, IBIndexedEvent {
	
	public var requestID: Int
	
	public var hasMore: Bool
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		hasMore = try container.decode(Bool.self)
	}
	
}
