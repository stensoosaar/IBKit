//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBRealTimeBarRequest: IBIndexedRequest, Hashable, Equatable {
	
	public let version: Int = 3
	public let requestID: Int
	public var type: IBRequestType = .realTimeBars
	public var contract: IBContract
	public var size: IBBarSize = .fiveSeconds
	public var source: IBBarSource
	public var extendedTrading: Bool
	
	public init(requestID: Int, contract: IBContract, source: IBBarSource, extendedTrading: Bool) {
		self.requestID = requestID
		self.contract = contract
		self.source = source
		self.extendedTrading = extendedTrading
	}
	
	
	public func encode(to encoder: IBEncoder) throws {		
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(contract)
		try container.encode(5)
		try container.encode(source)
		try container.encode(extendedTrading.reverseValue())
		try container.encode("")
	}
	
}



public struct IBRealTimeBarCancellationRequest: IBIndexedRequest{

	public var type: IBRequestType = .realTimeBars
	public let requestID: Int

	init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelRealTimeBars)
		try container.encode(requestID)
	}
	
}
