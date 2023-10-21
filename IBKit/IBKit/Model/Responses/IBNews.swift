//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBNews: Decodable, IBEvent {
	
	public var tickerID: Int
	
	public var date: Date
	
	public var providerCode: String
	
	public var articleId: String
	
	public var headline: String
	
	public var extraData: String

	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.tickerID = try container.decode(Int.self)
		self.date = try container.decode(Date.self)
		self.providerCode = try container.decode(String.self)
		self.articleId = try container.decode(String.self)
		self.headline = try container.decode(String.self)
		self.extraData = try container.decode(String.self)
	}
	
}

