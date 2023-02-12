//
//  IBClient+Account.swift
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

public extension IBClient {

	
	/// Requests account identifiers

	func managedAccounts() throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.managedAccounts)
		try container.encode(version)
		try send(encoder: encoder)
	}
	
	
	/// Subscribes account summary.
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter tags: Array of IBAccountKeys to specify what to subscribe. As a default, all keys will be subscribed
	/// - Parameter accountGroup:
	/// - Returns: AccountSummary event per specified tag and will be updated once per 3 minutes
	 
	func subscribeAccountSummary(_ requestID: Int, tags: [IBAccountKey] = IBAccountKey.allValues, accountGroup group: String = "All") throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.accountSummary)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(group)
		let tagValues = tags.map({$0.rawValue}).joined(separator: ",")
		try container.encode(tagValues)
		try send(encoder: encoder)
	}
	
	func subscribeAccountSummary2(_ requestID: Int, tags: [String], accountGroup group: String = "All") throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.accountSummary)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(group)
		let tagValues = tags.map({$0}).joined(separator: ",")
		try container.encode(tagValues)
		try send(encoder: encoder)
	}
	

	
	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event

	func unsubscribeAccountSummary(_ requestID: Int) throws {
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelAccountSummary)
		try container.encode(requestID)
		try send(encoder: encoder)
	}
	
	
	/// Subscribes account summary.
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter tags: Array of IBAccountKeys to specify what to subscribe. As a default, all keys will be subscribed
	/// - Parameter accountGroup:
	/// - Returns: AccountSummary event per specified tag and will be updated once per 3 minutes
	 
	func subscribeAccountSummaryMulti(_ requestID: Int, accountName: String, ledger:Bool = true, modelCode:String? = nil) throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.accountUpdatesMulti)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(accountName)
		try container.encode(modelCode)
		try container.encode(ledger)
		try send(encoder: encoder)
	}
	

	
	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event

	func unsubscribeAccountSummaryMulti(_ requestID: Int) throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelAccountUpdatesMulti)
		try container.encode(version)
		try container.encode(requestID)
		try send(encoder: encoder)
	}
	
	
	/// Subscribes account profit and loss reporting
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter account: account identifier.
	/// - Parameter modelCode:
	/// - Returns: AccountPNL event

	func subscribeAccountPNL(_ requestID: Int, account: String, modelCode: [String]? = nil) throws {
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.PNL)
		try container.encode(requestID)
		try container.encode(account)
		if let code = modelCode {
			try container.encode(code.joined(separator: ","))
		} else {
			try container.encode("")
		}
		try send(encoder: encoder)
	}
	

	/// Unsubscribes account profit and loss reporting
	/// - Parameter requestIDunique request identifier. Best way to obtain one, is by calling client.getNextID().

	func unsubscribeAccountPNL(_ requestID: Int) throws {
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelPNL)
		try container.encode(requestID)
		try send(encoder: encoder)
	}

	
}


