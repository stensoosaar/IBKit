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


public struct IBMarketDepthExchangesRequest: IBRequest, Hashable{
	
	public var id: Int? = nil
	public var type: IBRequestType = .marketDepthExchanges
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
	}
	
}



public struct IBMarketDepthRequest: IBRequest {
	
	public let version = 5
	public let id: Int?
	public var type: IBRequestType = .marketDepth
	public let contract: IBContract
	public let rows: Int
	public let smart:Bool
	
	
	/// request contract's orderbook
	/// - Parameters:
	/// - requestID: unique request ID
	/// - contractID: contract
	/// - rows: depth of book
	/// - smart: whatever it is
	init(id: Int, contract: IBContract, rows: Int, smart: Bool) {
		self.id = id
		self.contract = contract
		self.rows = rows
		self.smart = smart
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBError.encodingError("Server value expected")
		}
		
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(rows)
		
		if serverVersion >= IBServerVersion.SMART_DEPTH {
			try container.encode(smart)
		}
		
		if serverVersion >= IBServerVersion.LINKING {
			try container.encode("")
		}
	
	}
	
}


public struct IBMarketDepthCancellation: IBRequest{
	
	public let version = 1
	public let id: Int?
	public var type: IBRequestType = .cancelMarketDepth

	public init(requestID: Int) {
		self.id = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
	
}
