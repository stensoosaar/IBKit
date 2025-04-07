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
import Combine



public class IBDecoder {
	
	private var debugMode: Bool = false
		
	private var separator: String {
		return "\0"
	}
	
	fileprivate var buffer: [String] = []

	let serverVersion: Int?
	
	private var cursor: Int = 0
	
	public init(_ serverVersion: Int? = nil) {
		self.serverVersion = serverVersion
	}
	
	public enum DateEncodingStrategy: String, CaseIterable {
		
		///yyyyMM
		case futureExpirationFormat 	= "yyyyMM"

		///yyyy-MM-dd HH:mm:ss VV
		case optionExpirationFormat 	= "yyyy-MM-dd HH:mm:ss VV"

		///yyyyMMdd:HHmm
		case tradingHourFormat			= "yyyyMMdd:HHmm"

		///yyyyMMdd HH:mm:ss zzz
		case timeConditionFormat		= "yyyyMMdd HH:mm:ss zzz"
		
		///yyyyMMdd
		case eodPriceHistoryFormat 		= "yyyyMMdd"

		///yyyyMMdd-HH:mm:ss
		case defaultFormat              = "yyyyMMdd-HH:mm:ss"
        
		///yyyy-MM-dd HH:mm:ss.S
		case historicalNewsFormat       = "yyyy-MM-dd HH:mm:ss.S"

		public var dateFormatter: DateFormatter {
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			dateFormatter.dateFormat = self.rawValue
			dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
			return dateFormatter
		}
	}
		
	public var dateDecodingStrategy: DateEncodingStrategy = .defaultFormat
	
	public var description: String {
		return self.buffer.description
	}
	
	public func getCursor()->Int{
		return cursor
	}
	
	@discardableResult
	func next() throws -> String {
		try validateCursor()
		defer { cursor += 1 }
		return buffer[cursor]
	}
	
	func peek(offset: Int = 0) throws -> String {
		let targetIndex = cursor + offset
		try validateCursor(at: targetIndex)
		return buffer[targetIndex]
	}
	
	
	private func validateCursor(at position: Int? = nil) throws {
		let index = position ?? cursor
		guard !buffer.isEmpty else {
			throw IBError.decodingError("Buffer is empty, cannot proceed")
		}
		guard index >= 0, index < buffer.count else {
			throw IBError.decodingError("Invalid cursor position: \(index) (buffer count: \(buffer.count))")
		}
	}
	
	fileprivate func reset(){
		buffer = []
		cursor = 0
	}
	
}


extension IBDecoder {
	
	func unwrap(_ type: String.Type) throws -> String {
		let value = try next()
		return value
	}
	
	func unwrap(_ type: Int.Type) throws -> Int {
		let stringValue = try next()
		guard let value = Int(stringValue) else {
			throw IBError.decodingError("cant unwrap Int from \(stringValue), cursor: \(cursor), \(buffer)")
		}
		return value
	}
	
	func unwrap(_ type: Double.Type) throws -> Double {
		let stringValue = try next()
		guard let value = Double(stringValue) else {
			throw IBError.decodingError("cant unwrap double from \(stringValue), cursor: \(cursor)  \(buffer)")
		}
		return value
	}
	
	func unwrap(_ type: Date.Type) throws -> Date {
		
		let stringValue = try next().condensedWhitespace

		if stringValue.isEmpty {
			throw IBError.invalidValue("Empty value")
		}
		
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
		
        throw IBError.decodingError("cant unwrap date from \(stringValue) using format \(dateDecodingStrategy), cursor: \(cursor)  \(buffer)")
		
	}
	
	func unwrap(_ type: Bool.Type) throws -> Bool {
		switch try unwrap(Int.self) {
		case 0: return false
		case 1: return true
		case let x: throw IBError.decodingError("Bool out of range \(x), cursor: \(cursor)  \(buffer)")
		}
	}


	func decode<T:Decodable>(_ type: T.Type) throws -> T {
		
		if debugMode {
			print("Decoding \(type) at position: \(cursor)")
		}
		
		switch type {
			
		case is Int.Type:
			return try unwrap(Int.self) as! T
						
		case is Double.Type:
			return try unwrap(Double.self) as! T
			
		case is String.Type:
			return try unwrap(String.self) as! T
			
		case is Bool.Type:
			return try unwrap(Bool.self) as! T

		case is Date.Type:
			return try unwrap(Date.self) as! T
			
		case is any RawRepresentable.Type:
			return try T.init(from: self)

		case let decodable as IBDecodable.Type:
			return try decodable.init(from: self) as! T
			
		default:
			return try T.init(from: self)
		}
	}
	
}

extension IBDecoder: TopLevelDecoder {
	
	public typealias Input = Data

	public func decode<T:Decodable>(_ type: T.Type, from data: Input) throws -> T {
		guard let buffer = String(data: data, encoding: .ascii)?.components(separatedBy: separator).dropLast() else {
			throw IBError.decodingError("Failed to decode \(type) from data")
		}
		reset()
		self.buffer = Array(buffer)
		return try T.init(from: self)
	}
		
}


extension Publisher {
	func decode<Item, Coder>(type: Item.Type, decoder: Coder) -> Publishers.Decode<Self, Item, Coder>
		where Item: Decodable, Coder: TopLevelDecoder, Self.Output == Coder.Input{
		return Publishers.Decode(upstream: self, decoder: decoder)
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

		case is Decodable.Type:
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

