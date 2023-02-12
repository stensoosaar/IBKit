//
//  AccountEvents.swift
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


public struct IBManagedAccounts: Decodable, IBAccountEvent {
	
	public var identifiers: [String]
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.identifiers = try container.decode(String.self).components(separatedBy: ",")
	}
	
}


public struct IBAccountSummary: Decodable,IBAccountEvent {
	
	public var requestId: Int
	public var accountName: String
	public var key: IBAccountKey
	public var value: Double
	public var userInfo: String
	
	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestId = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.key = try container.decode(IBAccountKey.self)
		
		if key == .accountType {
			self.value = 0
			self.userInfo = try container.decode(String.self)
		} else {
			self.value = try container.decode(Double.self)
			self.userInfo = try container.decode(String.self)
		}
		
	}

	
}


public struct IBAccountSummaryEnd: Decodable,IBAccountEvent {
	
	public var requestId: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestId = try container.decode(Int.self)
	}

	
}


public struct IBAccountSummaryMulti: Decodable, IBAccountEvent {

	public var requestId: Int
	public var accountName: String
	public var modelCode:String
	public var key: String
	public var value: Double
	public var currency: String
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestId = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.modelCode = try container.decode(String.self)
		self.key = try container.decode(String.self)
		self.value = try container.decode(Double.self)
		self.currency = try container.decode(String.self)
	}

}


public struct IBAccountSummaryMultiEnd: Decodable, IBAccountEvent {
	
	public var requestId: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestId = try container.decode(Int.self)
	}

}


public struct IBAccountPNL: Decodable, IBAccountEvent {
	
	public var requestId: Int
	public var daily: Double
	public var unrealized: Double
	public var realized: Double
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.requestId = try container.decode(Int.self)
		self.daily = try container.decode(Double.self)
		self.unrealized = try container.decode(Double.self)
		self.realized = try container.decode(Double.self)
	}

}

