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


public struct IBHeadTimestampRequest: IBRequest, Identifiable, IBCancellableRequest {
	
	public let id: Int
	public let type: IBRequestType = .headTimestamp
	public let contract: IBContract
	public let source: IBBarSource
	public let extendedSession: Bool
	
	/// Requests first datapoint date for specific dataset
	/// - Parameter requestID: request ID
	/// - Parameter contract: contract description
	/// - Parameter source: data type to build a bar
	/// - Parameter extendedSession: use only data from regular trading hours
	/// - Returns: IBFirstDatapoint event
	public init(id: Int, contract: IBContract, source: IBBarSource, extendedSession: Bool = false) {
		self.id = id
		self.contract = contract
		self.source = source
		self.extendedSession = extendedSession
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(contract.isExpired)
		try container.encode(extendedSession.reverseValue())
		try container.encode(source)
		try container.encode(1)
	}
	
	public var cancel: any IBRequest{
		return IBHeadTimestampCancellation(id: id)
	}
	
}



public struct IBHeadTimestampCancellation: IBRequest, Identifiable {
	
	public var id: Int
	public var type: IBRequestType = .cancelHeadTimestamp
	
	init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}
}



