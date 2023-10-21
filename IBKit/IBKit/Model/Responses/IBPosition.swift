//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBPosition: Decodable, IBEvent {
	  
	public var accountName: String
	public var contract: IBContract
	public var position: Double = 0
	public var avgCost: Double = 0
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.accountName = try container.decode(String.self)
		self.contract = try container.decode(IBContract.self)
		self.position = try container.decode(Double.self)
		self.avgCost = try container.decode(Double.self)
		
	}
}


public struct IBPositionEnd: Decodable, IBEvent {
	
	public var reqId: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.reqId = try container.decode(Int.self)
	}
	
}



public struct IBPositionMulti: Decodable, IBIndexedEvent {

	public var requestID: Int
	public var account: String
	public var modelCode: String
	public var contract: IBContract
	public var position: Double
	public var avgCost: Double

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.account = try container.decode(String.self)
		self.contract = try container.decode(IBContract.self)
		self.position = try container.decode(Double.self)
		self.avgCost = try container.decode(Double.self)
		self.modelCode = try container.decode(String.self)
				
	}
}


public struct IBPositionMultiEnd: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
	}
	
}
 
