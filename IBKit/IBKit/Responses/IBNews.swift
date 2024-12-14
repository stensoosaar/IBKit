//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBNews: IBResponse, IBEvent, Sendable {
	
	public let tickerID: Int
	public let date: Date
	public let providerCode: String
	public let articleId: String
	public let headline: String
	public let extraData: String

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.tickerID = try container.decode(Int.self)
		self.date = try container.decode(Date.self)
		self.providerCode = try container.decode(String.self)
		self.articleId = try container.decode(String.self)
		self.headline = try container.decode(String.self)
		self.extraData = try container.decode(String.self)
	}
	
}

