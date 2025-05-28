//
//  Contract+.swift
//  IBKit
//
//  Created by Sten Soosaar on 21.05.2025.
//

import TWS

public extension Contract {
	
	/**
	 Creates new equity contract
	 - parameter symbol: symbol of the underlying base asset
	 - parameter currency: quoting asset
	 - parameter exchange: IB exchange abbreviation. Usally listing exchange or SMART if contract is traded in multiple exchanges
	 
	 - note: IBExchange provides documented exhange codes
	 */
	
	static func equity(_ symbol: String, currency: String, exchange: String = "SMART") -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.currency = currency
		contract.exchange = exchange
		contract.type = .stock
		return contract
	}
	
	/**
	 Creates new foreign exchange contract
	 - parameter symbol: symbol of the underlying base asset
	 - parameter currency: quoting asset
	 - parameter exchange: IDEALPRO
	*/
	
	static func forex(_ symbol: String, currency: String, exchange: String = "IDEALPRO") -> Contract {
		var contract = Contract()
		contract.symbol = symbol
		contract.currency = currency
		contract.exchange = exchange
		contract.type = .cash
		return contract
	}
	
	
	
}
