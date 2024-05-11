//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



struct IBOptionComputation: IBResponse, IBIndexedEvent{
	
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
	
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBClientError.decodingError("No server version found. Check the connection!")
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
