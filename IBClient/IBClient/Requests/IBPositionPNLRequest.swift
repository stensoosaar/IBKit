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


public struct IBPositionPNLRequest: IBRequest {
	
	public let type: IBRequestType = .singlePNL
	public let id: Int?
	public let accountName: String
	public let contractID: Int
	public let modelCode: [String]?
	
	/// Requests position PNL
	/// - Parameter requestID: request ID
	/// - Parameter accountName: contract description
	/// - Parameter contractID: data type to build a bar
	/// - Parameter modelCode: use only data from regular trading hours
	/// - Returns: IBPositionPNL event

	public init(id: Int, accountName: String, contractID: Int, modelCode: [String]? = nil) {
		self.id = id
		self.accountName = accountName
		self.contractID = contractID
		self.modelCode = modelCode
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(id)
		try container.encode(accountName)
		if let code = modelCode{
			try container.encode(code.joined(separator: ","))
		} else {
			try container.encodeOptional(modelCode)
		}
		try container.encode(contractID)

	}
	
}
