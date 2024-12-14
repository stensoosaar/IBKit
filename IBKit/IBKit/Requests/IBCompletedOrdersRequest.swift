//
//  File.swift
//  
//
//  Created by Sten Soosaar on 23.04.2024.
//

import Foundation



public struct IBCompletedOrdersRequest: IBRequest, Hashable {
	public var type: IBRequestType = .completedOrders
	public var apiOnly: Bool

	public init(apiOnly: Bool){
		self.apiOnly = apiOnly
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(apiOnly)

	}
	
}
