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

public struct IBMarketDepthExchanges: IBEvent {
	
	public struct Exchange: Sendable, IBDecodable{
		
		public var exchange: String
		public var type: IBSecuritiesType
		public var listingExch: String?
		public var serviceDataType: String?
		public var aggGroup: Int?
		
		public init(from decoder: IBDecoder) throws {

			guard let serverVersion = decoder.serverVersion else {
				throw IBError.decodingError("No server version found. Check the connection!")
			}

			var container = try decoder.unkeyedContainer()
			self.exchange = try container.decode(String.self)
			self.type = try container.decode(IBSecuritiesType.self)
			if serverVersion >= IBServerVersion.SERVICE_DATA_TYPE{
				self.listingExch = try container.decode(String.self)
				self.serviceDataType = try container.decode(String.self)
				self.aggGroup = try container.decode(Int.self)
			} else {
				_ = try container.decode(Bool.self)
			}

			
		}
		
	}
	
	public var description:[Exchange] = []
	
}


extension IBMarketDepthExchanges: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let count = try container.decode(Int.self)
		for _ in 0..<count{
			let exchange = try container.decode(Exchange.self)
			description.append(exchange)
		}
	}
	
}
