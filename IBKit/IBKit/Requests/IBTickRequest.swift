//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBTickRequest: IBIndexedRequest {
	
	public enum TickType: String, Codable {
		case last 			= "Last"
		case allLast 		= "AllLast"
		case BidAsk			= "BidAsk"
		case midPoint		= "MidPoint"
	}
	
	public let version: Int = 3
	public let requestID: Int
	public var type: IBRequestType = .tickByTickData
	public var contract: IBContract
	public var tickType: TickType
	public var count: Int
	public var ignoreSize: Bool
	
	public init(requestID: Int, contract: IBContract, type: TickType, count: Int, ignoreSize: Bool = true) {
		self.requestID = requestID
		self.contract = contract
		self.tickType = type
		self.count = count
		self.ignoreSize = ignoreSize
	}

	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBClientError.encodingError("Server value expected")
		}

		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(requestID)
		try container.encode(contract)
		try container.encode(tickType)
	 
		if serverVersion >= IBServerVersion.TICK_BY_TICK_IGNORE_SIZE{
			try container.encode(count)
			try container.encode(ignoreSize)
		}
		
	}

}


public struct IBTickCancellationRequest: IBIndexedRequest {
	
	public let version: Int = 3
	public let requestID: Int
	public var type: IBRequestType = .cancelTickByTickData
	
	public init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(requestID)
	}

}
