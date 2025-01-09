//
//  File.swift
//  
//
//  Created by Sten Soosaar on 23.04.2024.
//

import Foundation

public struct IBOpenOrderRequest: IBRequest, Hashable {
	
	public var version: Int
	public var type: IBRequestType
	public var autoBind: Bool
		
	public init(){
		version = 1
		type = .openOrders
		autoBind = false
	}
	
	private init(version:Int, type: IBRequestType, autoBind: Bool) {
		self.version = version
		self.type = type
		self.autoBind = autoBind
	}

	public static func all() -> IBOpenOrderRequest{
		return IBOpenOrderRequest(version: 1, type: .allOpenOrders, autoBind: false)
	}

	public static func autoBind(_ autoBind: Bool) -> IBOpenOrderRequest{
		return IBOpenOrderRequest(version: 1, type: .allOpenOrders, autoBind: autoBind)
	}

	
	public func encode(to encoder: IBEncoder) throws {
		
		var container = encoder.unkeyedContainer()

		switch type{
		case .allOpenOrders, .openOrders:
			try container.encode(type)
			try container.encode(version)
		case .autoOpenOrders:
			try container.encode(type)
			try container.encode(version)
			try container.encode(autoBind)
		default:
			break
		}
	
	}
	
}

