//
//  IBClient.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
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


public struct IBWSHEventData: IBEvent {
	
	public let contractID: Int
	public let filter: String
	public let fillWatchlist: Bool
	public let fillPortfolio: Bool
	public let fillCompetitors: Bool
	public let startDate: Date
	public let endDate: Date
	public let totalLimit: Int
	
}

extension IBWSHEventData: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.contractID = try container.decode(Int.self)
		self.filter = try container.decode(String.self)
		self.fillWatchlist = try container.decode(Bool.self)
		self.fillPortfolio = try container.decode(Bool.self)
		self.fillCompetitors = try container.decode(Bool.self)
		self.startDate = try container.decode(Date.self)
		self.endDate = try container.decode(Date.self)
		self.totalLimit = try container.decode(Int.self)
	}
	
}

