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


public struct IBAccountUpdateRequest: IBCancellableRequest, Hashable {
	
	public let type: IBRequestType = .managedAccounts
	public let accountName: String
	public let subscribe: Bool
	private let version: Int = 2

	private init(accountName: String, subscribe: Bool){
		self.accountName = accountName
		self.subscribe = subscribe
	}
	
	/// Subscribe account values, portfolio and last update time information
	/// - Parameter accountName: account name
	///
	/// After the initial callback to IBAccountUpdate, callbacks only occur for values which have changed.
	/// This occurs at the time of a position change, or every (fixed) 3 minutes at most.
	public init (accountName: String){
		self.accountName = accountName
		self.subscribe = true
	}
	
	
	public var cancel: any IBRequest{
		return IBAccountUpdateRequest(accountName: accountName, subscribe: false)
	}
		
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.accountData)
		try container.encode(version)
		try container.encode(subscribe)
		try container.encode(accountName)
	}
	
}

