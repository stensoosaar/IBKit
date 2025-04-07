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


public struct IBContract: Sendable {
	
	public var id: Int?
	
	public var symbol: String?
	
	public var securitiesType: IBSecuritiesType
	
	public var expiration: Date?
	
	public var strike: Double?
	
	public var right: IBExecutionRight?
	
	public var multiplier: Double?
	
	public var exchange: IBExchange?
	
	public var primaryExchange: IBExchange?
	
	public var currency: String
	
	public var localSymbol: String?
	
	public var tradingClass: String?
	
	public var isExpired: Bool = false
	
	public var secId: SecurityID?
	
	public var issuerID: String?
	
	public var description: String?
	
	public struct ComboLeg: Sendable {
		
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
	
	public struct DeltaNeutral: Sendable {
		var conId: Int
		var delta: Double
		var price: Double
	}
	
	public var deltaNeutralContract: DeltaNeutral?
	
	/// Creates new contract
	/// - Parameter conId: IB unique contract identifier
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
	
	
	public init(id: Int? = nil, symbol: String?=nil, type: IBSecuritiesType, currency: String, expiration: Date?=nil, strike: Double?=nil, right: IBExecutionRight?=nil, multiplier: Double?=nil, exchange: IBExchange?=nil, primaryExchange: IBExchange?=nil, localSymbol: String?=nil, tradingClass: String?=nil, isExpired: Bool = false, secId: SecurityID? = nil, issuerID: String?=nil, description: String? = nil){
		
		self.id = id
		self.symbol = symbol
		self.securitiesType = type
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
		self.issuerID = issuerID
		self.description = description
	}
	
}

extension IBContract: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(securitiesType)
		hasher.combine(symbol)
		hasher.combine(currency)
		hasher.combine(expiration)
		hasher.combine(strike)
		hasher.combine(multiplier)
		hasher.combine(exchange)
		hasher.combine(primaryExchange)
		hasher.combine(isExpired)
	}
	
	public static func == (lhs: IBContract, rhs: IBContract) -> Bool {
		return lhs.id == rhs.id
	}
	
}


extension IBContract: IBCodable{
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.symbol = try container.decode(String.self)
		self.securitiesType = try container.decode(IBSecuritiesType.self)
		self.expiration = try container.decodeOptional(Date.self)
		self.strike = try container.decodeOptional(Double.self)
		self.right = try container.decodeOptional(IBExecutionRight.self)
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
	
	public init(from decoder: IBDecoder) throws {
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
	
	
	public func encode(to encoder: IBEncoder) throws {
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
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.conId = try container.decode(Int.self)
		self.delta = try container.decode(Double.self)
		self.price = try container.decode(Double.self)
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(conId)
		try container.encode(delta)
		try container.encode(price)
	}
	
}


public extension IBContract {
	
	static func index(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, type: .index, currency: currency, exchange: exchange)
	}
	
	static func forex(_ symbol:String, currency: String, exchange: IBExchange = .IDEALPRO) -> IBContract {
		return IBContract(symbol: symbol, type: .forex, currency: currency, exchange: exchange)
	}
	
	static func equity(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, type: .stock, currency: currency, exchange: exchange)
	}

	static func fund(_ symbol:String, currency: String, exchange: IBExchange = .FUNDSERV) -> IBContract {
		return IBContract(symbol: symbol, type: .fund, currency: currency, exchange: exchange)
	}
	
	static func commodity(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, type: .commodity, currency: currency, exchange: exchange)
	}
	
	static func bond(_ secID: SecurityID, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: secID.value, type: .debt, currency: currency, exchange: exchange)
	}
	
	static func crypto(_ symbol:String, currency: String, exchange: IBExchange = .PAXOS) -> IBContract {
		return IBContract(symbol: symbol, type: .crypto, currency: currency, exchange: exchange)
	}
	
	static func future(_ symbol: String, currency: String, expiration: Date, size: Double? = nil, exchange: IBExchange = .CME) -> IBContract {
		return IBContract(symbol: symbol, type: .future, currency: currency, expiration: expiration, multiplier: size, exchange: exchange)
	}

	static func future(localSymbol: String, currency: String, size: Double? = nil, exchange: IBExchange = .CME) -> IBContract {
		var con =  IBContract(symbol: "", type: .future, currency: currency, multiplier: size, exchange: exchange)
		con.localSymbol = localSymbol
		return con
	}
	
	static func continousFuture(_ symbol: String, currency: String, exchange: IBExchange = .CME) -> IBContract {
		return IBContract(symbol: symbol, type: .continousFuture, currency: currency, expiration: nil, multiplier: nil, exchange: exchange)
	}
	
	static func call(_ symbol: String, currency: String, expiration: Date, strike: Double, size: Double = 100, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, type: .option, currency: currency, expiration: expiration, strike: strike, right: .call, multiplier: size, exchange: exchange)
	}
	
	static func put(_ symbol: String, currency: String, expiration: Date, strike: Double, size: Double = 100, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, type: .option, currency: currency, expiration: expiration, strike: strike, right: .put, multiplier: size, exchange: exchange)
	}
	
	static func option(localSymbol: String, currency: String, size: Double? = nil, exchange: IBExchange = .CME) -> IBContract {
		var con =  IBContract(type: .option, currency: currency, multiplier: size, exchange: exchange)
		con.localSymbol = localSymbol
		return con
	}
	
	static func cfd(_ symbol: String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, type: .cfd, currency: currency, exchange: exchange)
	}
	
	static func spread(_ symbol: String, currency: String, long: ComboLeg, short: ComboLeg) -> IBContract {
		var con = IBContract(symbol: symbol, type: .combo, currency: currency)
		con.comboLegs = [long, short]
		return con
	}
	
}
