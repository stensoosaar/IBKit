//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation



public struct IBPlaceOrderRequest: IBIndexedRequest{
	
	public var type: IBRequestType = .placeOrder
	public var requestID: Int
	public var order: IBOrder
	
	public init(requestID: Int, order: IBOrder) {
		self.requestID = requestID
		self.order = order
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBClientError.encodingError("Server value expected")
		}

		let version: Int = (serverVersion < IBServerVersion.NOT_HELD) ? 27 : 45
		
		var container = encoder.unkeyedContainer()
		
		try container.encode(type)

		if serverVersion < IBServerVersion.ORDER_CONTAINER{
			try container.encode(version)
		}
		
		try container.encode(requestID)
		
		try container.encode(order)
		
	}
	
}


