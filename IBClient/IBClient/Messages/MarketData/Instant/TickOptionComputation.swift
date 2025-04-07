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


/// Receive's option specific market data. This method is called when the market in an option or its
/// underlier moves. TWS’s option model volatilities, prices, and deltas, along with the present value of
/// dividends expected on that options underlier are received.
public struct TickOptionComputation: AnyTickEvent {
	
	public enum CalculationBase: Int, Decodable, Sendable {
		case returnBased 	= 0
		case priceBased		= 1
	}
		
	public var type: IBTickType
	
	/// - impliedVolatility:	the implied volatility calculated by the TWS option modeler, using the specified tick type value.
	public var impliedVolatility: Double?
	
	public var dividendNPV: Double?
	
	/// - delta:	the option delta value.
	public var delta: Double?
	
	/// - optPrice:	the option price.
	public var optionPrice: Double?
	
	/// - pvDividend:	the present value of dividends expected on the option's underlying.
	public var pvDividend: Double?
	
	/// - gamma:	the option gamma value.
	public var gamma: Double?
	
	/// - vega:	the option vega value.
	public var vega: Double?
	
	/// - theta:	the option theta value.
	public var theta: Double?
	
	/// - undPrice:	the price of the underlying.
	public var underlyingPrice: Double?
	
	/// - tickAttrib:	0 - return based, 1- price based.
	public var calculationBase: CalculationBase?
}


extension TickOptionComputation: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("No server version found. Check the connection!")
		}

		var container = try decoder.unkeyedContainer()

		let version = serverVersion < IBServerVersion.PRICE_BASED_VOLATILITY ? try container.decode(Int.self) : serverVersion

		_ = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)

		if serverVersion >= IBServerVersion.PRICE_BASED_VOLATILITY {
			calculationBase = try container.decode(CalculationBase.self)
		}

		let iv = try container.decode(Double.self)
		self.impliedVolatility = iv < 0 ? nil : iv
	
		let d = try container.decode(Double.self)
		self.delta = d == -2 ? nil : d

		if version >= 6 ||  type == .Model_Option_Computation || type == .Delayed_Model_Option {
			
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

extension IBResponseWrapper where T == TickOptionComputation{
	
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let offset = decoder.serverVersion < IBServerVersion.PRICE_BASED_VOLATILITY ? 2 : 1
		guard let stringValue = try? decoder.peek(offset: offset),
			let intValue = Int(stringValue)
		else { throw IBError.decodingError("Unable to decode response id") }
		self.id = intValue
		self.result = try container.decode(TickOptionComputation.self)
	}
	
}
