//
//  File.swift
//  
//
//  Created by Sten Soosaar on 20.04.2024.
//

import Foundation

public struct IBManagedAccountsRequest: IBRequest{
	
	public let version: Int = 1
	public let type: IBRequestType = .managedAccounts
	
	public init(){}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(version)
	}
	
}


