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

    public var buffer: [String] = []

    fileprivate var cursor: Int = 0

    fileprivate let separator: String = "\0"
	
	public lazy var dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_US_POSIX")
		df.dateFormat = "yyyyMMdd"
		return df
	}()
	
	public var serverVersion: Int?
	
	public var debugMode: Bool = false

	public init(serverVersion: Int?) {
		self.serverVersion = serverVersion
	}
    
	public func setDateFormat(format: String) {
		dateFormatter.dateFormat = format
	}
	
}


public extension IBDecoder {
    
    enum Error: Swift.Error {
        case prematureEndOfData
        case typeNotConformingToIBDecodable(IBDecodable.Type)
        case typeNotConformingToDecodable(Any.Type)
        case decodingError(message: String)
    }
    
}

public extension IBDecoder {
    
    func decode<T:Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard let buffer = String(data:data, encoding: .ascii)?.components(separatedBy: separator).dropLast() else {
            throw Error.typeNotConformingToDecodable(type)
        }
        self.buffer = Array(buffer)
        return try T.init(from: self)
    }
    
}


public extension IBDecoder {
    
    func readString() throws -> String {
        guard cursor < buffer.count else {throw Error.prematureEndOfData}
        let value = buffer[cursor]
        cursor += 1
		if debugMode { print(value) }
        return value
    }
    
    func unwrap(_ type: Bool.Type) throws -> Bool {
        switch try unwrap(Int.self) {
        case 0: return false
        case 1: return true
        case let x: throw Error.decodingError(message: "Bool out of range \(x), cursor: \(cursor)")
        }
    }
    
    func unwrap(_ type: Int.Type) throws -> Int {
        let stringValue = try readString()
        guard let value = Int(stringValue) else {
            throw Error.decodingError(message: "cant unwrap Int from \(stringValue), cursor: \(cursor)")
        }
        return value
    }
    
    func unwrap(_ type: Double.Type) throws -> Double {
        let stringValue = try readString()
        guard let value = Double(stringValue) else {
            throw Error.decodingError(message: "cant unwrap double from \(stringValue), cursor: \(cursor)")
        }
        return value
    }
    
    func unwrap(_ type: Date.Type) throws -> Date {
		
        let stringValue = try readString().condensedWhitespace
		
		if stringValue == "" {
			throw Error.decodingError(message: "cant unwrap date from \(stringValue), cursor: \(cursor)")
		}
 
		if let date = dateFormatter.date(from: stringValue) {
			return date
		}
		
		switch stringValue.count {
			case 6:
				dateFormatter.dateFormat = "yyyyMM"
			
			case 8:
				dateFormatter.dateFormat = "yyyyMMdd"
			
			case 21:
				dateFormatter.dateFormat = stringValue.contains("-") ? "yyyyMMdd-HH:mm:ss zzz" : "yyyyMMdd HH:mm:ss zzz"
			
			case 17:
				dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
			
			case 10:
				dateFormatter.dateFormat = "yyyy-MM-dd"
			
			case 13:
				dateFormatter.dateFormat = "yyyyMMdd:HHmm"
			
			default:
				
				if let timestamp = Double(stringValue) {
					return Date(timeIntervalSince1970: timestamp)
				} else {
					throw Error.decodingError(message: "cant unwrap double from \(stringValue), cursor: \(cursor)")
				}
		}

		guard let value = dateFormatter.date(from: stringValue) else {
			throw Error.decodingError(message: "cant unwrap double from \(stringValue), cursor: \(cursor)")
		}
		
		return value

		
	}

    
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        
		if debugMode { print(type) }
		
        switch type {
            
        case is Int.Type:
            return try unwrap(Int.self) as! T
                        
        case is Double.Type:
            return try unwrap(Double.self) as! T
            
        case is String.Type:
            return try readString() as! T
            
        case is Bool.Type:
            return try unwrap(Bool.self) as! T

        case is Date.Type:
            return try unwrap(Date.self) as! T

        case let decodable as IBDecodable.Type:
            return try decodable.init(from: self) as! T
            
        case is any RawRepresentable.Type:
            return try T.init(from: self)

        default:
            return try T.init(from: self)
        }
        
    }
    
}


