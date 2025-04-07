//
//  TickQuote.swift
//  IBKit
//
//  Created by Sten Soosaar on 01.04.2025.
//



import Foundation


/// Quote update
/// A tickPrice value of -1 or 0 followed by a tickSize of 0 indicates there
/// is no data for this field currently available, whereas a tickPrice with a positive tickSize indicates
/// an active quote of 0 (typically for a combo contract).
public struct TickQuote: AnyTickEvent {
	
	public enum Side {
		case bid, ask, last, mid
	}
	
	public let type: IBTickType
	public let price: Double?
	public let size: Double?
	public let date: Date
	public let attributes: [IBTickAttribute]
}


extension TickQuote: Decodable {
	
	init(from decoder: IBDecoder) throws {
					
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("No server version found. Check the connection!")
		}
			
		var container = try decoder.unkeyedContainer()
		let type = try container.decode(IBTickType.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(DecodableValue<Double>.self).orZero
		let mask = try container.decode(DecodableValue<Int>.self).orZero

		self.type = type
		self.price = price == -1 ? nil : price
		self.size = size == -1 ? nil : size
		self.date = Date()

		var attr: [IBTickAttribute] = []
			
		if serverVersion >= IBServerVersion.PAST_LIMIT {
			if mask & 1 != 0 { attr.append(.canAutoExecute)}
			if mask & 2 != 0 { attr.append(.pastLimit)}
		}
			
		if serverVersion >= IBServerVersion.PRE_OPEN_BID_ASK {
			if mask & 4 != 0 {attr.append(.preOpen)}
		}
			
		self.attributes = attr

	}
	
}
