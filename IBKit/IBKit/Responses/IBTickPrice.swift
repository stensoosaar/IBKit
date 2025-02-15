//
//  File.swift
//  
//
//  Created by Sten Soosaar on 07.05.2024.
//

import Foundation


struct IBTickPrice: Decodable {
		
	var tick: [IBTick] = []

	init(from decoder: Decoder) throws {
		
		guard let serverVersion = (decoder as? IBDecoder)?.serverVersion else {
			throw IBClientError.decodingError("No server version found. Check the connection!")
		}
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		let requestID = try container.decode(Int.self)
		let type = try container.decode(IBTickType.self)
		let price = try container.decode(Double.self)
		let size = try container.decode(Double.self)
		let mask = try container.decode(Int.self)

		if price == -1 { return }

		var attr: [IBTickAttribute] = []
		
		if serverVersion >= IBServerVersion.PAST_LIMIT {
			if mask & 1 != 0 { attr.append(.canAutoExecute)}
			if mask & 2 != 0 { attr.append(.pastLimit)}
		}
		
		if serverVersion >= IBServerVersion.PRE_OPEN_BID_ASK {
			if mask & 4 != 0 {attr.append(.preOpen)}
		}
		

		let date = Date()
		
		tick.append(IBTick(requestID: requestID, type: type, value: price, date: date))

		var sizeType: IBTickType?
		
		if type == .BidPrice {
			sizeType = .BidSize
		} else if type == .AskPrice{
			sizeType = .AskSize
		} else if type == .LastPrice {
			sizeType = .LastSize
		} else if type == .DelayedBid{
			sizeType = .DelayedBidSize
		} else if type == .DelayedAsk {
			sizeType = .DelayedAskSize
		} else if type == .DelayedLast{
			sizeType = .DelayedLastSize
		}
		
		if size > 0 && sizeType != nil {
			tick.append(IBTick(requestID: requestID, type: sizeType!, value: size, date: date))
		}
		
	}
	
}
