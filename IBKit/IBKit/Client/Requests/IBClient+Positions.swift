//
//  IBClient+Positions.swift
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
	
	func subscribePositionsMulti(_ index: Int, account: String, modelCode: String = "") throws {
		
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.positionsMulti)
		try container.encode(version)
		try container.encode(index)
		try container.encode(account)
		try container.encode(modelCode)
		try send(encoder: encoder)

	}
	
	func unsubscribePositionsMulti(_ index: Int) throws {
		
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelPositionsMulti)
		try container.encode(version)
		try container.encode(index)
		try send(encoder: encoder)

	}
	
	
	
	func subscribePositions() throws {
		
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.positions)
		try container.encode(version)
		try send(encoder: encoder)

	}
	
	func unsubscribePositions() throws {
		
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelPositions)
		try container.encode(version)
		try send(encoder: encoder)

	}
	
	func subscribePositionPNL(_ index: Int, account: String, contractID: Int, modelCode: [String]? = nil) throws {
		
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.singlePNL)
		try container.encode(index)
		try container.encode(account)
		if let code = modelCode{
			try container.encode(code.joined(separator: ","))
		} else {
			try container.encode(modelCode)
		}
		try container.encode(contractID)
		try send(encoder: encoder)

	}
	
}
