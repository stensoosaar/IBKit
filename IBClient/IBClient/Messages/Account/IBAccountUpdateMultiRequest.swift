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


public struct IBAccountUpdateMultiRequest: Identifiable, IBCancellableRequest {

	public let id: Int
	public let type: IBRequestType = .accountUpdatesMulti
	public let accountName: String
	public let ledger: Bool
	public let modelCode:String?
	private let version: Int = 1

	/// Subscribes account summary.
	/// - Parameters:
	///  - id: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	///  - accountName: account name. (from managed accounts)
	///  - ledger:
	///  - model:
	public init(id: Int, accountName: String, ledger: Bool = true, model: String? = nil) {
		self.id = id
		self.accountName = accountName
		self.ledger = ledger
		self.modelCode = model
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
		try container.encode(accountName)
		try container.encodeOptional(modelCode)
		try container.encode(ledger)
	}
	
	public var cancel: any IBRequest{
		return IBAccountUpdateMultiCancellation(id: id)
	}
	
}


public struct IBAccountUpdateMultiCancellation: IBRequest, Identifiable{

	public let id: Int
	public let type: IBRequestType = .cancelAccountUpdatesMulti
	private let version: Int = 1

	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event

	public init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(id)
	}
	
}
