//
//  MutablePriceBar.swift
//  IBKit
//
//  Created by Sten Soosaar on 20.03.2025.
//

import Foundation
import IBClient


public protocol AnyBar {
	var interval: DateInterval {get set}
	var open: Double {get set}
	var high: Double {get set}
	var low: Double {get set}
	var close: Double {get set}
	var volume: Double? {get set}
	var vwap: Double? {get set}
	var count: Int? {get set}
}


public struct Bar: AnyBar {
	public var interval: DateInterval
	public var open: Double
	public var high: Double
	public var low: Double
	public var close: Double
	public var volume: Double?
	public var vwap: Double?
	public var count: Int?
}



struct MutableTimeBar: AnyBar {
	var interval: DateInterval
	var open: Double
	var high: Double
	var low: Double
	var close: Double
	var volume: Double?
	var vwap: Double?
	var count: Int?
	
	init(date: Date, duration: TimeInterval, price: Double? = nil, size: Double? = nil, count: Int? = nil) {
		self.interval = Self.observationPeriod(date, interval: duration)
		self.open = price ?? 0
		self.high = price ?? 0
		self.low = price ?? 0
		self.close = price ?? 0
		self.volume = size ?? 0
		self.vwap = price ?? 0
		self.count = count
	}
	
	mutating func update(date: Date, price: Double? = nil, size: Double? = nil, count:Int? = nil) {
		guard interval.contains(date: date) else { return }
		self.high = max(self.high, price ?? self.high)
		self.low = min(self.low, price ?? self.low)
		self.close = price ?? self.close
		self.count = count
		if let size = size {
			let newVolume = (self.volume ?? 0) + size
			self.vwap = ((self.vwap ?? 0) * (self.volume ?? 0) + (price ?? 0) * size) / newVolume
			self.volume = newVolume
		}
	}
	
	private static func observationPeriod(_ date: Date, interval: TimeInterval) -> DateInterval {
		let timestamp = date.timeIntervalSince1970
		let roundedTimestamp = timestamp - timestamp.truncatingRemainder(dividingBy: interval)
		let start = Date(timeIntervalSince1970: roundedTimestamp)
		return DateInterval(start: start, duration: interval )
	}
	
}



extension MutableTimeBar: ConvertibleObject{
	
	typealias ConversionResult = Bar
	
	func convert() -> ConversionResult {
		return Bar(
			interval: interval,
			open: open,
			high: high,
			low: low,
			close: close,
			volume: volume,
			vwap: vwap,
			count: nil
		)

	}
	
}
