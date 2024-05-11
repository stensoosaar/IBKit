//
//  File.swift
//  
//
//  Created by Sten Soosaar on 22.04.2024.
//

import Foundation



public struct IBNextIDRquest: IBRequest{
	
	let version: Int = 1
	public let type: IBRequestType = .nextId
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode("")
	}
	
}


public struct IBServerTimeRequest: IBRequest{
	
	let version: Int = 1
	public let type: IBRequestType = .serverTime
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
	
}


public struct IBBulletinBoardRequest: IBRequest{
	
	let version: Int = 1
	public let type: IBRequestType = .newsBulletins
	public var includePast: Bool
	
	public init(includePast: Bool = false){
		self.includePast = includePast
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(includePast)
	}
	
}


public struct IBBulletinBoardCancellationRequest: IBRequest{
	
	let version: Int = 1
	public let type: IBRequestType = .cancelNewsBulletins
	
	public init(){}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
	
}


public struct IBMarketDataTypeRequest: IBRequest{
	
	let version = 1
	public let type: IBRequestType = .marketDataType
	public let dataType: IBMarketDataType
	
	public init (_ dataType: IBMarketDataType ) {
		self.dataType = dataType
	}

	public func encode(to encoder: IBEncoder) throws {
		let version: Int = 1
		var container = encoder.unkeyedContainer()
		try container.encode(dataType)
		try container.encode(version)
	}
	
}


public struct IBGlobalCancelRequest: IBRequest{
	
	let version = 1
	public let type: IBRequestType = .globalCancel
	
	public init() {}

	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
	
}


public struct IBPositionRequest: IBRequest {
	
	public var version: Int = 1
	public var type: IBRequestType = .positions
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
	
}

public struct IBPositionCancellationRequest: IBRequest {
	
	public var version: Int = 1
	public var type: IBRequestType = .cancelPositions
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelPositions)
		try container.encode(version)
	}
	
}


public struct IBScannerParametersRequest: IBRequest {
	
	public var version: Int = 1
	public var type: IBRequestType = .scannerParameters
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
	
}
