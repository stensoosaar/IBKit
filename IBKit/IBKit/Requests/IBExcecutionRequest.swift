//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBExcecutionRequest: IBIndexedRequest{
	
	public let version: Int = 3
	public let requestID: Int
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
		requestID: Int,
		clientID: Int? = nil,
		accountName: String? = nil,
		date: Date? = nil,
		symbol: String? = nil,
		securityType type: IBSecuritiesType? = nil,
		market: IBExchange? = nil,
		side: IBAction? = nil
	) {
		self.requestID = requestID
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
		try container.encode(requestID)
		try container.encodeOptional(clientID)
		try container.encodeOptional(accountName)
		try container.encodeOptional(date)
		try container.encodeOptional(symbol)
		try container.encodeOptional(secType)
		try container.encodeOptional(market)
		try container.encodeOptional(side)

	}

	
}
