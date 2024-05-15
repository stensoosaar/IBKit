//
//  IBContract.swift
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

public struct IBContract: IBCodable {
	
	public var id: Int?
	
	public var symbol: String
	
	public var securitiesType: IBSecuritiesType
	
	public var expiration: Date?
	
	public var strike: Double?
	
	public enum ExecutionRight: String, Codable {
		case call 		= "C"
		case put 		= "P"
	}
	
	public var right: ExecutionRight?
	
	public var multiplier: Double?
	
	public var exchange: IBExchange?
	
	public var primaryExchange: IBExchange?
	
	public var currency: String
	
	public var localSymbol: String?
	
	public var tradingClass: String?
		
	public var isExpired: Bool = false
	
	// Extended fields

	public struct SecurityID: CustomStringConvertible, IBCodable{
		
		public enum IdentifierType: String, Codable, CustomStringConvertible {
			case CUSIP 			= "CUSIP"
			case SEDOL			= "SEDOL"
			case ISIN			= "ISIN"
			case RIC			= "RIC"
			
			public var description: String{
				return self.rawValue
			}
		}
		
		var type: IdentifierType
		var value: String
		
		private init(type: SecurityID.IdentifierType, value: String){
			self.type = type
			self.value = value
		}
		
		public var description: String{
			return String(format: "%@:%@", type.description, value)
		}
		
		public static func cusip(_ value: String) -> SecurityID {
			return SecurityID(type: .CUSIP, value: value)
		}
		
		public static func sedol(_ value: String) -> SecurityID {
			return SecurityID(type: .SEDOL, value: value)
		}
		
		public static func isin(_ value: String) -> SecurityID {
			return SecurityID(type: .ISIN, value: value)
		}
		
		public static func ric(_ value: String) -> SecurityID {
			return SecurityID(type: .RIC, value: value)
		}
		
		public func encode(to encoder: IBEncoder) throws {
			var container = encoder.unkeyedContainer()
			try container.encode(type)
			try container.encode(value)
		}
		
		public init(from decoder: IBDecoder) throws {
			var container = try decoder.unkeyedContainer()
			self.type = try container.decode(SecurityID.IdentifierType.self)
			self.value = try container.decode(String.self)
		}
		
	}
	
	public var secId: SecurityID?
	
	public var issuerID: String?
	
	public struct ComboLeg {
		
		var conId: Int
		
		var ratio: Int
		
		var action: IBAction
		
		var exchange: IBExchange
		
		var openClose: Int?
		
		var shortSaleSlot: Int?
		
		var designatedLocation: String?
		
		var exemptCode:Int = -1
	}
	
	public var comboLegsDescrip:String?
	
	public var comboLegs: [ComboLeg]?
	
	public struct DeltaNeutral {
		var conId: Int
		var delta: Double
		var price: Double
	}
	
	public var deltaNeutralContract: DeltaNeutral?
	
	/// Creates new contract
	/// - Parameter conId: IB unique ocntract identifier
	/// - Parameter symbol: underlying asset symbol
	/// - Parameter secType: securities type
	/// - Parameter currency: currency symbol
	/// - Parameter expiration: expiration date for expirable contracts,
	/// - Parameter strike: strike price for optionable contracts
	/// - Parameter right: execution right for optionable contracts (eg call / put)
	/// - Parameter multiplier: contract size, representing how much the contract value will change for 1 unit price change
	/// - Parameter exchange: destination exchange. Usually SMART
	/// - Parameter primaryExchange: exchange where the contract is listed
	/// - Parameter localSymbol: closest match to exchange ticker
	/// - Parameter tradingClass: The trading class name for this contract.
	/// - Parameter isExpired: if set to true, contract details requests and historical data queries can be performed pertaining to expired futures contracts. Expired options or other instrument types are not available.
	/// - Parameter secId: securities unique identifier such as ISIN, CUSIP, FIGI
	/// - Parameter comboLegsDescrip: spread contract description
	/// - Parameter comboLegs: spread contract legs
	/// - Parameter deltaNeutralContract: delta neutral contract
	
	
	public init(conId: Int? = nil, symbol: String, secType: IBSecuritiesType, currency: String, expiration: Date?=nil, strike: Double?=nil, right: ExecutionRight?=nil, multiplier: Double?=nil, exchange: IBExchange?=nil, primaryExchange: IBExchange?=nil,  localSymbol: String?=nil, tradingClass: String?=nil, isExpired: Bool = false, secId: SecurityID? = nil, comboLegsDescrip: String? = nil, comboLegs: [ComboLeg]? = nil, deltaNeutralContract: DeltaNeutral? = nil){
		
		self.id = conId
		self.symbol = symbol
		self.securitiesType = secType
		self.expiration = expiration
		self.strike = strike
		self.right = right
		self.multiplier = multiplier
		self.exchange = exchange
		self.primaryExchange = primaryExchange
		self.currency = currency
		self.localSymbol = localSymbol
		self.tradingClass = tradingClass
		self.isExpired = isExpired
		self.secId = secId
		self.comboLegsDescrip = comboLegsDescrip
		self.comboLegs = comboLegs
		self.deltaNeutralContract = deltaNeutralContract
		
	}
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.symbol = try container.decode(String.self)
		self.securitiesType = try container.decode(IBSecuritiesType.self)
		self.expiration = try container.decodeOptional(Date.self)
		self.strike = try container.decodeOptional(Double.self)
		self.right = try container.decodeOptional(ExecutionRight.self)
		self.multiplier = try container.decodeOptional(Double.self)
		self.exchange = try container.decodeOptional(IBExchange.self)
		self.currency = try container.decode(String.self)
		self.localSymbol = try container.decodeOptional(String.self)
		self.tradingClass = try container.decodeOptional(String.self)
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(id ?? 0)
		try container.encode(symbol)
		try container.encode(securitiesType)
		try container.encodeOptional(expiration)
		try container.encodeOptional(strike ?? 0)
		try container.encodeOptional(right)
		try container.encodeOptional(multiplier ?? 0)
		try container.encode(exchange)
		try container.encodeOptional(primaryExchange)
		try container.encode(currency)
		try container.encodeOptional(localSymbol)
		try container.encodeOptional(tradingClass)
	}
	
	
}




extension IBContract.ComboLeg: IBCodable {
	
	init(conId: Int, ratio: Int, action: IBAction, exchange: IBExchange) {
		self.conId = conId
		self.ratio = ratio
		self.action = action
		self.exchange = exchange
	}
	
	static func buy(id: Int, ratio:Int, exchange: IBExchange = .SMART) -> IBContract.ComboLeg {
		return IBContract.ComboLeg(conId: id, ratio: ratio, action: .buy, exchange: exchange)
	}
	
	static func sell(id: Int, ratio:Int, exchange: IBExchange = .SMART) -> IBContract.ComboLeg {
		return IBContract.ComboLeg(conId: id, ratio: ratio, action: .sell , exchange: exchange)
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.conId = try container.decode(Int.self)
		self.ratio = try container.decode(Int.self)
		self.action = try container.decode(IBAction.self)
		self.exchange = try container.decode(IBExchange.self)
		self.openClose = try container.decodeIfPresent(Int.self)
		self.shortSaleSlot = try container.decodeIfPresent(Int.self)
		self.designatedLocation = try container.decodeIfPresent(String.self)
		self.exemptCode = try container.decode(Int.self)
	}
	
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(conId)
		try container.encode(ratio)
		try container.encode(action)
		try container.encode(exchange)
		try container.encode(openClose)
		try container.encode(shortSaleSlot)
		try container.encode(designatedLocation)
		try container.encode(exemptCode)
	}
	
}


extension IBContract.DeltaNeutral: IBCodable {
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.conId = try container.decode(Int.self)
		self.delta = try container.decode(Double.self)
		self.price = try container.decode(Double.self)
	}
	
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(conId)
		try container.encode(delta)
		try container.encode(price)
	}
	
}
