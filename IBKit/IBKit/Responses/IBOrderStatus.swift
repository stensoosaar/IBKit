//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBOrderStatus: IBResponse, IBIndexedEvent, Sendable {
	
	public let requestID: Int
	public let status: IBOrder.Status
	public let filled: Double
	public let remaining: Double
	public let avgFillPrice: Double
	public let permID: Int
	public let parentID: Int
	public let lastFillPrice: Double
	public let clientID: Int
	public let whyHeld: String
	public let mktCapPrice: Double?
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBClientError.decodingError("Server version not found.")
		}
		
		var container = try decoder.unkeyedContainer()
		
		if serverVersion < IBServerVersion.MARKET_CAP_PRICE {
			_ = try container.decode(Int.self)
		}
		
		requestID = try container.decode(Int.self)
		status = try container.decode(IBOrder.Status.self)
		filled = try container.decode(Double.self)
		remaining = try container.decode(Double.self)
		avgFillPrice = try container.decode(Double.self)
		permID = try container.decode(Int.self)
		parentID = try container.decode(Int.self)
		lastFillPrice = try container.decode(Double.self)
		clientID = try container.decode(Int.self)
		whyHeld = try container.decode(String.self)
		mktCapPrice = serverVersion >= IBServerVersion.MARKET_CAP_PRICE ? try container.decode(Double.self) : nil
	}
	
	
}
