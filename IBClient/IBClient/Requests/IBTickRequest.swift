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


public struct IBTickRequest: IBRequest {
	
	public enum TickType: String, Codable {
		case last 			= "Last"
		case allLast 		= "AllLast"
		case BidAsk			= "BidAsk"
		case midPoint		= "MidPoint"
	}
	
	public let version: Int = 3
	public let id: Int?
	public var type: IBRequestType = .tickByTickData
	public var contract: IBContract
	public var tickType: TickType
	public var count: Int
	public var ignoreSize: Bool
	
	public init(id: Int, contract: IBContract, type: TickType, count: Int, ignoreSize: Bool = true) {
		self.id = id
		self.contract = contract
		self.tickType = type
		self.count = count
		self.ignoreSize = ignoreSize
	}

	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBError.encodingError("Server value expected")
		}

		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(tickType)
	 
		if serverVersion >= IBServerVersion.TICK_BY_TICK_IGNORE_SIZE{
			try container.encode(count)
			try container.encode(ignoreSize)
		}
		
	}

}


public struct IBTickCancellationRequest: IBRequest {
	
	public let version: Int = 3
	public let id: Int?
	public var type: IBRequestType = .cancelTickByTickData
	
	public init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}

}
