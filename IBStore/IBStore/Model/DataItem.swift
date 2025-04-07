//
//  DataItem.swift
//  IBKit
//
//  Created by Sten Soosaar on 05.04.2025.
//

import Foundation
import IBClient


public protocol AnyDataItem{}


public enum DataItem: AnyDataItem{
	case quotes
	case bar(size: IBBarSize)
	case bars(size: IBBarSize, count: Int)
	case fundamentals
}


public struct ScheduledDataItem: AnyDataItem {
	public let item: DataItem
	public let schedule: Schedule
	
	public init(_ item: DataItem, schedule: Schedule = .hourly()) {
		self.item = item
		self.schedule = schedule
	}
}


extension DataItem {
	public func scheduled(_ schedule: Schedule) -> ScheduledDataItem {
		ScheduledDataItem(self, schedule: schedule)
	}
}
