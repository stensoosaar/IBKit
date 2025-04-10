//
//  IBClient.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
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


public struct IBError: Error, Sendable{
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
			throw IBError.failedToRead("Server version")
		}
		
		var container = try decoder.unkeyedContainer()
		self.code = try container.decode(Int.self)
		self.message = try container.decode(String.self)
		self.userInfo = serverVersion >= IBServerVersion.ADVANCED_ORDER_REJECT ? try container.decode(String.self) : nil
		
	}
}
