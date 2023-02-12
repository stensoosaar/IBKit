//
//  IBEncoder.swift
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



public class IBEncoder {
    
    public var buffer: [String] = []
    
    fileprivate var separator: String = "\0"
    
	var dateFormatter: DateFormatter
	
	public var serverVersion: Int?

	public init(serverVersion: Int?) {
		
		self.serverVersion = serverVersion
		
		dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		
	}
	
	public func setDateFormat(format: String) {
		dateFormatter.dateFormat = format
	}
    
    public var description: String {
        return buffer.joined(separator: separator)+separator
    }
    
    public var length: Int{
        return description.count
    }
    
    public var data: Data {
        var response = Data()
        if let content = description.data(using: .ascii) {
            response += content
        }
        return response
    }
    
    public var dataWithLength: Data {
        var response = Data()
        response += Data(length.toBytes(size: 4))
        if let content = description.data(using: .utf8, allowLossyConversion: false) {
            response += content
        }
        return response
    }
    
    public func encode<T:Encodable>(_ value:T) throws {
        buffer.append("\(value)")
    }
    
}


public extension IBEncoder {
    
	static func encode(_ value: Encodable, serverVersion: Int) throws -> Data {
        let encoder = IBEncoder(serverVersion: serverVersion)
        try value.encode(to: encoder)
        return encoder.data
    }
    
    func wrap(_ value: Bool) throws {
        buffer.append(value == true ? "1" : "0")
    }
    
    func wrap(_ value: Double) throws {
        buffer.append( String(format:"%.2f", value ))
    }
    
    func wrap(_ value: Int) throws {
        buffer.append( String(format:"%d", value ))
    }
    
    func wrap(_ value: Int64) throws {
        buffer.append( String(format:"%ld", value ))
    }
    
    func wrap(_ value: String) throws {
        buffer.append( value )
    }
    
    func wrap(_ value: Character) throws {
       buffer.append( String(value) )
    }
    
    func wrap(_ value: Date) throws {
		buffer.append(self.dateFormatter.string(from: value))
    }
    
    func encode(_ encodable: Encodable) throws {
		                        
        switch encodable {
            
        case let value as String:
            try wrap(value)
            
        case let value as Int:
            try wrap(value)
            
        case let value as Int64:
            try wrap(value)
            
        case let value as Double:
            try wrap(value)
            
        case let value as Bool:
            try wrap(value)
            
        case let value as Date:
            try wrap(value)
            
        case let value as IBEncodable:
            try value.encode(to: self)
            
        case let value as (any RawRepresentable):
            if let rawValue = value.rawValue as? Encodable {
                try encode(rawValue)
            }

        default:
            try encodable.encode(to: self)
        }
        
    }
    
}


public extension IBEncoder {
    
    enum Error: Swift.Error {
        case typeNotConformingToIBEncodable(Encodable.Type)
        case typeNotConformingToEncodable(Any.Type)
    }
    
}

