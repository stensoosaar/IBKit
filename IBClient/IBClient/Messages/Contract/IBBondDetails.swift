//
//  IBBondDetails.swift
//  IBKit
//
//  Created by Sten Soosaar on 26.02.2025.
//

import Foundation

public struct IBBondDetails: IBEvent, Identifiable {
	
	/// request id
	public let id: Int
	
	//The unique IB contract identifier.

	public let contractID: Int
	public let type: String
	/// The underlying’s asset symbol.
	public let symbol: String
	
	/// The underlying’s currency.
	public let currency: String
	
	/// The nine-character bond CUSIP. For Bonds only. Receiving CUSIPs requires a CUSIP market data subscription.*/
	public let cusip: String
	
	///The interest rate used to calculate the amount you will receive in interest payments over the course of the year.
	/// This field is currently not available from the TWS API. For Bonds only.
	public let coupon: Double

	///The type of bond coupon. This field is currently not available from the TWS API. For Bonds only.
	public let couponType: String
	public let expiration: Date
	public let issueDate: String
	public let ratings: String
	
	///The type of bond
	public let bondType: String
	public let convertible: Bool
	public let callable: Bool
	public let putable : Bool
	public let descAppend: String
	public let exchange: String
	public let marketName: String
	public let tradingClass: String
	public let minTick: Double
	public let orderTypes: String
	public let validExchanges: String
	public let nextOptionDate: String
	public let nextOptionType: String
	public let nextOptionPartial: Bool
	public let notes: String
	public let longName: String
	public var timeZoneID: String?
	public var tradingHours: [IBTradingHour] = []
	public var liquidHours: [IBTradingHour] = []
	public var evRule: String?
	public var evMultiplier: Int?
	public var secIdList: [SecurityID] = []
	public var aggGroup: Int?
	public var marketRuleIds:[Int] = []
	public var minSize: Double?
	public var sizeIncrement: Double?
	public var suggestedSizeIncrement: Double?
}
	


extension IBBondDetails: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("No server version found. Check the connection!")
		}
		
		var container = try decoder.unkeyedContainer()
		
		var version = 6
		if serverVersion < IBServerVersion.SIZE_RULES{
			version = try container.decode(Int.self)
		}

		self.id = try container.decode(Int.self)
		self.symbol = try container.decode(String.self)
		self.type = try container.decode(String.self)
		self.cusip = try container.decode(String.self)
		self.coupon = try container.decode(Double.self)
		self.expiration = try container.decode(Date.self)
		self.issueDate = try container.decode(String.self)
		self.ratings = try container.decode(String.self)
		self.bondType = try container.decode(String.self)
		self.couponType = try container.decode(String.self)
		self.convertible = try container.decode(Bool.self)
		self.callable = try container.decode(Bool.self)
		self.putable = try container.decode(Bool.self)
		self.descAppend = try container.decode(String.self)
		self.exchange = try container.decode(String.self)
		self.currency = try container.decode(String.self)
		self.marketName = try container.decode(String.self)
		self.tradingClass = try container.decode(String.self)
		self.contractID = try container.decode(Int.self)
		self.minTick = try container.decode(Double.self)
		
		if serverVersion >=  IBServerVersion.MD_SIZE_MULTIPLIER && serverVersion < IBServerVersion.SIZE_RULES {
			_ = try container.decode(Int.self)
		}
		
		self.orderTypes = try container.decode(String.self)
		self.validExchanges = try container.decode(String.self)
		self.nextOptionDate = try container.decode(String.self)
		self.nextOptionType = try container.decode(String.self)
		self.nextOptionPartial = try container.decode(Bool.self)
		self.notes = try container.decode(String.self)
		
		self.longName = try container.decode(String.self)
			
		if serverVersion >=  IBServerVersion.BOND_TRADING_HOURS {
				
			self.timeZoneID = try container.decode(String.self)

			self.tradingHours = try container.decode(String.self)
				.components(separatedBy: ";")
				.map{ IBTradingHour(string: $0, zone: self.timeZoneID!)}

			self.liquidHours = try container.decode(String.self)
				.components(separatedBy: ";")
				.map{IBTradingHour(string: $0, zone: self.timeZoneID!)}

		}
		
		if version >= 6{
			self.evRule = try container.decode(String.self)
			self.evMultiplier = try container.decode(Int.self)
		}
	
		if version >= 5{
			let count = try container.decode(Int.self)
			for _ in 0..<count{
				let value = try container.decode(SecurityID.self)
				self.secIdList.append(value)
			}
		}

		if serverVersion >= IBServerVersion.AGG_GROUP{
			self.aggGroup = try container.decode(Int.self)
		}
		
		if serverVersion >= IBServerVersion.MARKET_RULES{
			self.marketRuleIds = try container.decode([Int].self)
		}

		if serverVersion >= IBServerVersion.SIZE_RULES{
			self.minSize = try container.decode(Double.self)
			self.sizeIncrement = try container.decode(Double.self)
			self.suggestedSizeIncrement = try container.decode(Double.self)
		}
		
	}
	
}


extension IBResponseWrapper where T == IBBondDetails {
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.id = try container.decode(Int.self)
		self.result = try container.decode(T.self)
	}
}
