//
//  File.swift
//  
//
//  Created by Sten Soosaar on 07.05.2024.
//

import Foundation


public protocol IBAnyMarketDepth: IBResponse, IBIndexedEvent{
	
	var requestID: Int 	{ get }
	var position: Int	{ get }
	var operation: Int	{ get }
	var side: Int		{ get }
	var price: Double	{ get }
	var size: Double	{ get }

}


public struct IBMarketDepth: IBAnyMarketDepth{
	
	public let requestID: Int
	public let position: Int
	public let operation: Int
	public let side: Int
	public let price: Double
	public let size: Double
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.position = try container.decode(Int.self)
		self.operation = try container.decode(Int.self)
		self.side = try container.decode(Int.self)
		self.price = try container.decode(Double.self)
		self.size = try container.decode(Double.self)
	}
	
	
}




public struct IBMarketDepthLevel2: IBAnyMarketDepth{
	
	public let requestID: Int
	public let position: Int
	public let marketMaker: String
	public let operation: Int
	public let side: Int
	public let price: Double
	public let size: Double
	public let isSmart: Bool
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBClientError.decodingError("server version missing")
		}
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.position = try container.decode(Int.self)
		self.marketMaker = try container.decode(String.self)
		self.operation = try container.decode(Int.self)
		self.side = try container.decode(Int.self)
		self.price = try container.decode(Double.self)
		self.size = try container.decode(Double.self)
		self.isSmart = serverVersion >= IBServerVersion.SMART_DEPTH ? try container.decode(Bool.self) : false
	}
	
	
}
