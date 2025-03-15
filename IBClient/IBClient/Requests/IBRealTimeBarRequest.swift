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


public struct IBRealTimeBarRequest: IBRequest{
	
	public let version: Int = 3
	public let id: Int?
	public var type: IBRequestType = .realTimeBars
	public var contract: IBContract
	public var size: IBBarSize = .fiveSeconds
	public var source: IBBarSource
	public var extendedTrading: Bool
	
	public init(id: Int, contract: IBContract, source: IBBarSource, extendedTrading: Bool) {
		self.id = id
		self.contract = contract
		self.source = source
		self.extendedTrading = extendedTrading
	}
	
	
	public func encode(to encoder: IBEncoder) throws {		
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(5)
		try container.encode(source)
		try container.encode(extendedTrading)
		try container.encode("")
	}
	
}



public struct IBRealTimeBarCancellationRequest: IBRequest{

	public var type: IBRequestType = .realTimeBars
	public let id: Int?

	init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelRealTimeBars)
		try container.encode(id)
	}
	
}
