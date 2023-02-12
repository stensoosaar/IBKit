//
//  PositionEvents.swift
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




public struct IBPosition: Decodable, IBAccountEvent {
	  
	public var account: String
	public var contract: IBContract
	public var position: Double = 0
	public var avgCost: Double = 0
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.account = try container.decode(String.self)
		self.contract = try container.decode(IBContract.self)
		self.position = try container.decode(Double.self)
		self.avgCost = try container.decode(Double.self)
		
	}
}


public struct IBPositionEnd: Decodable, IBAccountEvent {
	
	public var reqId: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.reqId = try container.decode(Int.self)
	}
	
}

 
public struct IBPositionMulti: Decodable, IBAccountEvent {

	public var requestId: Int
	public var account: String
	public var modelCode: String
	public var contract: IBContract
	public var position: Double
	public var avgCost: Double

	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestId = try container.decode(Int.self)
		self.account = try container.decode(String.self)
		self.contract = try container.decode(IBContract.self)
		self.position = try container.decode(Double.self)
		self.avgCost = try container.decode(Double.self)
		self.modelCode = try container.decode(String.self)
				
	}
}


public struct IBPositionMultiEnd: Decodable, IBAccountEvent {
	
	public var requestId: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestId = try container.decode(Int.self)
	}
	
}
 

public struct IBPositionPNL: Decodable, IBAccountEvent {
	
	public var requestId: Int
	public var contractID: Int?
	public var account: String?
	public var position: Double
	public var daily: Double
	public var unrealized: Double
	public var realized: Double
	public var value: Double

	
	public init(from decoder: Decoder) throws {
	
		var container = try decoder.unkeyedContainer()
		requestId = try container.decode(Int.self)
		position = try container.decode(Double.self)
		daily = try container.decode(Double.self)
		unrealized = try container.decode(Double.self)
		realized = try container.decode(Double.self)
		value = try container.decode(Double.self)
						
	}
}
