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


public struct IBAccountPNLRequest: IBCancellableRequest, Identifiable {
	
	public let id: Int
	public let type: IBRequestType = .accountPNL
	public let accountName: String
	public let model: [String]?
	
	/// Subscribes account profit and loss reporting
	/// - Parameters:
	///  - requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	///  - account: account identifier.
	///  - modelCode:
	/// - Returns: IBAccountPNL event
	public init(id: Int, accountName: String, model: [String]? = nil) {
		self.id = id
		self.accountName = accountName
		self.model = model
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.accountPNL)
		try container.encode(id)
		try container.encode(accountName)
		if let value = model {
			try container.encode(value.joined(separator: ","))
		} else {
			try container.encode("")
		}
	}
	
	public var cancel: any IBRequest{
		return IBAccountPNLCancellation(id: id)
	}
	
}



public struct IBAccountPNLCancellation: IBRequest, Identifiable{
	
	public let id: Int
	public let type: IBRequestType = .cancelAccountPNL
	
	public init(id: Int) {
		self.id = id
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
	}
	
}
