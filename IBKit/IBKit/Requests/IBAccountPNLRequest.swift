//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBAccountPNLRequest: IBIndexedRequest{
	
	public let requestID: Int
	public var type: IBRequestType = .PNL
	public var accountName: String
	public var model: [String]?
	
	public init(requestID: Int, accountName: String, model: [String]? = nil) {
		self.requestID = requestID
		self.accountName = accountName
		self.model = model
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.PNL)
		try container.encode(requestID)
		try container.encode(accountName)
		if let value = model {
			try container.encode(value.joined(separator: ","))
		} else {
			try container.encode("")
		}
	}
	
}

public struct IBAccountPNLCancellation: IBIndexedRequest{
	
	public let requestID: Int
	public var type: IBRequestType = .cancelPNL
	
	public init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelPNL)
		try container.encode(requestID)
	}
	
}

