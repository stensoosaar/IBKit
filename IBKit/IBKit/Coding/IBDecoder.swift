//
//  IBDecoder.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
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




public class IBDecoder {
	
	private var debugMode: Bool = false
		
	private var separator: String {
		return "\0"
	}
	
	fileprivate var buffer: [String] = []

	let serverVersion: Int?
	
	var cursor: Int = 0
	
	public init(_ serverVersion: Int? = nil) {
		self.serverVersion = serverVersion
	}
	
	public enum DateEncodingStrategy: String, CaseIterable {
		case futureExpirationFormat 	= "yyyyMM"
		case optionExpirationFormat 	= "yyyy-MM-dd HH:mm:ss VV"
		case tradingHourFormat			= "yyyyMMdd:HHmm"
		case timeConditionFormat		= "yyyyMMdd HH:mm:ss zzz"
		case eodPriceHistoryFormat 		= "yyyyMMdd"
		case defaultFormat 				= "yyyyMMdd-HH:mm:ss"

		public var dateFormatter: DateFormatter {
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			dateFormatter.dateFormat = self.rawValue
			dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
			return dateFormatter
		}
	}
		
	public var dateDecodingStrategy: DateEncodingStrategy = .defaultFormat

}


extension IBDecoder {
	
	func readString() throws -> String {
		guard cursor < buffer.count else {
			throw IBClientError.decodingError("Premature End Of Data")
		}
		let value = buffer[cursor]
		cursor += 1
		return value
	}
	
	func unwrap(_ type: Bool.Type) throws -> Bool {
		switch try unwrap(Int.self) {
		case 0: return false
		case 1: return true
		case let x: throw IBClientError.decodingError("Bool out of range \(x), cursor: \(cursor)  \(buffer)")
		}
	}
	
	func unwrap(_ type: Int.Type) throws -> Int {
		let stringValue = try readString()
		guard let value = Int(stringValue) else {
			throw IBClientError.decodingError("cant unwrap Int from \(stringValue), cursor: \(cursor), \(buffer)")
		}
		return value
	}
	
	func unwrap(_ type: Double.Type) throws -> Double {
		let stringValue = try readString()
		guard let value = Double(stringValue) else {
			throw IBClientError.decodingError("cant unwrap double from \(stringValue), cursor: \(cursor)  \(buffer)")
		}
		return value
	}
	
	func unwrap(_ type: Date.Type) throws -> Date {
		
		let stringValue = try readString().condensedWhitespace
		
		if let date = dateDecodingStrategy.dateFormatter.date(from: stringValue) {
			return date
		}
		
		for strategy in DateEncodingStrategy.allCases.reversed() {
			if let date = strategy.dateFormatter.date(from: stringValue) {
				return date
			}
		}
		
		if let timestamp = Double(stringValue) {
			return Date(timeIntervalSince1970: timestamp)
		}
		
		throw IBClientError.decodingError("cant unwrap date from \(stringValue), cursor: \(cursor)  \(buffer)")
		
	}


	func decode<T:Decodable>(_ type: T.Type) throws -> T {
		
		if debugMode {
			print("decoding \(type)")
		}
		
		switch type {
			
		case is Int.Type:
			return try unwrap(Int.self) as! T
						
		case is Double.Type:
			return try unwrap(Double.self) as! T
			
		case is String.Type:
			return try readString() as! T
			
		case is Bool.Type:
			return try unwrap(Bool.self) as! T

		case let decodable as IBDecodable.Type:
			return try decodable.init(from: self) as! T
			
		case is Date.Type:
			return try unwrap(Date.self) as! T
			
		case is any RawRepresentable.Type:
			return try T.init(from: self)

		default:
			return try T.init(from: self)
		}
	}
	
}

extension IBDecoder {
	
	func decode<T:Decodable>(_ type: T.Type, from data: Data) throws -> T {
		guard let buffer = String(data:data, encoding: .ascii)?.components(separatedBy: separator).dropLast() else {
			throw IBClientError.decodingError("\(type) not conforming ecodable protocol")
		}
		self.buffer = Array(buffer)
		return try T.init(from: self)
	}
	
}


extension IBDecoder: Decoder {
	
	public var codingPath: [CodingKey] { return [] }
	
	public var userInfo: [CodingUserInfoKey : Any] { return [:] }
	
	public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
		return KeyedDecodingContainer(KeyedContainer<Key>(decoder: self))
	}
	
	public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		return UnkeyedContainer(decoder: self)
	}
	
	public func singleValueContainer() throws -> SingleValueDecodingContainer {
		return UnkeyedContainer(decoder: self)
	}
	
	private struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
		
		var decoder: IBDecoder
		
		var codingPath: [CodingKey] { return [] }
		
		var allKeys: [Key] { return [] }
		
		func contains(_ key: Key) -> Bool {
			return true
		}
		
		func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
			return try decoder.decode(T.self)
		}
		
		func decodeNil(forKey key: Key) throws -> Bool {
			return true
		}
		
		func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
			return try decoder.container(keyedBy: type)
		}
		
		func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
			return try decoder.unkeyedContainer()
		}
		
		func superDecoder() throws -> Decoder {
			return decoder
		}
		
		func superDecoder(forKey key: Key) throws -> Decoder {
			return decoder
		}
	}
	
	private struct UnkeyedContainer: UnkeyedDecodingContainer, SingleValueDecodingContainer {
		
		var decoder: IBDecoder
		
		var codingPath: [CodingKey] { return [] }
		
		var count: Int? { return nil }
		
		var currentIndex: Int { return 0 }

		var isAtEnd: Bool { return false }
		
		func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
			return try decoder.decode(type)
		}
		
		func decodeNil() -> Bool {
			return true
		}
		
		func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
			return try decoder.container(keyedBy: type)
		}
		
		func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
			return self
		}
		
		func superDecoder() throws -> Decoder {
			return decoder
		}
	}
}


extension UnkeyedDecodingContainer {
	
	mutating func decodeOptional<T:Decodable>(_ type: T.Type) throws -> T? {
		
		switch type {
			
		case is Int.Type:
			do {
				let value = try self.decode(type)
				if (value as? Int) == Int.max 	{return nil}
				if (value as? Int) == 0 		{ return nil }
				if (value as? Int) == -1 		{ return nil }
				return value
			} catch {
				return nil
			}

		case is Double.Type:
			do {
				let value = try self.decode(type)
				if (value as? Double) == Double.greatestFiniteMagnitude { return nil }
				if (value as? Double) == 0.0 { return nil }
				if (value as? Double) == -1 { return nil }
				return value
			} catch {
				return nil
			}

		case is String.Type:
			do {
				let value = try self.decode(type)
				if (value as? String) == "" { return nil }
				return value
			} catch {
				return nil
			}

		case is Date.Type:
			do {
				return try self.decode(type)
			} catch {
				return nil
			}

		case is IBDecodable.Type:
			do {
				return try self.decode(type)
			} catch {
				return nil
			}

		case is any RawRepresentable.Type:
			do {
				return try self.decode(type)
			} catch {
				return nil
			}

		default:
			do {
				let value = try self.decode(type)
				return value
			} catch {
				return nil
			}
		}
		
		
	}
	
}
