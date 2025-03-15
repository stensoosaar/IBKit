//
//  IBClient.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

import Foundation



public struct IBNextIDRequest: IBRequest{

	let version: Int = 1
	public let type: IBRequestType = .nextId
	public var id: Int? = nil

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
	public var id: Int? = nil

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
	public var id: Int? = nil

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
	public var id: Int? = nil

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
	public var id: Int? = nil

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
	public var id: Int? = nil

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
	public var id: Int? = nil

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
	public var id: Int? = nil

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
	public var id: Int? = nil

	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
	
}
