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



public struct IBOrderRequest: Identifiable, IBCancellableRequest, Hashable {
		
	public let id: Int
	public let type: IBRequestType = .placeOrder
	public let order: IBOrder
	public let cancellationDate: Date? = nil
	
	public init(id: Int, order: IBOrder) {
		self.id = id
		self.order = order
	}
	
	public var cancel: any IBRequest{
		return IBCancelOrderRequest(id: id, date: cancellationDate)
	}

	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBError.encodingError("Server value expected")
		}

		let version: Int = (serverVersion < IBServerVersion.NOT_HELD) ? 27 : 45
		
		var container = encoder.unkeyedContainer()
		
		try container.encode(type)

		if serverVersion < IBServerVersion.ORDER_CONTAINER{
			try container.encode(version)
		}
		
		try container.encode(id)
		
		try container.encode(order)
		
	}
	
}




struct IBCancelOrderRequest: IBRequest, Identifiable, Hashable {
	
	let id: Int
	let type: IBRequestType = .cancelOrder
	let version: Int = 1
	let cancelTime: Date?
	
	init(id: Int, date: Date? = nil){
		self.id = id
		self.cancelTime = date
	}
	
	 func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBError.encodingError("Server value expected")
		}

		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		
		if serverVersion >= IBServerVersion.MANUAL_ORDER_TIME {
			try container.encodeOptional(cancelTime)
		}
		
	}
	
}

