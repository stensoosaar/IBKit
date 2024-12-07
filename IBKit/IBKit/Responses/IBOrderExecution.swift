//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBOrderExecution: IBResponse,IBIndexedEvent {
	
	public var requestID: Int
	
	public var orderID: Int

	public var contract: IBContract
	
	public var executionId: String
	
	public var time: Date
	
	public var account: String
	
	public var exchange: String

	public var side: String
	
	public var shares: Double
	
	public var price: Double
	
	public var permID: Int
	
	public var clientID: Int
	
	public var liquidation: Int
	
	public var totalQuantity: Double
	
	public var priceAverage: Double
	
	public var orderReference: String?
	
	public var evRule: String?
	
	public var evMultiplier: Double?
	
	public var modelCode: String?
	
	public enum LiquidityType: Int, Decodable {
		case none 				= 0
		case added 				= 1
		case removed 			= 2
		case roudedOut 			= 3
	}
	
	public var lastLiquidity: LiquidityType?
	
	
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBClientError.decodingError("Server version not found.")
		}
		
		var container = try decoder.unkeyedContainer()
		let version = serverVersion < IBServerVersion.LAST_LIQUIDITY ? try container.decode(Int.self) : serverVersion
		
		self.requestID = (version >= 7) ? try container.decode(Int.self) : -1
		self.orderID = try container.decode(Int.self)
		self.contract = try container.decode(IBContract.self)
		self.executionId = try container.decode(String.self)
		self.time = try container.decode(Date.self)
		self.account = try container.decode(String.self)
		self.exchange = try container.decode(String.self)
		self.side = try container.decode(String.self)
		self.shares = try container.decode(Double.self)
		self.price = try container.decode(Double.self)
		self.permID = try container.decode(Int.self)
		self.clientID = try container.decode(Int.self)
		self.liquidation = try container.decode(Int.self)
		self.totalQuantity = try container.decode(Double.self)
		self.priceAverage = try container.decode(Double.self)
		
		if version >= 8 {
			self.orderReference = try container.decodeOptional(String.self)
		}
		if version >= 9 {
			self.evRule = try container.decode(String.self)
			self.evMultiplier = try container.decodeOptional(Double.self)
		}
		if serverVersion >= IBServerVersion.MODELS_SUPPORT {
			self.modelCode = try container.decodeOptional(String.self)
		}
		if serverVersion >= IBServerVersion.LAST_LIQUIDITY {
			self.lastLiquidity = try container.decodeOptional(LiquidityType.self)
		}

	}
}


public struct IBOrderExecutionEnd: IBResponse, IBIndexedEvent {
	
	public var requestID: Int
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
	}
	
}
