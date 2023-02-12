//
//  IBCondition.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		Redistributions of source code must retain the above copyright notice,
//		this list of conditions and the following disclaimer.
//
//		Redistributions in binary form must reproduce the above copyright
//		notice, this list of conditions and the following disclaimer in the
//		documentation and/or other materials provided with the distribution.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//	POSSIBILITY OF SUCH DAMAGE.
//



import Foundation


public struct IBCondition {
	
	enum Connector: String, AnyCondition, CustomStringConvertible, Codable {
		case and    = "a"
		case or     = "o"
		
		var description: String {
			return self == .and ? "AND" : "OR"
		}
		
	}
	
	public var buffer: [AnyCondition] = []
	
	public init(_ condition: AnyCondition? = nil){
		if let condition = condition {
			self.and(condition)
		}
	}
	
	
	public mutating func and(_  condition: AnyCondition){
		buffer.append(Connector.and)
		buffer.append(condition)
	}
	
	public mutating func or(_  condition: AnyCondition){
		buffer.append(Connector.or)
		buffer.append(condition)
	}

	
	public var count:Int{
		return buffer.count
	}
    
}


extension IBCondition: Encodable {
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		for element in buffer {
			try container.encode(Connector.and)
			if let element = element as? IBPriceCondition{
				try container.encode(element)
			} else if let element = element as? IBVolumeCondition {
				try container.encode(element)
			} else if let element = element as? IBChangePerCentCondition {
				try container.encode(element)
			} else if let element = element as? IBExecutionCondition {
				try container.encode(element)
			} else if let element = element as? IBTimeCondition {
				try container.encode(element)
			} else if let element = element as? IBMarginCondition {
				try container.encode(element)
			} else if let element = element as? Connector {
				try container.encode(element)
			}
			
		}
	}
	
}
