//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation


public struct IBAccountUpdateRequest: IBRequest, Hashable {
	
	public let version: Int = 2
	public let type: IBRequestType = .managedAccounts
	public let accountName: String
	public let subscribe: Bool

	public init(accountName: String, subscribe: Bool){
		self.accountName = accountName
		self.subscribe = subscribe
	}
	
	public static func start(_ accountName: String) -> IBAccountUpdateRequest {
		return IBAccountUpdateRequest(accountName: accountName, subscribe: true)
	}
	
	public static func stop(_ accountName: String) -> IBAccountUpdateRequest {
		return IBAccountUpdateRequest(accountName: accountName, subscribe: false)
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.accountData)
		try container.encode(version)
		try container.encode(subscribe)
		try container.encode(accountName)
	}
	
}


