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

///
public struct IBAccountUpdate: IBEvent {
	
	/// account name
	public var accountName: String
	
	/// account attribute being received
	public var key: IBAccountKey
	
	/// account attribute value
	public var value: Double?
	
	/// account attribute currency
	public var currency: String?
	
}


extension IBAccountUpdate: IBDecodable {
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		key = try container.decode(IBAccountKey.self)
		
		switch key{
		case  .accountType:
			let type = try container.decode(String.self)
			_ = try container.decode(String.self)
			self.accountName = try container.decode(String.self)
		case  .AccountReady, .NLVAndMarginInReview:
			let isReady = try container.decode(String.self)
			_ = try container.decode(String.self)
			self.accountName = try container.decode(String.self)
		case  .AccountCode:
			self.currency = try container.decode(String.self)
			_ = try container.decode(String.self)
			self.accountName = try container.decode(String.self)
		case .Currency:
			self.currency = try container.decode(String.self)
			_ = try container.decode(String.self)
			self.accountName = try container.decode(String.self)
		case .AccountOrGroup, .RealCurrency, .Cryptocurrency:
			self.currency = try container.decode(String.self)
			_ = try container.decode(String.self)
			accountName = try container.decode(String.self)
		case .SegmentTitleS, .TradingTypeS:
			let type = try container.decode(String.self)
			_ = try container.decode(String.self)
			accountName = try container.decode(String.self)
		default:
			value = try container.decode(Double.self)
			currency = try container.decode(String.self)
			accountName = try container.decode(String.self)
		}
		
	}
}


