//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBCancelOrderRequest: IBIndexedRequest, Hashable {
	
	public let version: Int = 1
	public let type: IBRequestType = .cancelOrder
	public let requestID: Int
	public let cancelTime: Date?
	
	public init(requestID:Int, date: Date? = nil){
		self.requestID = requestID
		self.cancelTime = date
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBClientError.encodingError("Server value expected")
		}

		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
		
		if serverVersion >= IBServerVersion.MANUAL_ORDER_TIME {
			try container.encodeOptional(cancelTime)
		}
		
	}
	
}
