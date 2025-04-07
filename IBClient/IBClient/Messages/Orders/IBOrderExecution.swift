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



public struct IBOrderExecution: IBEvent {
	fileprivate let id: Int
	public let orderID: Int
	public let contract: IBContract
	public let executionId: String
	public let time: Date
	public let account: String
	public let exchange: String
	public let side: String
	public let shares: Double
	public let price: Double
	public let permID: Int
	public let clientID: Int
	public let liquidation: Int
	public let totalQuantity: Double
	public var priceAverage: Double
	public var orderReference: String?
	public var evRule: String?
	public var evMultiplier: Double?
	public var modelCode: String?
	
	public enum LiquidityType: Int, Decodable, Sendable {
		case none 				= 0
		case added 				= 1
		case removed 			= 2
		case roudedOut 			= 3
	}
	
	public var lastLiquidity: LiquidityType?
	
}

extension IBOrderExecution: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {

		var container = try decoder.unkeyedContainer()
		let version = decoder.serverVersion < IBServerVersion.LAST_LIQUIDITY ? try container.decode(Int.self) : decoder.serverVersion
		
		self.id = (version >= 7) ? try container.decode(Int.self) : -1
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
		if decoder.serverVersion >= IBServerVersion.MODELS_SUPPORT {
			self.modelCode = try container.decodeOptional(String.self)
		}
		if decoder.serverVersion >= IBServerVersion.LAST_LIQUIDITY {
			self.lastLiquidity = try container.decodeOptional(LiquidityType.self)
		}

	}
}


extension IBResponseWrapper where T == IBOrderExecution {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.result = try container.decode(T.self)
		self.id = result.id
	}
}




public struct IBOrderExecutionEnd: IBEvent, Identifiable {
	public let id: Int
}


extension IBOrderExecutionEnd: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
	}
	
}
