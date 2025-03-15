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


public struct IBExcecutionRequest: IBRequest, Hashable{
	
	public let version: Int = 3
	public let id: Int?
	public let type: IBRequestType = .executions
	public let clientID: Int?
	public let accountName: String?
	public let date: Date?
	public let symbol: String?
	public let secType: IBSecuritiesType?
	public let market: IBExchange?
	public let side: IBAction?
		
	/// when requesting executions, a filter can be specified to receive only a subset of them
	/// - Parameter clientID: The API client which placed the order.
	/// - Parameter account: The account to which the order was allocated to.
	/// - Parameter time: Time from which the executions will be returned yyyymmdd hh:mm:ss Only those executions reported after the specified time will be returned.
	/// - Parameter symbol: The instrument's symbol.
	/// - Parameter secuirityType: The Contract's security's type (i.e. STK, OPT...)
	/// - Parameter exchange: The exchange at which the execution was produce
	/// - Parameter side: The Contract's side (BUY or SELL)
		
	public init(
		id: Int,
		clientID: Int? = nil,
		accountName: String? = nil,
		date: Date? = nil,
		symbol: String? = nil,
		securityType type: IBSecuritiesType? = nil,
		market: IBExchange? = nil,
		side: IBAction? = nil
	) {
		self.id = id
		self.clientID = clientID
		self.accountName = accountName
		self.date = date
		self.symbol = symbol
		self.secType = type
		self.market = market
		self.side = side
	}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.executions)
		try container.encode(version)
		try container.encode(id)
		try container.encodeOptional(clientID)
		try container.encodeOptional(accountName)
		try container.encodeOptional(date)
		try container.encodeOptional(symbol)
		try container.encodeOptional(secType)
		try container.encodeOptional(market)
		try container.encodeOptional(side)

	}

	
}
