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

/**
 Bid Option Computation
 Ask Option Computation
 Last Option Computation
 Model Option Computation
 Custom Option Computation
 
 */


struct IBOptionComputation: IBEvent {
	
	public var requestID: Int
	
	public var type: IBTickType
	
	public var impliedVolatility: Double?
	
	public var dividendNPV: Double?
	
	public var delta: Double?
	
	public var optionPrice: Double?
	
	public var pvDividend: Double?
	
	public var gamma: Double?
	
	public var vega: Double?
	
	public var theta: Double?
	
	public var underlyingPrice: Double?
	
	public enum CalculationBase: Int, Codable {
		case returnBased 	= 0
		case priceBased		= 1
	}
	
	public var calculationBase: CalculationBase?
}


extension IBOptionComputation: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("No server version found. Check the connection!")
		}

		var container = try decoder.unkeyedContainer()

		let version = serverVersion < IBServerVersion.PRICE_BASED_VOLATILITY ? try container.decode(Int.self) : serverVersion

		self.requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)

		if serverVersion >= IBServerVersion.PRICE_BASED_VOLATILITY {
			calculationBase = try container.decode(CalculationBase.self)
		}

		let iv = try container.decode(Double.self)
		self.impliedVolatility = iv < 0 ? nil : iv
	
		let d = try container.decode(Double.self)
		self.delta = d == -2 ? nil : d

		if version >= 6 ||  type == .ModelOptionComputation || type == .DelayedModelOption {
			
			let op = try container.decode(Double.self)
			optionPrice = op == -1 ? nil : op
			
			let dnpv = try container.decode(Double.self)
			dividendNPV = dnpv == -1 ? nil : dnpv
			
		}

		if version >= 6 {
		
			let gammaValue = try container.decode(Double.self)
			self.gamma = gammaValue == -2 ? nil : gammaValue
		
			
			let vegaValue = try container.decode(Double.self)
			self.vega = vegaValue == -2 ? nil : vegaValue
			
			let thetaValue = try container.decode(Double.self)
			self.theta = thetaValue == -2 ? nil : thetaValue

			let undPriceValue = try container.decode(Double.self)
			self.underlyingPrice = undPriceValue == -1 ? nil : undPriceValue

		}
		
	}
	
}
