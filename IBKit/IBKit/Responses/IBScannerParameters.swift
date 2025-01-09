//
//  IBScannerParameters.swift
//  IBKit
//
//  Created by Mike Holman on 14/12/2024.
//

import Foundation

public struct IBScannerParameters: IBResponse, IBEvent {
    
    public var version: Int
    public var content: String
    
    public init(from decoder: IBDecoder) throws {
        
        var container = try decoder.unkeyedContainer()
        version = try container.decode(Int.self)
        content = try container.decode(String.self)
    }
    
    public func xmlDocument() throws -> XMLDocument {
        return try XMLDocument(xmlString: content)
    }
    
}
