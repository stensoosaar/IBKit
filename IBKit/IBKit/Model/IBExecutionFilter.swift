//
//  IBExecutionFilter.swift
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


public struct IBExecutionFilter {
	
	public var client:Int?
	
	public var account:String?
	
	public var time:String?
	
	public var symbol:String?
	
	public var secType: IBSecuritiesType?
	
	public var market:String?
	
	public var side:String?
	
	/// when requesting executions, a filter can be specified to receive only a subset of them
	/// - Parameter client: The API client which placed the order.
	/// - Parameter account: The account to which the order was allocated to.
	/// - Parameter time: Time from which the executions will be returned yyyymmdd hh:mm:ss Only those executions reported after the specified time will be returned.
	/// - Parameter symbol: The instrument's symbol.
	/// - Parameter secuirityType: The Contract's security's type (i.e. STK, OPT...)
	/// - Parameter exchange: The exchange at which the execution was produce
	/// - Parameter side: The Contract's side (BUY or SELL)
	
	public init(client:Int? = nil, account:String? = nil, time:String? = nil, symbol:String? = nil, securityType type:IBSecuritiesType? = nil, market:String? = nil, side:String? = nil) {
		self.client = client
		self.account = account
		self.time = time
		self.symbol = symbol
		self.secType = type
		self.market = market
		self.side = side
	}
	
}

extension IBExecutionFilter: Codable {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.client = try container.decodeOptional(Int.self)
		self.account = try container.decodeOptional(String.self)
		self.time = try container.decodeOptional(String.self)
		self.symbol = try container.decodeOptional(String.self)
		self.secType = try container.decodeOptional(IBSecuritiesType.self)
		self.market = try container.decodeOptional(String.self)
		self.side = try container.decodeOptional(String.self)
	}
	
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encodeOptional(client)
		try container.encodeOptional(account)
		try container.encodeOptional(time)
		try container.encodeOptional(symbol)
		try container.encodeOptional(secType)
		try container.encodeOptional(market)
		try container.encodeOptional(side)
	}
	
	
}




extension IBExecutionFilter: Equatable {

	static public func == (lhs: IBExecutionFilter, rhs: IBExecutionFilter) -> Bool {
		if lhs.client != rhs.client {return false}
		if lhs.account != rhs.account {return false}
		if lhs.time != rhs.time {return false}
		if lhs.symbol != rhs.symbol {return false}
		if lhs.secType != rhs.secType {return false}
		if lhs.market != rhs.market {return false}
		if lhs.side != rhs.side {return false}
		return true
	}
	
}
