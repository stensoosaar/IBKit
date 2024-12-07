//
//  File.swift
//  
//
//  Created by Sten Soosaar on 23.04.2024.
//

import Foundation




public struct IBMarketRuleRequest: IBIndexedRequest {

	public var type: IBRequestType = .marketRule
	public var requestID: Int

	public init(requestID: Int){
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(requestID)
	}
	
}
