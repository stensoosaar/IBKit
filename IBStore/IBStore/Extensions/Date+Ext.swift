//
//  DateInterval+Ext.swift
//  
//
//  Created by Sten Soosaar on 25.03.2025.
//

import Foundation

public extension Date{
	
	func inRange(_ interval: DateInterval) -> Bool {
		return self.timeIntervalSince1970 >= interval.start.timeIntervalSince1970
		&& self.timeIntervalSince1970 < interval.end.timeIntervalSince1970
	}
	
}
