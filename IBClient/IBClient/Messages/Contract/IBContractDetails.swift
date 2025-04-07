//
//  IBClient.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//



import Foundation


public struct IBContractDetails: IBEvent {
	
	/// interactive brokers contract id
	public var contractID: Int
	
	/// contract type
	public var type: IBSecuritiesType

	/// interactive brokers symbol. usually represents underlying asset eg AAPL
	public var symbol: String

	/// quoting curreny eg USD
	public var currency: String

	/// last trading day of expirable assets (eg futures, options)
	public var expiration: Date?
	
	/// strike pride of option's contract
	public var strikePrice: Double?
	
	/// execution right of option contracts (call or put)
	public var executionRight: IBExecutionRight?
	
	///contract size, representing how much the contract value will change for 1 unit price change
	public var multiplier: Double?
	
	/// destination exchange. Use smart if contract is traded in multiple exchanges
	public var exchange: IBExchange?
	
	/// exchange where the contract is listed
	public var primaryExchange: IBExchange?
		
	/// exchange symbol eg ticker
	public var localSymbol: String?
	
	
	public var tradingClass: String?
	
	/// indicates wheater the contract is active or expired
	public var isExpired: Bool = false
	
	///securities unique identifier such as ISIN, CUSIP, FIGI
	public var secId: SecurityID?
	
	public var issuerID: String?
	
	/// For derivatives, the symbol of the underlying contract.
	public var underlyingSymbol: String?
	
	/// For derivatives, returns the underlying security type.
	public var underlyingSecurityType: IBSecuritiesType?
	
	/// Real expiration date. Requires TWS 968+ and API v973.04+. Python API specifically requires API v973.06+.
	public var realExpirationDate: Date?
	
	/// Typically the contract month of the underlying for a Future contract.
	public var contractMonth: String?
	
	var includeExpired: Bool = false
	
	/// The market name for this product.
	public var marketName: String?
	
	/// The minimum allowed price variation. Note that many securities vary their minimum tick size according to their price.
	/// This value will only show the smallest of the different minimum tick sizes regardless of the product's price.
	public var minimumTick: Double
	
	/// Allows execution and strike prices to be reported consistently with market data, historical data and the order price, i.e. Z on LIFFE is reported in Index points and not GBP.
	public var priceMagnifier: Double?
	
	/// Returns the size multiplier for values returned to tickSize from a market data request. Generally 100 for US stocks and 1 for other instruments.
	public var mdSizeMultiplier: Double?
		
	/// Supported order types for this product.*/
	public var orderTypes: [String]?
	
	/// Valid exchange fields when placing an order for this contract. The list of exchanges will is provided in the same order as the corresponding MarketRuleIds list.
	public var validExchanges: [String]?
	
	/// For derivatives, the contract ID (conID) of the underlying instrument.
	public var underlyingContractID: Int?
	
	/// Descriptive name of the product.*/
	public var longName: String?
	
	/// The industry classification of the underlying/product. For example, Financial
	public var industry: String?
	
	/// The industry category of the underlying. For example, InvestmentSvc
	public var category: String?
	
	/// The industry subcategory of the underlying. For example, Brokerage
	public var subcategory: String?
	
	/// The time zone for the trading hours of the product. For example, EST
	public var timeZoneID: String?
	
	/// The trading hours of the product.
	public var tradingHours: [IBTradingHour]?
	
	/// The liquid hours of the product.
	public var liquidHours: [IBTradingHour]?
	
	/// Contains the Economic Value Rule name and the respective optional argument.
	/// The two values should be separated by a colon. For example, aussieBond:YearsToExpiration=3.
	/// When the optional argument is not present, the first value will be followed by a colon.
	public var evRule: String?
	
	/// Tells you approximately how much the market value of a contract would change if the price were to change by 1.
	///  It cannot be used to get market value by multiplying the price by the approximate multiplier
	public var evMultiplier: Double?
	
	/// A list of contract identifiers that the customer is allowed to view. CUSIP/ISIN/etc.
	///  For US stocks, receiving the ISIN requires the CUSIP market data subscription.
	///  For Bonds, the CUSIP or ISIN is input directly into the symbol field of the Contract class.
	public var secIdList: [SecurityID] = []
	
	/// Aggregated group Indicates the smart-routing group to which a contract belongs. contracts which cannot be smart-routed have aggGroup = -1.
	public var aggGroup: Int?
	
	/// The list of market rule IDs separated by comma Market rule IDs can be used to determine the minimum price increment at a given price.
	public var marketRuleIds: [Int]?
	
	/// If populated for the bond in IB's database. For Bonds only.
	public var notes: String?
	
	///Stock type.
	public var stockType: String?
	
	/// The minimum allowed price variation. Note that many securities vary their minimum tick size according to their price.
	/// This value will only show the smallest of the different minimum tick sizes regardless of the product’s price.
	/// Full information about the minimum increment price structure can be obtained with the reqMarketRule
	/// function or the IB Contract and Security Search site.
	public var minTick: Double?
	
	/// Order’s minimal size.
	public var minSize: Double?
	
	///O rder’s size increment.
	public var sizeIncrement: Double?
	
	/// Order’s suggested size increment.
	public var suggestedSizeIncrement: Double?
	
}



extension IBContractDetails: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		
		guard let serverVersion = decoder.serverVersion else {
			throw IBError.decodingError("No server version found. Check the connection!")
		}

		var container = try decoder.unkeyedContainer()
		
		var version: Int = 8
		if serverVersion < IBServerVersion.SIZE_RULES{
			version = try container.decode(Int.self)
		}
			
		_ = version >= 3 ? try container.decode(Int.self) : -1

		self.symbol = try container.decode(String.self)
		self.type = try container.decode(IBSecuritiesType.self)
		self.expiration = try container.decodeOptional(Date.self)
		self.strikePrice = try container.decodeOptional(Double.self)
		self.executionRight = try container.decodeOptional(IBExecutionRight.self)
		self.exchange = try container.decode(IBExchange.self)
		self.currency = try container.decode(String.self)
		self.localSymbol = try container.decode(String.self)
		self.marketName = try container.decode(String.self)
		self.tradingClass = try container.decode(String.self)
		self.contractID = try container.decode(Int.self)
		self.minimumTick = try container.decode(Double.self)
				
		if serverVersion >= IBServerVersion.MD_SIZE_MULTIPLIER && serverVersion < IBServerVersion.SIZE_RULES {
			self.mdSizeMultiplier = try container.decodeOptional(Double.self)
		}
		
		self.multiplier = try container.decodeOptional(Double.self)
		self.orderTypes = try container.decode(String.self).components(separatedBy: ",")
		self.validExchanges = try container.decode(String.self).components(separatedBy: ",")
		self.priceMagnifier = try container.decode(Double.self)
		self.underlyingContractID = try container.decode(Int.self)
		self.longName = try container.decode(String.self)
		self.primaryExchange = try container.decodeOptional(IBExchange.self)

		
		if version >= 6 {
			self.contractMonth = try container.decodeOptional(String.self)
			self.industry = try container.decodeOptional(String.self)
			self.category = try container.decodeOptional(String.self)
			self.subcategory = try container.decodeOptional(String.self)
			self.timeZoneID = try container.decode(String.self)

			self.tradingHours = try container.decode(String.self)
				.components(separatedBy: ";")
				.map{ IBTradingHour(string: $0, zone: self.timeZoneID!)}

			self.liquidHours = try container.decode(String.self)
				.components(separatedBy: ";")
				.map{IBTradingHour(string: $0, zone: self.timeZoneID!)}
		}
		

		if version >= 8 {
			self.evRule = try container.decodeOptional(String.self)
			self.evMultiplier = try container.decodeOptional(Double.self)
		}

		if version >= 7 {
			let count = try container.decode(Int.self)
			for _ in 0..<count{
				let value = try container.decode(SecurityID.self)
				self.secIdList.append(value)
			}
		}
		
		if serverVersion >= IBServerVersion.AGG_GROUP{
			self.aggGroup = try container.decodeOptional(Int.self)
		}
		

		if serverVersion >= IBServerVersion.UNDERLYING_INFO{
			self.underlyingSymbol = try container.decodeOptional(String.self)
			self.underlyingSecurityType = try container.decodeOptional(IBSecuritiesType.self)
		}
		
		if serverVersion >= IBServerVersion.MARKET_RULES {
			self.marketRuleIds = try container.decodeOptional([Int].self)
		}

		if serverVersion >= IBServerVersion.REAL_EXPIRATION_DATE {
			self.realExpirationDate = try container.decodeOptional(Date.self)
		}

		if serverVersion >= IBServerVersion.STOCK_TYPE{
			self.stockType = try container.decodeOptional(String.self)
		}
		
		if serverVersion >= IBServerVersion.FRACTIONAL_SIZE_SUPPORT && serverVersion < IBServerVersion.SIZE_RULES{
			self.minTick = try container.decodeOptional(Double.self)
		}

		if serverVersion >= IBServerVersion.SIZE_RULES{
			self.minSize = try container.decodeOptional(Double.self)
			self.sizeIncrement = try container.decodeOptional(Double.self)
			self.suggestedSizeIncrement = try container.decodeOptional(Double.self)
		}

	}
	
}


extension IBContractDetails {
	
	public var contract: IBContract{
		
		return IBContract(
			id: contractID,
			symbol: symbol,
			type: type,
			currency: currency,
			expiration: realExpirationDate,
			strike: strikePrice,
			right: executionRight,
			multiplier: multiplier,
			exchange: exchange,
			primaryExchange: primaryExchange
		)
	
	}
	
}

extension IBResponseWrapper where T == IBContractDetails {
	
	init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		let position = decoder.serverVersion < IBServerVersion.SIZE_RULES ? 1 : 0
		
		guard let peak = try? decoder.peek(offset: position), let requestID = Int(peak)
		else{ throw IBError.decodingError("\(#function) failed to load id") }

		self.id = requestID
		self.result = try container.decode(T.self)
	}

	
}




public struct IBContractDetailsEnd: IBEvent, Identifiable {
	public let id: Int
}

extension IBContractDetailsEnd: IBDecodable {
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.id = try container.decode(Int.self)
	}

}
