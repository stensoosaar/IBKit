//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBHeadTimestampRequest: IBIndexedRequest, Hashable {
	
	public let type: IBRequestType = .headTimestamp
	public let requestID: Int
	public let contract: IBContract
	public let source: IBBarSource
	public let extendedTrading: Bool
	
	/// Requests first datapoint date for specific dataset
	/// - Parameter requestID: request ID
	/// - Parameter contract: contract description
	/// - Parameter source: data type to build a bar
	/// - Parameter extendedTrading: use only data from regular trading hours
	/// - Returns: IBFirstDatapoint event

	public init(requestID: Int, contract: IBContract, source: IBBarSource, extendedTrading: Bool = false) {
		self.requestID = requestID
		self.contract = contract
		self.source = source
		self.extendedTrading = extendedTrading
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(requestID)
		try container.encode(contract)
		try container.encode(contract.isExpired)
		try container.encode(extendedTrading.reverseValue())
		try container.encode(source)
		try container.encode(1)
	}
	
}
