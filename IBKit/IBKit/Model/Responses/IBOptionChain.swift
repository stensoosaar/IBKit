//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBOptionChain: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	public var exchange: String
	public var underlyingContractId: Int
	public var tradingClass : String
	public var multiplier: String
	public var expirations: [Date] = []
	public var strikes: [Double] = []

	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		
		requestID = try container.decode(Int.self)
		exchange = try container.decode(String.self)
		underlyingContractId = try container.decode(Int.self)
		tradingClass = try container.decode(String.self)
		multiplier = try container.decode(String.self)
		
		let expCount = try container.decode(Int.self)
		
		if let decoder = decoder as? IBDecoder{
			decoder.dateFormatter.dateFormat = "yyyyMMdd"
		}
		
		for _ in 0..<expCount{
			let expiration = try container.decode(Date.self)
			expirations.append(expiration)
		}

		let strikeCount = try container.decode(Int.self)
		for _ in 0..<strikeCount{
			let strike = try container.decode(Double.self)
			strikes.append(strike)
		}

	}

}


public struct IBOptionChainEnd: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.requestID = try container.decode(Int.self)
	}

}
