//
//  IBOrder+Contract.swift
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

/*

public extension IBClient {
	
	
	func searchSymbols(_ index: Int, nameOrSymbol text: String) throws {
		
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.matchingSymbols)
		try container.encode(index)
		try container.encode(text)
		try send(encoder: encoder)

	}
	
	func contractDetails(_ index: Int, contract: IBContract) throws {
		
		guard let serverVersion = serverVersion else {
			throw IBError.failedToSend("Failed to read server version")
		}
		
		let version: Int = 8
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.contractData)
		try container.encode(version)
		try container.encode(index)
		try container.encode(contract)
		try container.encodeOptional(contract.isExpired)
		try container.encodeOptional(contract.secId?.type)
		try container.encodeOptional(contract.secId?.value)
		try send(encoder: encoder)

	}
	
	enum FundamentalDataType: String, Codable {
		case overview   	= "ReportSnapshot"
		case summary    	= "ReportsFinSummary"
		case ratios     	= "ReportRatios"
		case statements 	= "ReportsFinStatements"
		case estimates  	= "RESC"
		case calendar   	= "CalendarReport"
	}

	
	func subscribeFundamentals(_ index: Int, contract: IBContract, reportType: FundamentalDataType) throws {
		
		let version: Int = 2
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.fundamentalData)
		try container.encode(version)
		try container.encode(index)
		try container.encode(contract.contractID)
		try container.encode(contract.symbol)
		try container.encode(contract.securitiesType)
		try container.encode(contract.exchange)
		try container.encode(contract.primaryExchange)
		try container.encode(contract.currency)
		try container.encode(contract.localSymbol)
		try container.encode(reportType)
		try send(encoder: encoder)

	}

	
	func unsubscribeFundamentals(_ index: Int) throws {
		
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelFundamentalData)
		try container.encode(version)
		try container.encode(index)
		try send(encoder: encoder)

	}
	
	
	/// Requests security definition option parameters for viewing a contract's option chain.
	/// - Parameters:
	/// - index: request index
	/// - underlying: underlying contract. symbol, type and contractID are required
	/// - exchange: exhange where options are traded. leaving empty will return all exchanges.
	
	
	func optionChain(_ index: Int, underlying contract: IBContract, exchange: IBExchange? = nil) throws {
				
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.optionParameters)
		try container.encode(index)
		try container.encode(contract.symbol)
		try container.encodeOptional(exchange)
		try container.encode(contract.securitiesType)
		try container.encodeOptional(contract.contractID)
		try send(encoder: encoder)

	}
	

	func requestScannerParameters() throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.scannerParameters)
		try container.encode(version)
		try send(encoder: encoder)
	}

	
	
}
*/
