//
//  IBOrderState.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
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

/// Provides an active order's current state
public struct IBOrderState: Decodable {
	
	// The order's current status.
	public var status: IBOrder.Status
	public var initMarginBefore: String?
	public var maintMarginBefore: String?
	public var equityWithLoanBefore: String?
	public var initMarginChange: String?
	public var maintMarginChange: String?
	public var equityWithLoanChange: String?
	public var initMarginAfter: String?
	public var maintMarginAfter: String?
	public var equityWithLoanAfter: String?
	public var commission: String?
	public var minCommission: String?
	public var maxCommission: String?
	public var commissionCurrency: String?
	public var warning: String?
	
	
	public init(from decoder: Decoder) throws {
		
		guard let decoder = decoder as? IBDecoder,
			  let serverVersion = decoder.serverVersion else {
			throw IBError.codingError("No server version found. Check the connection!")
		}

		var container = try decoder.unkeyedContainer()
		
		self.status = try container.decode(IBOrder.Status.self)

		if serverVersion >= IBServerVersion.WHAT_IF_EXT_FIELDS{
			self.initMarginBefore = try container.decode(String.self)
			self.maintMarginBefore = try container.decode(String.self)
			self.equityWithLoanBefore = try container.decode(String.self)
			self.initMarginChange = try container.decode(String.self)
			self.maintMarginChange = try container.decode(String.self)
			self.equityWithLoanChange = try container.decode(String.self)
		}

		self.initMarginAfter = try container.decode(String.self)
		self.maintMarginAfter = try container.decode(String.self)
		self.equityWithLoanAfter = try container.decode(String.self)
		self.commission = try container.decode(String.self)
		self.minCommission = try container.decode(String.self)
		self.maxCommission = try container.decode(String.self)
		self.commissionCurrency = try container.decode(String.self)
		self.warning = try container.decodeOptional(String.self)

	}
	
}
