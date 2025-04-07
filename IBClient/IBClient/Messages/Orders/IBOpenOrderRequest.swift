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

public struct IBOpenOrderRequest: IBRequest, Hashable {

	public let version: Int
	public let type: IBRequestType
	public let autoBind: Bool
	
	public init(version:Int, type: IBRequestType, autoBind: Bool) {
		self.version = version
		self.type = type
		self.autoBind = autoBind
	}

	public static func all() -> IBOpenOrderRequest{
		return IBOpenOrderRequest(version: 1, type: .allOpenOrders, autoBind: false)
	}

	public static func autoBind(_ autoBind: Bool) -> IBOpenOrderRequest{
		return IBOpenOrderRequest(version: 1, type: .autoOpenOrders, autoBind: autoBind)
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

