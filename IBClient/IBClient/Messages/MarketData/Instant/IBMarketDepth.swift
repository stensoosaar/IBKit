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


public enum IBOperation:Int, Decodable, Sendable {
	case insert = 0
	case update = 1
	case remove = 2
}


public struct IBMarketDepth: IBEvent{
	
	/// the order book's row being updated
	public let position: Int
	
	/// how to refresh
	public let operation: IBOperation
	
	/// Bid or Ask
	public let quote: TickQuote
	
}

extension IBMarketDepth: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.position = try container.decode(Int.self)
		self.operation = try container.decode(IBOperation.self)
		let sideRawValue = try container.decode(Int.self)
		let side = sideRawValue == 0 ? IBTickType.Ask : IBTickType.Bid
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		let date = Date()
		self.quote = TickQuote(type: side, price: price, size: size, date: date, attributes: [])
	}

}


extension IBResponseWrapper where T == IBMarketDepth {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}





public struct IBMarketDepthL2: IBEvent{
	
	/// the order book's row being updated
	public let position: Int
	
	/// how to refresh
	public let operation: IBOperation
	
	public let quote: TickQuote

	/// the exchange holding the order if isSmartDepth is True, otherwise the MPID of the market maker
	public let marketMaker: String

	/// flag indicating if this is smart depth response
	public let isSmart: Bool
	
}

extension IBMarketDepthL2: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("server version missing")
		}
		
		var container = try decoder.unkeyedContainer()
		self.position = try container.decode(Int.self)
		self.marketMaker = try container.decode(String.self)
		self.operation = try container.decode(IBOperation.self)
		let sideRawValue = try container.decode(Int.self)
		let side = sideRawValue == 0 ? IBTickType.Ask : IBTickType.Bid
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		let date = Date()
		self.quote = TickQuote(type: side, price: price, size: size, date: date, attributes: [])
		self.isSmart = serverVersion >= IBServerVersion.SMART_DEPTH ? try container.decode(Bool.self) : false
	}
	
}


extension IBResponseWrapper where T == IBMarketDepthL2 {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}
