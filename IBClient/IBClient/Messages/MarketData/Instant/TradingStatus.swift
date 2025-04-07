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




/// The TradingStatus tick type indicates if a contract has been halted for trading. It can have the
public enum TradingStatus: Int, AnyTickEvent {
	
	/// Status not available. Usually returned with frozen data.
	case unknown = -1
	
	/// This value will only be returned if the contract is in a TWS watchlist.
	case notHalted = 0
	
	/// Trading halt is imposed for purely regulatory reasons with/without volatility halt.
	case general = 1
	
	/// Trading halt is imposed by the exchange to protect against extreme volatility.
	case volatility = 2
	
}


extension TradingStatus: Decodable {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let value = try container.decode(Double.self)
		
		switch value {
		case 0.0: 	self = .notHalted
		case 1.0:	self = .general
		case 2.0:	self = .volatility
		default:	self = .unknown
		}
	}
	
}
