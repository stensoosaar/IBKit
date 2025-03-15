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

/*
 Option Historical Volatility
 Option Implied Volatility
 Index Future Premium
 Shortable
 Halted
 Trade Count
 Trade Rate
 Volume Rate
 RT Historical Volatility
 Bond Factor Multiplier
 Estimated IPO - Midpoint
 Final IPO Price
*/


public struct IBTickGeneric: IBEvent {
	public var requestID: Int
	public var tick: IBMarketData
}

extension IBTickGeneric: IBDecodable{

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		
		switch type {
		case .Shortable:
			let value = try container.decode(Double.self)
			tick = IBShortable(type: type, value: value)
		case .Halted:
			let value = try container.decode(IBHalted.Status.self)
			tick = IBHalted(type: type, value: value)
		default:
			let value = try container.decode(Double.self)
			tick = IBTick(type: type, value: value, date: Date())
		}
	}
}


public struct IBShortable: IBMarketData{
	
	public typealias TickValue = Status
	public let type: IBTickType
	public let value: Status
	
	public enum Status: Sendable {
		
		/// There are at least 1000 shares available for short selling.
		case shortable
		
		///This contract will be available for short selling if shares can be located
		case locatable
		
		///Contract is not available for short selling.
		case notShortable
	}
		
	init(type: IBTickType, value: Double) {
		self.type = type
		switch value {
		case 0...1.5: 		self.value = .notShortable
		case 1.5...2.5: 	self.value = .locatable
		default:			self.value = .shortable
		}
	}
	
}


public struct IBHalted: IBMarketData{
	
	public typealias TickValue = Status
	
	public enum Status: Int, Sendable, Decodable {
		
		///  status not available. Usually returned with frozen data.
		case unknown = -1
		
		/// This value will only be returned if the contract is in a TWS watchlist.
		case notHalted = 0
		
		///  Trading halt is imposed for purely regulatory reasons with/without volatility halt.
		case general = 1
		
		/// Trading halt is imposed by the exchange to protect against extreme volatility.
		case volatility = 2
	}
	
	public let type: IBTickType
	
	public let value: TickValue
		
}


public struct IBTradingStatus: IBMarketData{
	
	public enum Status: Int, Codable, Sendable {
		case unknown 			= -1
		case active  			= 0
		case generalHalt 		= 1
		case volatilityHalt 	= 2
	}
	
	public typealias TickValue = Status
	public let type: IBTickType
	public let value: TickValue
}
