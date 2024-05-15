//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBOrderStatus: IBResponse, IBIndexedEvent {
	
	public var requestID: Int
	public var status: IBOrder.Status
	public var filled: Double
	public var remaining: Double
	public var avgFillPrice: Double
	public var permID: Int
	public var parentID: Int
	public var lastFillPrice: Double
	public var clientID: Int
	public var whyHeld: String
	public var mktCapPrice: Double?
	
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
		
		if serverVersion >= IBServerVersion.MARKET_CAP_PRICE {
			mktCapPrice = try container.decode(Double.self)
		}
	}
	
	
}
