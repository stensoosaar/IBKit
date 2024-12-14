//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation



public struct IBFundamantalsRequest: IBIndexedRequest, Hashable, Equatable {

	public let version: Int = 2
	public var type: IBRequestType = .fundamentalData
	public var requestID: Int
	public let contract: IBContract

	public enum ReportType: String, Codable {
		case overview   	= "ReportSnapshot"
		case summary    	= "ReportsFinSummary"
		case ratios     	= "ReportRatios"
		case statements 	= "ReportsFinStatements"
		case estimates  	= "RESC"
		case calendar   	= "CalendarReport"
	}

	public let reportType: ReportType
	
	public init(requestID: Int, contract: IBContract, reportType: ReportType) {
		self.requestID = requestID
		self.contract = contract
		self.reportType = reportType
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(contract.id ?? 0)
		try container.encode(contract.symbol)
		try container.encode(contract.securitiesType)
		try container.encode(contract.exchange)
		try container.encodeOptional(contract.primaryExchange)
		try container.encode(contract.currency)
		try container.encodeOptional(contract.localSymbol)
		try container.encode(reportType)

	}
	

}



public struct IBFundamantalsCancellationRequest: IBIndexedRequest {
	
	let version: Int = 1
	public var type: IBRequestType = .cancelFundamentalData
	public var requestID: Int
	
	init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelFundamentalData)
		try container.encode(version)
		try container.encode(requestID)
	}
}




