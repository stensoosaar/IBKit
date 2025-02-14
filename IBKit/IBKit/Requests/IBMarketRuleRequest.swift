//
//  File.swift
//  
//
//  Created by Sten Soosaar on 23.04.2024.
//

import Foundation




public struct IBMarketRuleRequest: IBRequest, Hashable {

	public var type: IBRequestType = .marketRule
	public var marketRuleID: Int

	public init(marketRuleID: Int){
		self.marketRuleID = marketRuleID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(marketRuleID)
	}
	
}
