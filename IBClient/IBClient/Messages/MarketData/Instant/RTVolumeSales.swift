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


/// The RT Volume tick type corresponds to the TWS’ Time & Sales window and contains
public struct RTVolumeSales: AnyTickEvent {
	
	/// last trade’s price
	public var price: String
	
	/// last trade size
	public var size: String
	
	/// last trade time
	public var timestamp: String
	
	/// current day’s total traded volume,
	public var totalVolume: String
	
	/// Volume Weighted Average Price (VWAP)
	public var vwap: String
	
	/// indicates whether or not the trade was filled by a single market maker.
	public var singleTrade: String
}


extension RTVolumeSales: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		
		let components = try container.decode(String.self).components(separatedBy: ";")
		guard components.count == 6
		else { throw  IBError.decodingError("failed to decode RT VOLUME SALES info") }
		
		self.price = components[0]
		self.size = components[1]
		self.timestamp = components[2]
		self.totalVolume = components[3]
		self.vwap = components[4]
		self.singleTrade = components[5]
	}
}


