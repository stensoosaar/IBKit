//
//  UnkeyedContainer+optional.swift
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


extension UnkeyedEncodingContainer {
    
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


extension UnkeyedDecodingContainer {
    
    mutating func decodeOptional<T:Decodable>(_ type: T.Type) throws -> T? {
        
        switch type {
            
        case is Int.Type:
			do {
				let value = try self.decode(type)
				if (value as? Int) == 0 { return nil }
				if (value as? Int) == -1 { return nil }
				return value
			} catch {
				return nil
			}

        case is Double.Type:
			do {
				let value = try self.decode(type)
				if (value as? Double) == 0.0 { return nil }
				if (value as? Double) == -1 { return nil }
				if (value as? Double) == Double.greatestFiniteMagnitude { return nil }
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
