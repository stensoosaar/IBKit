//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBFinancialReport: Decodable, IBIndexedEvent {
	
	public var requestID: Int

	public var xml: XMLDocument
	
	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		let content = try container.decode(String.self)
		xml = try XMLDocument(xmlString: content)
	}
	
}
