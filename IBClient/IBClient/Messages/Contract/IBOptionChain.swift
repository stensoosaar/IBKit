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


public struct IBOptionChain: IBEvent {
	public let exchange: String
	public let underlyingContractId: Int
	public let tradingClass : String
	public let multiplier: String
	public let expirations: [Date]
	public let strikes: [Double]
	
}

extension IBOptionChain: IBDecodable{

	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		exchange = try container.decode(String.self)
		underlyingContractId = try container.decode(Int.self)
		tradingClass = try container.decode(String.self)
		multiplier = try container.decode(String.self)
		var expirationBuffer : [Date] = []
		
		
		let expCount = try container.decode(Int.self)
				
		for _ in 0..<expCount{
			let expiration = try container.decode(Date.self)
			expirationBuffer.append(expiration)
		}
		expirations = expirationBuffer
		
		var strikeBuffer : [Double] = []
		let strikeCount = try container.decode(Int.self)
		for _ in 0..<strikeCount{
			let strike = try container.decode(Double.self)
			strikeBuffer.append(strike)
		}
		strikes = strikeBuffer
	}

}


extension IBResponseWrapper where T == IBOptionChain {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}



public struct IBOptionChainEnd: IBEvent, Identifiable {
	public let id: Int
}


extension IBOptionChainEnd: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
	}

}
