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
import IBClient

public enum Schedule {
	
	case daily(hour: Int, minute: Int)
	case weekly(weekday: Int, hour: Int, minute: Int)
	case monthly(week: Int, weekday: Int)
	case quarterly(month: Int, week:Int, weekday: Int)
	
	public func nextDate(from sessionDate: Date) -> Date? {
		switch self {
		case .daily(let hour, let minute):
			let comps = DateComponents(hour:hour, minute: minute)
			return Calendar.current.nextDate(after: sessionDate, matching: comps, matchingPolicy: .nextTime)
			
		case .weekly(let weekday, let hour, let minute):
			let comps = DateComponents(hour:hour, minute: minute, weekday: weekday)
			return Calendar.current.nextDate(after: sessionDate, matching: comps, matchingPolicy: .nextTime)
			
		case .monthly(let week, let weekday):
			let comps = DateComponents(hour:00, minute: 00, weekday: weekday, weekOfMonth: week)
			return Calendar.current.nextDate(after: sessionDate, matching: comps, matchingPolicy: .nextTime)
			
		case .quarterly(let month, let week, let weekday):
			assert(month <= 3, "quarter has only three months")
			
			let calendar = Calendar(identifier: .gregorian)
			let quarter = calendar.quarter(from: sessionDate)
			let blaa = calendar.date(byAdding: .month, value: month - 1, to: quarter.lowerBound)!
			var comps = calendar.dateComponents([.year, .month, .weekday, .day], from: blaa)
			
			let offset = weekday > 6 ? week+1 : week
			comps.day = nil
			comps.weekOfMonth = offset
			comps.weekday = weekday
			
			return calendar.nextDate(after: blaa, matching: comps, matchingPolicy: .nextTime)
		}
			
	}
	
}
