//
//  IBStore.swift
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


public extension Calendar {
	
	func numberOfDays(between range: ClosedRange<Date>) -> Int {
		let numberOfDays = dateComponents([.day], from: range.lowerBound.startOfDay, to: range .upperBound.startOfDay)
		return numberOfDays.day!
	}
	
	func date(from components: DateComponents?) -> Date? {
		guard let components = components else { return nil }
		return Calendar.current.date(from: components)
	}
	
	func quarter(from date: Date, offset:Int = 0) -> ClosedRange<Date>{
		
		guard self.identifier == Calendar.Identifier.gregorian else {
			fatalError()
		}
		
		let startOfMonth = self.date(from: Calendar.current.dateComponents([.year, .month], from: date))!

		let components = Calendar.current.dateComponents([.month, .day, .year], from: startOfMonth)
		
		var months: ClosedRange<Int>
		switch components.month{
		case 1,2,3: months = 1...3
		case 4,5,6: months = 4...6
		case 7,8,9: months = 7...9
		default:	months = 10...12
		}
		
		guard let start = self.date(from: DateComponents(year: components.year, month: months.lowerBound)),
			  let end = self.date(from: DateComponents(year: components.year, month: months.upperBound)) else {
			fatalError()
		}

		return start.startOfMonth ... end.endOfMonth
		
	}
	
}

