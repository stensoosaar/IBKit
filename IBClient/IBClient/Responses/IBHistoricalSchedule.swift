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


public struct IBHistoricalSchedule: IBEvent{
	
	public struct Session: Sendable{
		public let start: String
		public let end : String
		public let ref: String
	}
	
	public var requestID: Int
	public var interval: DateInterval
	public var timeZoneID: String
	public var sessions: [Session] = []
	
}

extension IBHistoricalSchedule: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
		let start = try container.decode(Date.self)
		let end = try container.decode(Date.self)
		self.interval = DateInterval(start: start, end: end)
		self.timeZoneID = try container.decode(String.self)
		let count = try container.decode(Int.self)
		for _ in 0..<count {
			let sessionStart = try container.decode(String.self)
			let sessionEnd = try container.decode(String.self)
			let referenceDate = try container.decode(String.self)
			sessions.append(
				Session(start: sessionStart, end: sessionEnd, ref: referenceDate)
			)
			
		}
	}
}
