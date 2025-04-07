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

/// Receives PnL updates in real time for the daily PnL and the total unrealized PnL for an account
public struct IBAccountPNL: IBEvent {
	
	/// dailyPnL updates for the account in real time
	public var daily: Double
	
	/// total unrealized PnL updates for the account in real time
	public var unrealized: Double
	
	/// total realized PnL updates for the account in real time
	public var realized: Double
	
}


extension IBAccountPNL: Decodable {
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.daily = try container.decode(Double.self)
		self.unrealized = try container.decode(Double.self)
		self.realized = try container.decode(Double.self)
	}	
}


extension IBResponseWrapper where T == IBAccountPNL {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}
