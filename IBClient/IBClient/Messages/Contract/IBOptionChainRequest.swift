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



public struct IBOptionChainRequest: IBRequest, Identifiable, Hashable {
	
	public let id: Int
	public let type: IBRequestType = .optionParameters
	public let underlying: IBContract
	public let exchange: IBExchange?
	
	
	/// Requests security definition option parameters for viewing a contract's option chain.
	/// - Parameter index: request index
	/// - Parameter underlying: underlying contract. symbol, type and contractID are required
	/// - Parameter exchange: exhange where options are traded. leaving empty will return all exchanges.
	public init(id: Int, underlying: IBContract, exchange: IBExchange?=nil) {
		self.id = id
		self.underlying = underlying
		self.exchange = exchange
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.optionParameters)
		try container.encode(type)
		try container.encode(underlying.symbol)
		try container.encodeOptional(exchange)
		try container.encode(underlying.securitiesType)
		try container.encodeOptional(underlying.id)
	}
	
	
}
