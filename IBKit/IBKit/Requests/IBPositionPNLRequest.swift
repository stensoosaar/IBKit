//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBPositionPNLRequest: IBIndexedRequest, Hashable {
	
	public let type: IBRequestType = .singlePNL
	public let requestID: Int
	public let accountName: String
	public let contractID: Int
	public let modelCode: [String]?
	
	/// Requests position PNL
	/// - Parameter requestID: request ID
	/// - Parameter accountName: contract description
	/// - Parameter contractID: data type to build a bar
	/// - Parameter modelCode: use only data from regular trading hours
	/// - Returns: IBPositionPNL event

	public init(requestID: Int, accountName: String, contractID: Int, modelCode: [String]? = nil) {
		self.requestID = requestID
		self.accountName = accountName
		self.contractID = contractID
		self.modelCode = modelCode
	}
	
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(requestID)
		try container.encode(accountName)
		if let code = modelCode{
			try container.encode(code.joined(separator: ","))
		} else {
			try container.encodeOptional(modelCode)
		}
		try container.encode(contractID)

	}
	
}
