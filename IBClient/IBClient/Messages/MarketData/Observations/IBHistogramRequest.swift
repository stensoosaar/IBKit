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

public struct IBHistogramRequest: IBRequest, Identifiable, IBCancellableRequest {
	
	public let id: Int
	public let type = IBRequestType.histogramData
	public let contract: IBContract
	public let extendedSession: Bool
	public let interval: DateInterval
	
	public init(id: Int, contract: IBContract, interval: DateInterval, extendedSession: Bool){
		self.id = id
		self.contract = contract
		self.extendedSession = extendedSession
		self.interval = interval
	}
	
	public var cancel: any IBRequest{
		return IBHistogramCancellation(id: id)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(contract)
		try container.encode(contract.isExpired)
		try container.encode(extendedSession.reverseValue())
		try container.encode(interval.twsDescription)
	}
	
}

public struct IBHistogramCancellation: IBRequest, Identifiable {

	public let id: Int
	public let type = IBRequestType.cancelHistogramData
	
	public init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}
}
