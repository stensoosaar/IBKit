//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBContractDetailsRequest: IBIndexedRequest {
	
	let version: Int = 8
	public let type: IBRequestType = .contractData
	public let requestID: Int
	public let contract: IBContract
	
	/// Requests first datapoint date for specific dataset
	/// - Parameter requestID: request ID
	/// - Parameter contract: contract description
	/// - Returns: IBContractDetails event

	public init(requestID: Int, contract: IBContract) {
		self.requestID = requestID
		self.contract = contract
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBClientError.encodingError("Server value expected")
		}
		
		var container = encoder.unkeyedContainer()
		
		try container.encode( type);
		try container.encode( version )

		if serverVersion >= IBServerVersion.CONTRACT_DATA_CHAIN {
			try container.encode(requestID)
		}

		// send contract fields
		try container.encode(contract.id ?? 0)
		
		try container.encodeOptional( contract.symbol)
		
		try container.encode( contract.securitiesType)
		
		try container.encodeOptional( contract.expiration)
		
		try container.encodeOptional( contract.strike)
		
		try container.encodeOptional( contract.right)
		
		if (serverVersion >= 15) {
			try container.encodeOptional(contract.multiplier)
		}
				   
		if serverVersion >= IBServerVersion.PRIMARYEXCH{
			try container.encodeOptional(contract.exchange)
			try container.encodeOptional(contract.primaryExchange)
		} else if serverVersion >= IBServerVersion.LINKING {
			
			if let primaryExchange = contract.primaryExchange{
				if contract.exchange == .BEST || contract.exchange == .SMART {
					try container.encode(contract.exchange!.rawValue + ":" + primaryExchange.rawValue)
				}
			} else {
				try container.encodeOptional(contract.exchange);
			}
		}
				   
		try container.encodeOptional( contract.currency)
		
		try container.encodeOptional( contract.localSymbol)
		
		if serverVersion >= IBServerVersion.TRADING_CLASS {
			try container.encodeOptional(contract.tradingClass)
		}
		
		if serverVersion >= 31 {
			try container.encode(contract.isExpired)
		}
		
		if serverVersion >= IBServerVersion.SEC_ID_TYPE {
			try container.encodeOptional( contract.secId )
		}
		
		if serverVersion >= IBServerVersion.BOND_ISSUERID {
			try container.encodeOptional(contract.issuerID)
		}
		
		try container.encode("")
		

	}
	
}
