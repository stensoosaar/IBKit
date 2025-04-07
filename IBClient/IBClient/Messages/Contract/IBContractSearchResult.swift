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


/// return matching contracts for search 
public struct IBContractSearchResult: IBEvent {
	/// available trade types for root contract
	public let matches: [IBContract:[IBSecuritiesType]]
	
}


extension IBContractSearchResult: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		let resultCount = try container.decode(Int.self)
		var buffer: [IBContract:[IBSecuritiesType]] = [:]
		for _ in 0..<resultCount {
			
			var availableTypes: [IBSecuritiesType] = []

			let contractID = try container.decode(Int.self)
			let symbol = try container.decode(String.self)
			let type = try container.decode(IBSecuritiesType.self)
			let primaryExchange = try container.decode(IBExchange.self)
			let currency = try container.decode(String.self)
			
			let derivateCount = try container.decode(Int.self)
			
			for _ in 0..<derivateCount{
				let obj = try container.decode(IBSecuritiesType.self)
				availableTypes.append(obj)
			}
			
			var description: String?
			var issuerID: String?
			if decoder.serverVersion >= IBServerVersion.BOND_ISSUERID{
				description = try container.decode(String.self)
				issuerID = try container.decode(String.self)
			}

			let contract = IBContract(
				id:contractID,
				symbol: symbol,
				type: type,
				currency: currency,
				primaryExchange: primaryExchange,
				issuerID: issuerID,
				description:description
			)
			
			buffer[contract] = availableTypes
		}
		matches = buffer
	}
}


extension IBResponseWrapper where T == IBContractSearchResult {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}
