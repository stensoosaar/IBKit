//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation

public struct IBAccountSummary: Decodable,IBIndexedEvent {
	
	public var requestID: Int
	public var accountName: String
	public var key: IBAccountKey
	public var value: Double
	public var userInfo: String
	
	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.key = try container.decode(IBAccountKey.self)
		
		if key == .accountType {
			self.value = 0
			self.userInfo = try container.decode(String.self)
		} else {
			self.value = try container.decode(Double.self)
			self.userInfo = try container.decode(String.self)
		}
		
	}

	
}


public struct IBAccountSummaryEnd: Decodable,IBIndexedEvent {
	
	public var requestID: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
	}

	
}


public struct IBAccountSummaryMulti: Decodable, IBIndexedEvent {

	public var requestID: Int
	public var accountName: String
	public var modelCode:String
	public var key: String
	public var value: Double
	public var currency: String
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.modelCode = try container.decode(String.self)
		self.key = try container.decode(String.self)
		self.value = try container.decode(Double.self)
		self.currency = try container.decode(String.self)
	}

}


public struct IBAccountSummaryMultiEnd: Decodable, IBIndexedEvent {
	
	public var requestID: Int

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
	}

}
