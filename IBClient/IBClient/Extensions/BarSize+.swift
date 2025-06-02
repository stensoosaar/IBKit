//
//  BarSize+.swift
//  IBKit
//
//  Created by Sten Soosaar on 02.06.2025.
//

import Foundation
import TWS


public extension BarSize {
	
	var timeInterval: TimeInterval {
		switch self {
		case .sec1:		return 1
		case .secs5:	return 5
		case .secs10:	return 10
		case .secs15:	return 15
		case .secs30:	return 30
		case .min1:		return 60
		case .mins2:	return 120
		case .mins3:	return 180
		case .mins5:	return 300
		case .mins10:	return 600
		case .mins15:	return 900
		case .mins20:	return 1200
		case .mins30: 	return 1800
		case .hour1: 	return 3600
		case .hours2: 	return 7200
		case .hours4: 	return 14400
		case .hours8: 	return 28800
		case .day: 		return 86400
		case .week: 	return 604800
		case .month: 	return 2592000
		}
	}
	
}
