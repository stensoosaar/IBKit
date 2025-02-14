//
//  IBTradingHour.swift
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


public struct IBTradingHour: Codable, Sendable {
	
	public var open: Date
	
	public var close: Date
	
	public enum Status: String, Codable, CustomStringConvertible, Sendable {
		case closed 	= "CLOSED"
		case open 		= "OPEN"
		case halted 	= "HALTED"
		
		public var description: String{
			return self.rawValue
		}
		
	}
	
	public var status: Status
	
	init(string: String, zone: String) {
		
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(deprecatedName: zone)

		if string.contains("-"){
			let comps = string.components(separatedBy: "-")
			formatter.dateFormat = "yyyyMMdd:HHmm"
			status = .open
			open = formatter.date(from: comps[0]) ?? Date.distantPast
			close = formatter.date(from: comps[1]) ?? Date.distantPast
		} else {
			formatter.dateFormat = "yyyyMMdd"
			let comps = string.components(separatedBy: ":")
			status = Status(rawValue: comps[1]) ?? .closed
			open = formatter.date(from: comps[0]) ?? Date.distantPast
			close = formatter.date(from: comps[0]) ?? Date.distantPast
		}
		
	}

}
