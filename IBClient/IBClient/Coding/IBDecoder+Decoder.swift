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
		
		func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey>
		where NestedKey : CodingKey {
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

