//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBServerError: IBIndexedEvent, Decodable {
	public let requestID: Int
	public let errorCode: Int
	public let errorString: String
	public let userInfo: String?
	
	public init(from decoder: Decoder) throws {
		
		guard let decoder = decoder as? IBDecoder, let serverVersion = decoder.serverVersion else {
			throw IBError.codingError("Decoder didn't found a server version. Check the connection!")
		}
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.errorCode = try container.decode(Int.self)
		self.errorString = try container.decode(String.self)
		self.userInfo = serverVersion >= IBServerVersion.ADVANCED_ORDER_REJECT ? try container.decode(String.self) : nil
		
	}
	
}
