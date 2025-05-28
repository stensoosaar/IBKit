//
//  PriceHistory.swift
//  IBKit
//
//  Created by Sten Soosaar on 24.05.2025.
//

import Foundation

public struct Bar: Sendable {
	
	public let date: DateInterval
	
	public let opne: Double
	
	public let high: Double
	
	public let low: Double
	
	public let close: Double
	
	public let volume: Double?
	
	public let count: Int?
	
}


public struct Quote: Sendable {
	
	public enum Side: Int, Sendable {
		case bid = 1
		case ask = 2
		case trade = 3
	}
	
	public let contractID: Int
	
	public let date: Date
	
	public let side: Side
	
	public let price: Double
	
	public let size: Double
	
}


public struct BarUpdate<T: Sendable>: Sendable {
	
	public let contractID: Int
	
	public let resolution: TimeInterval
	
	public let interval: DateInterval
	
	public let timeSeries: T
	
}
