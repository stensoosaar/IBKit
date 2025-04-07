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


public struct IBContractDetailsRequest: IBRequest, Identifiable {
	
	public let id: Int
	public let type: IBRequestType = .contractData
	public let contract: IBContract
	private let version: Int = 8

	/// Requests first datapoint date for specific dataset
	/// - Parameter requestID: request ID
	/// - Parameter contract: contract description
	/// - Returns: IBContractDetails event

	public init(id: Int, contract: IBContract) {
		self.id = id
		self.contract = contract
	}
	
	public func encode(to encoder: IBEncoder) throws {
		
		guard let serverVersion = encoder.serverVersion else {
			throw IBError.encodingError("Server value expected")
		}
		
		var container = encoder.unkeyedContainer()
		
		try container.encode( type);
		try container.encode( version )

		if serverVersion >= IBServerVersion.CONTRACT_DATA_CHAIN {
			try container.encode(id)
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
