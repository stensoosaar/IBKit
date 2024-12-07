//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBFinancialReport: IBResponse, IBIndexedEvent {
	
	public var requestID: Int

	public var content: String
	
	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		content = try container.decode(String.self)
	}
	
	func xmlDocument() throws -> XMLDocument {
		return try XMLDocument(xmlString: content)
	}
	
}
