//
//  IBDuration.swift
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


public struct IBDuration: Codable, CustomStringConvertible {
	
	public enum Unit: TimeInterval, Codable, CustomStringConvertible, CaseIterable {
		case second 		= 1
		case day 			= 86400
		case week 			= 604800
		case month 			= 2678400
		case year			= 31536000
		
		public var description: String {
			return self.longName.prefix(1).description
		}
		
		public var longName: String {
			switch self {
			case .second: 	return "Seconds"
			case .day: 		return "Days"
			case .week: 	return "Weeks"
			case .month: 	return "Months"
			case .year:		return "Years"
			}
		}
		
	}
	
	var size: Int
	
	var unit: Unit
	
	var endDate: Date?
		
	public init(_ size: Int, unit: Unit, endDate: Date? = nil){
		self.size = size
		self.unit = unit
		self.endDate = endDate
	}
	
	public init(start: Date, end: Date? = nil){
		
		let interval = (end ?? Date()).timeIntervalSince1970 - start.timeIntervalSince1970
		
		if let endDate = end { self.endDate = endDate }
		
		switch interval {
				
			case 0..<86400:
				self.size = Int(interval)
				self.unit = .second
			case 86400..<2592000:
				self.size = Int(interval/86400)
				self.unit = .day
			case 2592000..<31556926:
				self.size = Int(interval/2592000)
				self.unit = .year
			default:
				self.size = Int(interval/31556926)
				self.unit = .year
		}

	}
	
	
	
	
	/// Create continously updating date interval
	/// - Parameter size: size of lookback period
	/// - Parameter unit: calendar unit of lookback period
	 
	public static func continuousUpdates(_ size: Int, unit: Unit) -> IBDuration {
		return IBDuration(size, unit: unit)
	}
	
	/// Create date interval until specified end date
	/// - Parameter size: size of lookback period
	/// - Parameter unit: calendar unit of lookback period
	/// - Parameter endDate: date interval's end date
	
	public static func lookback(_ size: Int, unit: Unit, until: Date = Date()) -> IBDuration {
		return IBDuration(size, unit: unit, endDate: until)
	}

	
	public var description: String {
		return "\(self.size) \(self.unit)"
	}
	
	public var longDescription: String {
		return "\(self.size) \(self.unit.longName.lowercased())"
	}

	
}
