//
//  IBError.swift
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


public enum IBClientError: Error {
	case invalidValue(_ reason: String)
	case encodingError(_ reason: String)
	case decodingError(_ reason: String)
	case failedToSend(_ reason: String)
	case failedToRead(_ reason: String)
	case connectionError(_ reason: String)
}


extension IBClientError: LocalizedError {
	
	public var errorDescription: String? {
		switch self {
		case .invalidValue(let reason):			return "Invalid value: \(reason)"
		case .encodingError(let reason):     	return "Encoding error: \(reason)"
		case .decodingError(let reason):     	return "Decoding error: \(reason)"
		case .failedToSend(let reason):			return "Failed to send: \(reason)"
		case .failedToRead(let reason):			return "Failed to read: \(reason)"
		case .connectionError(let reason):		return "Connection error: \(reason)"
		}
	}
	
}



