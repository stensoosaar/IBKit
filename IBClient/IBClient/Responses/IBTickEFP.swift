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


/**
 Bid EFP Computation
 Ask EFP Computation
 Last EFP Computation
 Open EFP Computation
 High EFP Computation
 Low EFP Computation
 Close EFP Computation
 
 */

/// Exchange of physicals
/// A private agreement between two parties allowing for one party to swap a futures contract for the actual underlying asse

public struct IBTickEFP: IBEvent {
	
	public var requestID: Int
	
	public var type: IBTickType
	
	public var points: Double
	
	public var pointsFormatted: String
	
	public var impliedPrice: Double
	
	public var holded: Int
	
	public var futureLastTradeDate: Date
	
	public var dividendImpact: Double
	
	public var dividendsToLastTradeDate: Double
	
}

extension IBTickEFP: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)
		self.points = try container.decode(Double.self)
		self.pointsFormatted = try container.decode(String.self)
		self.impliedPrice = try container.decode(Double.self)
		self.holded = try container.decode(Int.self)
		self.futureLastTradeDate = try container.decode(Date.self)
		self.dividendImpact = try container.decode(Double.self)
		self.dividendsToLastTradeDate = try container.decode(Double.self)
	}
	
}
