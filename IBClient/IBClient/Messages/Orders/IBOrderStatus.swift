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


public struct IBOrderStatus: IBEvent, Identifiable {
	
	public let id: Int
	public let status: IBOrder.Status
	public let filled: Double
	public let remaining: Double
	public let avgFillPrice: Double
	public let permID: Int
	public let parentID: Int
	public let lastFillPrice: Double
	public let clientID: Int
	public let whyHeld: String
	public let mktCapPrice: Double?
}

extension IBOrderStatus: IBDecodable { 
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("Server version not found.")
		}
		
		var container = try decoder.unkeyedContainer()
		
		if serverVersion < IBServerVersion.MARKET_CAP_PRICE {
			_ = try container.decode(Int.self)
		}
		
		id = try container.decode(Int.self)
		status = try container.decode(IBOrder.Status.self)
		filled = try container.decode(Double.self)
		remaining = try container.decode(Double.self)
		avgFillPrice = try container.decode(Double.self)
		permID = try container.decode(Int.self)
		parentID = try container.decode(Int.self)
		lastFillPrice = try container.decode(Double.self)
		clientID = try container.decode(Int.self)
		whyHeld = try container.decode(String.self)
		
		if serverVersion >= IBServerVersion.MARKET_CAP_PRICE {
			mktCapPrice = try container.decode(Double.self)
		} else {
			mktCapPrice = nil
		}
	}
	
	
}
