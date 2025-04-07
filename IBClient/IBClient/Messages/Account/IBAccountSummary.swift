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

/// Receives the account information. This method will receive the account information just as it appears in the TWS' Account Summary Window.
public struct IBAccountSummary: IBEvent {
	
	/// account name
	public var accountName: String
	
	/// account attribute being received
	public var key: IBAccountKey
	
	/// account attribute value
	public var value: Double?=nil
	
	/// account attribute currency
	public var currency: String
}


extension IBAccountSummary: IBDecodable {
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.accountName = try container.decode(String.self)
		self.key = try container.decode(IBAccountKey.self)
		
		if key == .accountType {
			self.currency = try container.decode(String.self)
		} else {
			self.value = try container.decode(Double.self)
			self.currency = try container.decode(String.self)
		}
	}
}

extension IBResponseWrapper where T == IBAccountSummary {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}



public struct IBAccountSummaryEnd: IBEvent, Decodable {}

extension IBResponseWrapper where T == IBAccountSummaryEnd {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = IBAccountSummaryEnd()
	}
}
