//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation



public struct IBAccountSummaryRequest: IBIndexedRequest, Hashable {
	
	let version: Int = 1
	public let type: IBRequestType = .accountSummary
	public let requestID: Int
	public let tags: [IBAccountKey]
	public let group: String
	
	public init(requestID: Int, tags: [IBAccountKey], group: String) {
		self.requestID = requestID
		self.tags = tags
		self.group = group
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(group)
		let tagValues = tags.map({$0.rawValue}).joined(separator: ",")
		try container.encode(tagValues)
	}
	
}


public struct IBCancelAccountSummaryRequest: IBIndexedRequest{
	
	public let type: IBRequestType = .cancelAccountSummary
	public let requestID: Int
					  
	public init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelAccountSummary)
		try container.encode(requestID)
	}
	
	
}



public struct IBAccountSummaryMultiRequest: IBIndexedRequest{

	let version: Int = 1
	public var type: IBRequestType = .accountUpdatesMulti
	public var requestID: Int
	public var accountName: String
	public var ledger: Bool
	public var modelCode:String?
	
	/// Subscribes account summary.
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter tags: Array of IBAccountKeys to specify what to subscribe. As a default, all keys will be subscribed
	/// - Parameter accountGroup:
	/// - Returns: AccountSummary event per specified tag and will be updated once per 3 minutes

	public init(requestID: Int, accountName: String, ledger: Bool = true, model: String? = nil) {
		self.requestID = requestID
		self.accountName = accountName
		self.ledger = ledger
		self.modelCode = model
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
		try container.encode(accountName)
		try container.encodeOptional(modelCode)
		try container.encode(ledger)
	}
	
}


public struct IBAccountSummaryMultiCancellationRequest: IBIndexedRequest{

	let version: Int = 1
	public var type: IBRequestType = .cancelAccountUpdatesMulti
	public var requestID: Int
	
	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event

	public init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
		try container.encode(requestID)
	}
	
}
