//
//  IBTickDecoder.swift
//  IBKit
//
//  Created by Sten Soosaar on 01.04.2025.
//

import Foundation

struct TickDecoder: IBDecodable{
	
	var id: Int
	var result: AnyTickEvent
	
	
	init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
		
		guard let peak = try? decoder.peek(offset:0),
			  let raw = Int(peak),
			  let tickType = IBTickType(rawValue: raw)
		else {
			throw IBError.decodingError("unable to decode tick type")
		}
				
		switch tickType {
			
		case .Bid, .Ask, .Last, .Delayed_Ask, .Delayed_Bid, .Delayed_Last:
			result = try TickQuote(from: decoder)
		case .Bid_Size, .Ask_Size, .Last_Size, .Delayed_Ask_Size, .Delayed_Bid_Size, .Delayed_Last_Size:
			result = try TickSize(from: decoder)
		case .Open_Price, .High_Price, .Low_Price, .Close_Price, .Delayed_Open_Price, .Delayed_High_Price, .Delayed_Low_Price, .Delayed_Close_Price:
			result = try TickPrice(from: decoder)
		case .Volume, .Delayed_Volume, .Average_Volume:
			result = try TickSize(from: decoder)
		case .Low_13_Weeks, .High_13_Weeks, .Low_26_Weeks, .High_26_Weeks, .Low_52_Weeks, .High_52_Weeks:
			result = try TickPrice(from: decoder)
		case .Halted:
			result = try TradingStatus(from: decoder)
		case .Dividend_Info:
			result = try TickDividends(from: decoder)
		case .Last_Timestamp, .Delayed_Last_Timestamp, .Last_Regulatory_Time:
			result = try TickTimestamp(from: decoder)
		case .Bid_Yield, .Ask_Yield, .Last_Yield, .Delayed_Yield_Ask, .Delayed_Yield_Bid:
			result = try TickPrice(from: decoder)
		case .Ask_Exchange, .Bid_Exchange, .Last_Exchange, .Option_Ask_Exchange, .Option_Bid_Exchange:
			result = try TickExchange(from: decoder)
		case .News:
			result = try TickNews(from: decoder)
		case .RT_Volume_Time_Sales, .RT_Trade_Volume:
			result = try RTVolumeSales(from: decoder)
		case .Bid_EFP_Computation:
			result = try TickEFP(from: decoder)
		case .Ask_EFP_Computation:
			result = try TickEFP(from: decoder)
		case .Last_EFP_Computation:
			result = try TickEFP(from: decoder)
		case .Open_EFP_Computation:
			result = try TickEFP(from: decoder)
		case .High_EFP_Computation:
			result = try TickEFP(from: decoder)
		case .Low_EFP_Computation:
			result = try TickEFP(from: decoder)
		case .Close_EFP_Computation:
			result = try TickEFP(from: decoder)
		case .Bid_Option_Computation:
			result = try TickOptionComputation(from: decoder)
		case .Ask_Option_Computation:
			result = try TickOptionComputation(from: decoder)
		case .Last_Option_Computation:
			result = try TickOptionComputation(from: decoder)
		case .Model_Option_Computation:
			result = try TickOptionComputation(from: decoder)
		case .Custom_Option_Computation:
			result = try TickOptionComputation(from: decoder)
		case .Delayed_Model_Option:
			result = try TickOptionComputation(from: decoder)
		case .Open_Interest, .Option_Put_Open_Interest, .Option_Call_Open_Interest, .Futures_Open_Interest:
			result = try TickSize(from: decoder)
		case .Short_Term_Volume_3_Minutes, .Short_Term_Volume_5_Minutes, .Short_Term_Volume_10_Minutes:
			result = try TickSize(from: decoder)
		default:
			throw IBError.decodingError("unable to decode tick type \(tickType)")
		}
		
	}
}


