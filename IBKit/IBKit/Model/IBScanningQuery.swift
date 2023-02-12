//
//  IBScanningQuery.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
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



public struct IBScanningQuery {
		
	/// The instrument's type for the scan. I.e. STK, FUT.HK, etc.
	public var instrument: String?
	
	/// The request's location (STK.US, STK.US.MAJOR, etc).
	public var locationCode: String?
	
	/// Same as TWS Market Scanner's "parameters" field, for example: TOP_PERC_GAIN.
	public var scanCode: String?
	
	/// Filters out Contracts which price is below this value.
	public var abovePrice: Double?
	
	/// Filters out contracts which price is above this value.
	public var belowPrice: Double?
	
	/// Filters out Contracts which volume is above this value.
	public var aboveVolume: Int?
	
	/// Filters out Contracts which option volume is above this value.
	public var averageOptionVolumeAbove: Int?
	
	/// Filters out Contracts which market cap is above this value.
	public var marketCapAbove: Double?
	
	/// Filters out Contracts which market cap is below this value.
	public var marketCapBelow: Double?
	
	/// Filters out Contracts which Moody's rating is below this value.
	public var moodyRatingAbove: String?
	
	/// Filters out Contracts which Moody's rating is above this value.
	public var moodyRatingBelow: String?
	
	// Filters out Contracts with a S&P rating below this value. 
	public var spRatingAbove: String?
	
	/// Filters out Contracts with a S&P rating above this value.
	public var spRatingBelow: String?
	
	/// Filter out Contracts with a maturity date earlier than this value.
	public var maturityDateAbove: String?
	
	/// Filter out Contracts with a maturity date older than this value.
	public var maturityDateBelow: String?
	
	/// Filter out Contracts with a coupon rate lower than this value.
	public var couponRateAbove: Double?
	
	/// Filter out Contracts with a coupon rate higher than this value.
	public var couponRateBelow: Double?
	
	/// Filters out Convertible bonds.
	public var excludeConvertible: String?
		
	/// For example, a pairing "Annual, true" used on the "top Option Implied Vol % Gainers" scan would return annualized volatilities.
	public var scannerSettingPairs: String?
	
	/// CORP = Corporation ADR = American Depositary Receipt ETF = Exchange Traded Fund REIT = Real Estate Investment Trust CEF = Closed End Fund
	
	public enum stockTypeFilter: String, Codable{
		case corporation 	= "CORP"
		case adr 			= "ADR"
		case etf			= "ETF"
		case realEstateFund	= "REIT"
		case closedFund 	= "CEF"
	}
	
	public var stockTypeFilter: stockTypeFilter?
	
	public init(){}
	
}
