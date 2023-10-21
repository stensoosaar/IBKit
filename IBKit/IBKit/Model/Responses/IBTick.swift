//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public enum IBTickAttribute {
	
	/// The Bid price is lower than the day's lowest value or the ask price is higher than the highest ask.
	case pastLimit
	
	/// The Bid is lower than day's lowest low.
	case bidPastLow
	
	/// The Ask is higher than day's highest ask.
	case askPastHigh
	
	/// Whether the price tick is available for automatic execution or not
	case canAutoExecute
	
	/// The bid/ask price tick is from pre-open session.
	case preOpen
	
	/// Trade is classified as 'unreportable' (e.g. odd lots, combos, derivative trades, etc)
	case unreported
	
}



public struct IBTick: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	public var date: Date
	public var type: IBTickType
	public var value: Double
	public var exchange: String?
	public var attributes: [IBTickAttribute]?
	
	internal init(requestID:Int, date:Date, type: IBTickType, value:Double, exchange: String? = nil, attributes:[IBTickAttribute]?=nil){
		self.requestID = requestID
		self.date = date
		self.type = type
		self.value = value
		self.exchange = exchange
		self.attributes = attributes
	}
		
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_  = try container.decode(Int.self)
		self.requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)
		self.value = try container.decode(Double.self)
		self.date = Date()
		self.attributes = nil
	}
	
}
