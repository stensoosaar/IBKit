//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation



public struct IBOptionChainRequest: IBIndexedRequest {
	
	public var type: IBRequestType = .optionParameters
	public var requestID: Int
	public var underlying: IBContract
	public var exchange: IBExchange?
	
	
	/// Requests security definition option parameters for viewing a contract's option chain.
	/// - Parameter index: request index
	/// - Parameter underlying: underlying contract. symbol, type and contractID are required
	/// - Parameter exchange: exhange where options are traded. leaving empty will return all exchanges.

	public init(requestID: Int, underlying: IBContract, exchange: IBExchange?=nil) {
		self.requestID = requestID
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
