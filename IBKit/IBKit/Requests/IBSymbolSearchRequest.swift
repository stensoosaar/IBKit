//
//  File.swift
//  
//
//  Created by Sten Soosaar on 23.04.2024.
//

import Foundation


public struct IBSymbolSearchRequest: IBIndexedRequest, Hashable {
	
	public let type: IBRequestType = .matchingSymbols
	public let requestID: Int
	public let searchText: String
	
	public init(requestID: Int, text: String) {
		self.requestID = requestID
		self.searchText = text
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(type)
		try container.encode(requestID)
		try container.encode(searchText)
	}
	
}
