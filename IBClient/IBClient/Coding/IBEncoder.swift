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



public class IBEncoder {
	
	fileprivate var debugMode: Bool = false
	
	private var separator: String {
		return "\0"
	}
	
	fileprivate var buffer: [String] = []
	
	let serverVersion: Int?
	
	public init(_ serverVersion: Int? = nil) {
		self.serverVersion = serverVersion
	}
	
	var description: String {
		return buffer.joined(separator: separator)+separator
	}
	
	var data: Data {
		var response = Data()
		if let content = description.data(using: .ascii) {
			response += content
		}
		return response
	}
	
	public enum DateEncodingStrategy: String {
		case futureExpirationFormat 	= "yyyyMM"
		case optionExpirationFormat 	= "yyyy-MM-dd HH:mm:ss VV"
		case tradingHourFormat			= "yyyyMMdd:HHmm"
		case timeConditionFormat		= "yyyyMMdd HH:mm:ss zzz"
		case defaultFormat 				= "yyyyMMdd-HH:mm:ss"

		public var dateFormatter: DateFormatter {
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			dateFormatter.dateFormat = self.rawValue
			dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
			return dateFormatter
		}
	}
		
	public var dateEncodingStrategy: DateEncodingStrategy = .defaultFormat

}


extension IBEncoder {
	
	func wrap(_ value: String) throws {
		buffer.append(value)
	}

	func wrap(_ value: Bool) throws {
		buffer.append(value ? "1" : "0")
	}

	func wrap(_ value: Double) throws {
		buffer.append(String(format: "%.2f", value))
	}
	
	func wrap(_ value: Int) throws {
		buffer.append(String(format: "%d", value))
	}

	func wrap(_ value: Int64) throws {
		buffer.append(String(format: "%ld", value))
	}
	
	func wrap(_ value: Float) throws {
		buffer.append(String(format: "%.2f", value))
	}
	
	func wrap(_ value: any RawRepresentable) throws {
		guard let rawValue = value.rawValue as? Encodable else {
			throw IBError.encodingError("enum raw value is not encodable type")
		}
		try encode(rawValue)
	}
	
	func wrap(_ value: Date) throws {
		let string = dateEncodingStrategy.dateFormatter.string(from: value)
		try encode(string)
	}
	
	func wrapNil(){
		buffer.append("")
	}

	func encode(_ encodable: Encodable) throws {
		
		if debugMode{
			print("encoding \(encodable)")
		}

		switch encodable {
		case let value as Int:						try wrap(Int64(value))
		case let value as Float:					try wrap(value)
		case let value as Double:					try wrap(value)
		case let value as Bool:						try wrap(value)
		case let value as String:					try wrap(value)
		case let value as Date:						try wrap(value)
		case let value as any RawRepresentable: 	try wrap(value)
		case let value as IBEncodable:				try value.encode(to: self)
		default:
			throw IBError.encodingError("no conforming \(encodable) type to IBEncodable")
			
		}
	}
	
}



public extension UnkeyedEncodingContainer {
	
	mutating func encodeOptional<T:Encodable>(_ value:T?) throws {
				
		switch value {
		case .none:
			if type(of: value) == Int?.self {
				try encode("")
			} else if type(of: value) == Double?.self {
				try encode("")
			} else if type(of: value) == Date?.self {
				try encode("")
			} else {
				try encode("")
			}
			
		case .some(let wrapped):
			try encode(wrapped)
		}
	}
	
}


