//
//  NewsEvents.swift
//	IBKit
//  
//	Copyright (c) 2016-2023 Sten Soosaar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

import Foundation


public struct NewsProviders: Decodable {
	
	public var values: [String:String] = [:]
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let count = try container.decode(Int.self)
		for _ in 0..<count {
			let code = try container.decode(String.self)
			let name = try container.decode(String.self)
			values[code] = name
		}
	}
	
}


public struct News: Decodable {
	
	public var tickerId: Int
	
	public var date: Date
	
	public var providerCode: String
	
	public var articleId: String
	
	public var headline: String
	
	public var extraData: String

	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.tickerId = try container.decode(Int.self)
		self.date = try container.decode(Date.self)
		self.providerCode = try container.decode(String.self)
		self.articleId = try container.decode(String.self)
		self.headline = try container.decode(String.self)
		self.extraData = try container.decode(String.self)
	}
	
}


public struct NewsArticle: Decodable {
	
	public var reqId: Int
	
	public var articleType: Int
	
	public var articleText: String
		
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		reqId = try container.decode(Int.self)
		articleType = try container.decode(Int.self)
		articleText = try container.decode(String.self)
	}
}


public struct HistoricalNews: Decodable {
	
	public var reqId: Int
	
	public var date: Date
	
	public var providerCode: String
	
	public var articleId: String
	
	public var headline: String
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		reqId = try container.decode(Int.self)
		date = try container.decode(Date.self)
		providerCode = try container.decode(String.self)
		articleId = try container.decode(String.self)
		headline = try container.decode(String.self)
	}
	
}


public struct HistoricalNewsEnd: Decodable {
	
	public var reqId: Int
	
	public var hasMore: Bool
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		reqId = try container.decode(Int.self)
		hasMore = try container.decode(Bool.self)
	}
	
}


public struct NewsBulletin: Decodable {
	
	public var messageID: Int
	public var messageType: Int
	public var message: String
	public var source: String
	
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		messageID = try container.decode(Int.self)
		messageType = try container.decode(Int.self)
		message = try container.decode(String.self)
		source = try container.decode(String.self)
	}
	
}
