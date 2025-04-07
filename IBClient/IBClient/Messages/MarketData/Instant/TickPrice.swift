//
//  TickQuote 2.swift
//  IBKit
//
//  Created by Sten Soosaar on 01.04.2025.
//



import Foundation

/// Market data tick price callback. Handles all price related ticks.
public struct TickPrice: AnyTickEvent{
	/// - field:	the type of the price being received (i.e. ask price).
	public let type: IBTickType
	/// - price:	the actual price.
	public let price: Double?
	/// - attribs:	an TickAttrib object that contains price attributes such as TickAttrib::CanAutoExecute, TickAttrib::PastLimit and TickAttrib::PreOpen.
	public let date: Date
}


extension TickPrice: Decodable {
	
	init(from decoder: IBDecoder) throws {
	
		var container = try decoder.unkeyedContainer()
		let type = try container.decode(IBTickType.self)
		let price = try container.decode(Double.self)

		self.type = type
		self.price = price == -1 ? nil : price
		self.date = Date()

	}
	
}
