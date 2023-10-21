//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation




/// Exchange of physicals
///
/// A private agreement between two parties allowing for one party to swap a futures contract for the actual underlying asse

struct IBEFPEvent: Decodable, IBIndexedEvent {
	
	public var requestID: Int
	
	public var type: IBTickType
	
	public var points: Double
	
	public var pointsFormatted: String
	
	public var impliedPrice: Double
	
	public var holded: Int
	
	public var futureLastTradeDate: Date
	
	public var dividendImpact: Double
	
	public var dividendsToLastTradeDate: Double
	
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		requestID = try container.decode(Int.self)
		self.type = try container.decode(IBTickType.self)
		self.points = try container.decode(Double.self)
		self.pointsFormatted = try container.decode(String.self)
		self.impliedPrice = try container.decode(Double.self)
		self.holded = try container.decode(Int.self)
		self.futureLastTradeDate = try container.decode(Date.self)
		self.dividendImpact = try container.decode(Double.self)
		self.dividendsToLastTradeDate = try container.decode(Double.self)
	}
	
}
