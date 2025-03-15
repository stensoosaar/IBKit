//
//  IBDate+Ext.swift
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


public extension Date{
	
	static func futureExpiration(year:Int, month: Int) throws -> Date {
		let comps = DateComponents(year: year, month: month)
		guard let startOfMonth = Calendar.current.date(from: comps) else {
			throw IBError.invalidValue("Invalid date components")
		}
		return startOfMonth.endOfMonth
	}
	
	static func optionExpiration(year:Int, month: Int, day: Int) throws -> Date {
		let comps = DateComponents(year:year, month: month, day: day)
		guard let date = Calendar.current.date(from: comps) else {
			throw IBError.invalidValue("Invalid date components")
		}
		return date
	}
	
	var startOfDay: Date {
		return Calendar.current.startOfDay(for: self)
	}
	
	var endOfDay: Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfDay)!
	}
	
	private var startOfMonth: Date {
		let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
		return Calendar.current.date(from: components)!
	}
	
	private var endOfMonth: Date {
		var components = DateComponents()
		components.month = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfMonth)!
	}
	
	var futureExpirationCode: String? {
		let comps = Calendar.current.dateComponents([.month, .year], from: self)
		guard let month = comps.month, let year = comps.year else {return nil}
		let monthCode = ["F","G","H","J","K","M","N","Q","U","V","X","Z"][month-1]
		let yearCode = "\(year)".suffix(1)
		return "\(monthCode)\(yearCode)"		
	}
	
	init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) throws {
		let comps = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
		guard let date = Calendar.current.date(from: comps) else {
			throw IBError.invalidValue("\(year)-\(month)-\(day) invalid values to make date")
		}
		self.init(timeIntervalSince1970: date.timeIntervalSince1970)
	}
	
}
