//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBHistoricalNews: IBResponse, IBIndexedEvent, Sendable {
	
	public let requestID: Int
	
	public let date: Date
	
	public let providerCode: String
	
	public let articleId: String
	
	public let headline: String
	
	public init(from decoder: IBDecoder) throws {
        decoder.dateDecodingStrategy = .historicalNewsFormat
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		date = try container.decode(Date.self)
		providerCode = try container.decode(String.self)
		articleId = try container.decode(String.self)
		headline = try container.decode(String.self)
	}
	
}


public struct IBHistoricalNewsEnd: IBResponse, IBIndexedEvent, Sendable {
	
	public let requestID: Int
	
	public let hasMore: Bool
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		requestID = try container.decode(Int.self)
		hasMore = try container.decode(Bool.self)
	}
	
}
