//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBServerError: IBResponse, IBIndexedEvent, Error {
	public let requestID: Int
	public let code: Int
	public let message: String
	public let userInfo: String?
	
	public init(requestID: Int, code: Int, message: String, userInfo: String? = nil){
		self.requestID = requestID
		self.code = code
		self.message = message
		self.userInfo = userInfo
	}
		
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBClientError.decodingError("Decoder didn't found a server version.")
		}
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.code = try container.decode(Int.self)
		self.message = try container.decode(String.self)
		self.userInfo = serverVersion >= IBServerVersion.ADVANCED_ORDER_REJECT ? try container.decode(String.self) : nil
		
	}
	
}
