//
//  IBError.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.03.2025.
//


public struct IBError: Error , Sendable{
	public let code: Int
	public let message: String
	public let userInfo: String?
}


public extension IBError{
	
	static func alreadyConnected() -> IBError{
		return IBError(code: 501, message: "Already connected", userInfo: nil)
	}
	
	static func notConnected() -> IBError{
		return IBError(code: 504, message: "Not connected", userInfo: nil)
	}
	
	static func invalidValue(_ reason: String) -> IBError{
		return IBError(code: -1, message: reason, userInfo: nil)
	}

	static func encodingError(_ reason: String) -> IBError{
		return IBError(code: -1, message: reason, userInfo: nil)
	}

	static func decodingError(_ reason: String) -> IBError{
		return IBError(code: -1, message: reason, userInfo: nil)
	}

	static func failedToSend(_ reason: String) -> IBError{
		return IBError(code: -1, message: reason, userInfo: nil)
	}

	static func failedToRead(_ reason: String) -> IBError{
		return IBError(code: -1, message: reason, userInfo: nil)
	}

	static func connection(_ reason: String) -> IBError{
		return IBError(code: -1, message: reason, userInfo: nil)
	}

	static func unknown(_ reason: String) -> IBError{
		return IBError(code: -1, message: reason, userInfo: nil)
	}

}


extension IBError: IBDecodable{
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("Decoder didn't found a server version.")
		}
		
		var container = try decoder.unkeyedContainer()
		self.code = try container.decode(Int.self)
		self.message = try container.decode(String.self)
		self.userInfo = serverVersion >= IBServerVersion.ADVANCED_ORDER_REJECT ? try container.decode(String.self) : nil
		
	}
}
