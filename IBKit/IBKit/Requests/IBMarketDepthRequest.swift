//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBMarketDepthExchanges: IBRequest, Hashable{
	
	public var type: IBRequestType = .marketDepthExchanges
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
	}
	
}



public struct IBMarketDepthRequest: IBIndexedRequest {
	
	public let version = 5
	public let requestID: Int
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
	init(requestID: Int, contract: IBContract, rows: Int, smart: Bool) {
		self.requestID = requestID
		self.contract = contract
		self.rows = rows
		self.smart = smart
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBClientError.encodingError("Server value expected")
		}
		
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
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


public struct IBMarketDepthCancellation: IBIndexedRequest{
	
	public let version = 1
	public let requestID: Int
	public var type: IBRequestType = .cancelMarketDepth

	public init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
	}
	
}
