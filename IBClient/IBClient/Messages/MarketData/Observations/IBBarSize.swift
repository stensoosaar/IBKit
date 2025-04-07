//
//  IBBarSize.swift
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


public enum IBBarSize: String, Encodable, CaseIterable, Sendable{
	case second 					= "1 secs"
	case fiveSeconds 				= "5 secs"
	case tenSeconds					= "10 secs"
	case fifteenSeconds				= "15 secs"
	case thritySeconds 				= "30 secs"
	case minute 					= "1 min"
	case twoMinutes 				= "2 mins"
	case threeMinutes 				= "3 mins"
	case fiveMinutes 				= "5 mins"
	case tenMinutes 				= "10 mins"
	case fifteenMinutes 			= "15 mins"
	case twentyMinutes 				= "20 mins"
	case thirtyMinutes 				= "30 mins"
	case hour 						= "1 hour"
	case twoHours 					= "2 hours"
	case threeHours 				= "3 hours"
	case fourHours 					= "4 hours"
	case eightHours 				= "8 hours"
	case day 						= "1 day"
	case week 						= "1 week"
	case month 						= "1 month"
	
	var seconds:Int {
		return 5
	}
	
	public var timeInterval: TimeInterval {
		switch self {
			case .second:			return 1
			case .fiveSeconds:		return 5
			case .tenSeconds:		return 10
			case .fifteenSeconds:	return 15
			case .thritySeconds:	return 30
			case .minute:			return 60
			case .twoMinutes:		return 120
			case .threeMinutes:		return 180
			case .fiveMinutes:		return 300
			case .tenMinutes:		return 600
			case .fifteenMinutes:	return 900
			case .twentyMinutes:	return 1200
			case .thirtyMinutes: 	return 1800
			case .hour: 			return 3600
			case .twoHours: 		return 7200
			case .threeHours: 		return 10800
			case .fourHours: 		return 14400
			case .eightHours: 		return 28800
			case .day: 				return 86400
			case .week: 			return 604800
			case .month: 			return 2592000
		}
	}
	
	public init(timeInterval: TimeInterval) {
		switch timeInterval {
			case 1..<5:				self = .second
			case 5..<10:			self = .fiveSeconds
			case 10..<15:			self = .tenSeconds
			case 15..<30:			self = .fifteenSeconds
			case 30..<60:			self = .thritySeconds
			case 60..<120:			self = .minute
			case 120..<180:			self = .twoMinutes
			case 180..<300:			self = .threeMinutes
			case 300..<600:			self = .fiveMinutes
			case 600..<900:			self = .tenMinutes
			case 900..<1200:		self = .fifteenMinutes
			case 1200..<1800:		self = .twentyMinutes
			case 1800..<3600:		self = .thirtyMinutes
			case 3600..<7200:		self = .hour
			case 7200..<10800:		self = .twoHours
			case 10800..<14400:		self = .threeHours
			case 14400..<28800:		self = .fourHours
			case 28800..<86400:		self = .eightHours
			case 86400..<604800:	self = .day
			case 604800..<2592000:	self = .week
			default: 				self = .month
		}
	}
	
	
}
