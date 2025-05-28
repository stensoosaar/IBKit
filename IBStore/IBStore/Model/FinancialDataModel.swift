//
//  FinancialSummary.swift
//  
//
//  Created by Sten Soosaar on 23.03.2025.
//

import Foundation


public struct Address{
	public var streetAddressLine1: String
	public var streetAddressLine2: String?
	public var streetAddressLine3: String?
	public var city: String
	public var state: String
	public var postalCode: Int
	public var countryCode: String
}



public enum ReportStatus: String {
	
	/// Preliminary data. Least accurate
	/// Represents early-reported financial figures, often subject to revision before the final actual report is released.
	case preliminary = "P"

	/// Actual reported data
	/// Represents officially reported and finalized financial figures from the company's filings (e.g., SEC 10-Q, 10-K).
	case actual = "A"
	
	
	/// Restated figures (revised data)
	/// Represents figures that have been revised from previously reported data due to accounting adjustments or corrections.
	case restated = "R"
	
	/// Trailing 12 months (rolling year)
	/// Represents financial data aggregated over the last 12 months (rolling year), rather than a fixed fiscal period.
	case trailingTwelveMonths = "TTM"

	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)
		guard let type = ReportStatus(rawValue: rawValue) else { fatalError("Unsupported report type \(rawValue)")}
		self = type
	}
}


public struct FinancialSummary {
	public let totalRevenues: [FinancialFact]
	public let dividendPerShares: [FinancialFact]
	public let eps: [FinancialFact]
	public let dividends: [Dividend]
}


public struct FinancialFact {
	public let reportType: String
	public let currency: String
	public let value: Double
	public let date: Date
	public let period: String
}


public struct Dividend {
	public let type: String
	public let currency: String
	public let value: Double
	public let exDate: Date
	public let recordDate: Date
	public let payDate: Date
	public let declarationDate: Date
}


public struct CompanySnapshot{
	
	public var companyName: String
	public var ticker: String
	public var ric: String
	public var exchangeSymbol: String
	public var outstandingShares: Double
	public var address: String?
	public var website: URL?
	public var employees: Int?
	public var updatedAt: Date

	
	// MARK: - Price and Volume ratios
	/// Latest stock price
	public var NPRICE: Double
	/// 52-week high price
	public var NHIG: Double
	/// 52-week low price
	public var NLOW: Double
	/// Date of the latest price data.
	public var PDATE: Date
	/// 10-day average trading volume.
	public var VOL10DAVG: Double
	/// Enterprise value- Market capitalization + debt - cash.
	public var EV: Double

	// MARK: - Income Statement
	/// Market Capitalization – Total value of outstanding shares (price × shares).
	public var MKTCAP: Double
	/// Trailing Twelve Months Revenue) – Total revenue for the last 12 months.
	public var TTMREV: Double
	/// TTM EBITDA) – Earnings before interest, taxes, depreciation, and amortization for the past year.
	public var TTMEBITD: Double
	/// TTM Net Income After Costs) – Net profit over the last 12 months.
	public var TTMNIAC: Double

	// MARK: - Per share data
	/// TTM EPS Excluding Extraordinary Items
	/// Earnings per share (EPS) without one-time items.
	public var TTMEPSXCLX: Double
	/// TTM Revenue Per Share
	/// Revenue per share over the last 12 months.
	public var TTMREVPS: Double
	/// Quarterly Book Value Per Share
	/// Book value per share for the latest quarter.
	public var QBVPS: Double
	/// Quarterly Cash Per Share
	/// Cash per share for the latest quarter.
	public var QCSHPS: Double
	/// TTM Cash Flow Per Share
	/// Cash flow per share over the last 12 months.
	public var TTMCFSHR: Double
	/// TTM Dividends Per Share
	/// Dividend per share paid over the last 12 months.
	public var TTMDIVSHR: Double

	//MARK: - Other Ratios
	/// TTM Gross Margin %
	/// Gross profit as a percentage of revenue over 12 months.
	public var TTMGROSMGN: Double
	/// TTM Return on Equity %
	/// Net income as a percentage of shareholders’ equity over 12 months.
	public var TTMROEPCT: Double
	/// TTM Price-to-Revenue Ratio
	/// Stock price relative to revenue per share.
	public var TTMPR2REV: Double
	/// P/E Ratio Excluding Extraordinary Items
	/// Price-to-earnings ratio, excluding one-time charges.
	public var PEEXCLXOR: Double
	/// Price-to-Book Ratio
	/// Stock price relative to book value per share.
	public var PRICE2BK: Double
	
	
	//MARK: - EXPECTATIONS
	/// Consensus recommendation
	/// Average analyst rating where 1 - buy and 5 - sell
	public var consRecom: Double
	
	/// Target price
	/// Analyst' projected future stock price
	public var TargetPrice: Double
	
	/// Projected long term growth rate %
	/// estimated long term earnings growth rate
	public var ProjLTGrowthRate: Double
	
	/// Projected P/E ratio
	/// Estimates price-to-earnings ratio
	public var ProjPE: Double
	
	/// Project sales, Annual
	/// Forecasted revenue for the next fiscal year
	public var ProjSales: Double
	
	///  Project sales, Quarterly
	/// Forecasted revenue for the next quarter
	public var ProjSalesQ: Double
	
	/// Project EPS, Annual
	/// Expected earnings per share for the year.
	public var ProjEPS: Double
	
	/// Projected EPS, Quarterly
	/// Expected earnings per share for the next quarter.
	public var ProjEPSQ: Double
	
	/// Projected Net Profit, Annual
	/// Expected net income for the year.
	public var ProjProfit: Double
	
	/// Projected Dividends Per Share
	/// Estimated dividends per share for the year.
	public var ProjDPS: Double
	
}
