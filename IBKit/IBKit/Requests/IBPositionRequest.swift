//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation





public struct IBMultiPositionRequest: IBIndexedRequest {
	
	public var version: Int = 1
	public var type: IBRequestType = .positionsMulti
	public var requestID: Int
	public var accountName: String
	public var model: String?
	
	public init(requestID:Int, accountName: String, model: String? = nil){
		self.requestID = requestID
		self.accountName = accountName
		self.model = model
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.positionsMulti)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(accountName)
		try container.encodeOptional(model)
	}
}



public struct IBMultiPositionCancellationRequest: IBIndexedRequest {
	
	public var version: Int = 1
	public var type: IBRequestType = .cancelPositionsMulti
	public var requestID: Int
	
	public init(requestID: Int){
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelPositionsMulti)
		try container.encode(version)
		try container.encode(requestID)

	}
}
