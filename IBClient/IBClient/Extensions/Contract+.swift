//
//  Contract+.swift
//  IBKit
//
//  Created by Sten Soosaar on 21.05.2025.
//

import Foundation
import TWS



public extension Contract {
	
	
	/**
	 Creates new equity contract
	 - parameter symbol: symbol of the underlying base asset
	 - parameter currency: quoting asset
	 - parameter exchange: IB exchange abbreviation. Usally listing exchange or SMART if contract is traded in multiple exchanges
	 
	 - note: IBExchange provides documented exhange codes
	 */
	
	static func equity(_ symbol: String, currency: String, exchange: IBExchange = .SMART) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.currency = currency
		contract.exchange = exchange.rawValue
		contract.type = .stock
		return contract
	}
	
	/**
	 Creates new foreign exchange contract
	 - parameter symbol: symbol of the underlying base asset
	 - parameter currency: quoting asset
	 - parameter exchange: IDEALPRO
	*/
	
	static func forex(_ symbol: String, currency: String, exchange: IBExchange = .IDEALPRO) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.currency = currency
		contract.exchange = exchange.rawValue
		contract.type = .cash
		return contract
	}
	
	
	static func index(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.currency = currency
		contract.exchange = exchange.rawValue
		contract.type = .index
		return contract	}
		

	static func fund(_ symbol:String, currency: String, exchange: IBExchange = .FUNDSERV) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.currency = currency
		contract.exchange = exchange.rawValue
		contract.type = .fund
		return contract
	}

	static func commodity(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.currency = currency
		contract.exchange = exchange.rawValue
		contract.type = .commodity
		return contract
	}
		
	static func bond(_ secID: GlobalIdentifier, currency: String, exchange: IBExchange = .SMART) -> Contract {
		var contract = Contract()
		contract.globalID = secID
		contract.currency = currency
		contract.exchange = exchange.rawValue
		contract.type = .fund
		return contract
	}
		
	static func crypto(_ symbol:String, currency: String, exchange: IBExchange = .PAXOS) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.type = .crypto
		contract.currency = currency
		contract.exchange = exchange.rawValue
		return contract
	}
		
	static func future(_ symbol: String, currency: String, expiration: DateComponents, size: Double? = nil, exchange: IBExchange = .CME) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.type = .future
		contract.currency = currency
		contract.expiration = expiration
		contract.multiplier = size
		contract.exchange = exchange.rawValue
		return contract
	}

	static func future(localSymbol: String, currency: String, size: Double? = nil, exchange: IBExchange = .CME) -> Contract {
		var contract = Contract()
		contract.localSymbol = localSymbol
		contract.type = .future
		contract.currency = currency
		contract.multiplier = size
		contract.exchange = exchange.rawValue
		return contract
	}
		
	static func continousFuture(_ symbol: String, currency: String, exchange: IBExchange = .CME) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.type = .continousFuture
		contract.currency = currency
		contract.expiration = nil
		contract.multiplier = nil
		contract.exchange = exchange.rawValue
		return contract
	}
		
	static func call(_ symbol: String, currency: String, expiration: DateComponents, strike: Double, size: Double = 100, exchange: IBExchange = .SMART) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.type = .option
		contract.currency = currency
		contract.expiration = expiration
		contract.strike = strike
		contract.right = .call
		contract.multiplier = size
		contract.exchange = exchange.rawValue
		return contract
	}
		
	static func put(_ symbol: String, currency: String, expiration: DateComponents, strike: Double, size: Double = 100, exchange: IBExchange = .SMART) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.type = .option
		contract.currency = currency
		contract.expiration = expiration
		contract.strike = strike
		contract.right = .put
		contract.multiplier = size
		contract.exchange = exchange.rawValue
		return contract
	}
		
	static func option(localSymbol: String, currency: String, size: Double? = nil, exchange: IBExchange = .CME) -> Contract {
		var contract = Contract()
		contract.localSymbol = localSymbol
		contract.type = .option
		contract.currency = currency
		contract.multiplier = size
		contract.exchange = exchange.rawValue
		return contract
	}
		
	static func cfd(_ symbol: String, currency: String, exchange: IBExchange = .SMART) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.type = .cfd
		contract.currency = currency
		contract.exchange = exchange.rawValue
		return contract
	}
		
	static func spread(_ symbol: String, currency: String, long: ComboLeg, short: ComboLeg) -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.type = .combo
		contract.currency = currency
		//contract.comboLegs = [long, short]
		return contract
	}
	
	
}
