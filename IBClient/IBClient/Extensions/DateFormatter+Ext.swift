//
//  Date+Ext.swift
//  
//
//  Created by Sten Soosaar on 23.03.2025.
//

import Foundation

public extension DateFormatter {
	static let iso8601: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()
}


