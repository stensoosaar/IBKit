//
//  Int+optional.swift
//  IBKit
//
//  Created by Sten Soosaar on 14.03.2025.
//

import Foundation


//
// helpers for feeding data to
//

func Int32(_ value: Int?) -> Int32? {
	return value.map { Swift.Int32($0) }
}

func Int16(_ value: Int?) -> Int16? {
	return value.map { Swift.Int16($0) }
}

func Int64(_ value: Int?) -> Int64? {
	return value.map { Swift.Int64($0) }
}

func Double(_ value: Int?) -> Double? {
	return value.map { Swift.Double($0) }
}

func String(_ value: Any?) -> String? {
	return value as? String
}

extension Date{
	
	static func empty() -> Date?{
		return nil
	}
	
}
