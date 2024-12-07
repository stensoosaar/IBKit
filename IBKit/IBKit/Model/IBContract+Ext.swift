//
//  File.swift
//  
//
//  Created by Sten Soosaar on 11.05.2024.
//

import Foundation



public extension IBContract {
	
	static func index(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, secType: .index, currency: currency, exchange: exchange)
	}
	
	static func forex(_ symbol:String, currency: String, exchange: IBExchange = .IDEALPRO) -> IBContract {
		return IBContract(symbol: symbol, secType: .forex, currency: currency, exchange: exchange)
	}
	
	static func equity(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, secType: .stock, currency: currency, exchange: exchange)
	}

	static func fund(_ symbol:String, currency: String, exchange: IBExchange = .FUNDSERV) -> IBContract {
		return IBContract(symbol: symbol, secType: .fund, currency: currency, exchange: exchange)
	}

	
	static func commodity(_ symbol:String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, secType: .commodity, currency: currency, exchange: exchange)
	}
	
	static func bond(_ secID: SecurityID, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: secID.value, secType: .debt, currency: currency, exchange: exchange)
	}
	
	static func crypto(_ symbol:String, currency: String, exchange: IBExchange = .PAXOS) -> IBContract {
		return IBContract(symbol: symbol, secType: .crypto, currency: currency, exchange: exchange)
	}
	
	static func future(_ symbol: String, currency: String, expiration: Date, size: Double? = nil, exchange: IBExchange = .CME) -> IBContract {
		return IBContract(symbol: symbol, secType: .future, currency: currency, expiration: expiration, multiplier: size, exchange: exchange)
	}

	static func future(localSymbol: String, currency: String, size: Double? = nil, exchange: IBExchange = .CME) -> IBContract {
		var con =  IBContract(symbol: "", secType: .future, currency: currency, multiplier: size, exchange: exchange)
		con.localSymbol = localSymbol
		return con
	}
	
	static func continousFuture(_ symbol: String, currency: String, exchange: IBExchange = .CME) -> IBContract {
		return IBContract(symbol: symbol, secType: .continousFuture, currency: currency, expiration: nil, multiplier: nil, exchange: exchange)
	}
	
	static func call(_ symbol: String, currency: String, expiration: Date, strike: Double, size: Double = 100, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, secType: .option, currency: currency, expiration: expiration, strike: strike, right: .call, multiplier: size, exchange: exchange)
	}
	
	static func put(_ symbol: String, currency: String, expiration: Date, strike: Double, size: Double = 100, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, secType: .option, currency: currency, expiration: expiration, strike: strike, right: .put, multiplier: size, exchange: exchange)
	}
	
	static func option(localSymbol: String, currency: String, size: Double? = nil, exchange: IBExchange = .CME) -> IBContract {
		var con =  IBContract(symbol: "", secType: .option, currency: currency, multiplier: size, exchange: exchange)
		con.localSymbol = localSymbol
		return con
	}
	
	
	static func cfd(_ symbol: String, currency: String, exchange: IBExchange = .SMART) -> IBContract {
		return IBContract(symbol: symbol, secType: .cfd, currency: currency, exchange: exchange)
	}
	
	static func spread(_ symbol: String, currency: String, long: ComboLeg, short: ComboLeg) -> IBContract {
		return IBContract(symbol: symbol, secType: .combo, currency: currency, comboLegs: [long, short])
	}
	
}
