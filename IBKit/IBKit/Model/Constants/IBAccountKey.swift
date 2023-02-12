//
//  IBAccountTag.swift
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


public enum IBAccountKey: String, CaseIterable, Codable {
	
	///Identifies the IB account structure
	case accountType 				= "AccountType"
	
	/// The basis for determining the price of the assets in your account.
	///
	/// Total cash value + stock value + options value + bond value
	case netLiquidation 			= "NetLiquidation"
	
	/// Total cash balance recognized at the time of trade + futures PNL
	case totalCash 					= "TotalCashValue"
	
	/// Cash recognized at the time of settlement - purchases at the time of trade - commissions - taxes - fees
	case settledCash 				= "SettledCash"
	
	/// Total accrued cash value of stock, commodities and securities
	case accruedCash 				= "AccruedCash"
	
	/// Buying power serves as a measurement of the dollar value of securities that one may purchase in a securities account without depositing additional funds
	case buyingPower 				= "BuyingPower"
	
	/// Determines whether a client has the necessary assets to either initiate or maintain security positions.
	///
	/// Cash + stocks + bonds + mutual funds
	case equityWithLoan 			= "EquityWithLoanValue"
	
	/// Marginable Equity with Loan value as of 16:00 ET the previous day
	case previousEquityWithLoans 	= "PreviousEquityWithLoanValue"
	
	/// The sum of the absolute value of all stock and equity option positions
	case grossPosition 				= "GrossPositionValue"
	
	/// Regulation T equity for universal account
	case regTEquity 				= "RegTEquity"
	
	/// Regulation T margin for universal account
	case regTMargin		 			= "RegTMargin"
	
	///Special Memorandum Account
	///Line of credit created when the market value of securities in a Regulation T account increase in value
	case sma 						= "SMA"
	
	/// Initial Margin requirement of whole portfolio
	case initialMargin 				= "InitMarginReq"

	/// Maintenance Margin requirement of whole portfolio
	case maintenanceMargin 			= "MaintMarginReq"
	
	/// Tells what you have available for trading
	case availableFunds				= "AvailableFunds"
	
	/// This value shows your margin cushion, before liquidation
	case excessLiquidity 			= "ExcessLiquidity"
	
	/// Excess liquidity as a percentage of net liquidation value
	case cushion 					= "Cushion"
	
	/// Initial Margin of whole portfolio with no discounts or intraday credits
	case fullInitalMargin 			= "FullInitMarginReq"
	
	/// Maintenance Margin of whole portfolio with no discounts or intraday credits
	case fullMaintenanceMargin 		= "FullMaintMarginReq"
	
	/// Available funds of whole portfolio with no discounts or intraday credits
	case fullAvailableFunds 		= "FullAvailableFunds"
	
	///  Excess liquidity of whole portfolio with no discounts or intraday credits
	case fullExcessLiquidity 		= "FullExcessLiquidity"
	
	/// Time when look-ahead values take effect
	case lookAheadNextTime 			= "LookAheadNextChange"
	
	///  Initial Margin requirement of whole portfolio as of next period's margin change
	case lookAheadInitalMargin 		= "LookAheadInitMarginReq"
	
	/// Maintenance Margin requirement of whole portfolio as of next period's margin change
	case lookAheadMaintenaceMargin 	= "LookAheadMaintMarginReq"
	
	/// This value reflects your available funds at the next margin change
	case lookAheadAvailableFunds	= "LookAheadAvailableFunds"
	
	/// This value reflects your excess liquidity at the next margin change
	case lookAheadExcessLiquidity 	= "LookAheadExcessLiquidity"
	
	/// A measure of how close the account is to liquidation
	case severity 					= "HighestSeverity"
	
	/// The Number of Open/Close trades a user could put on before Pattern Day Trading is detected.
	/// A value of "-1" means that the user can put on unlimited day trades.
	case dayTradesLeft 				= "DayTradesRemaining"
	
	/// GrossPositionValue / NetLiquidation
	case leverege 					= "Leverage"
	
				
	public static var allValues: [IBAccountKey]{
		return IBAccountKey.allCases.compactMap{$0}
	}
	
	public static var allMargins: [IBAccountKey]{
		return [
			.initialMargin,
			.maintenanceMargin,
			.fullInitalMargin,
			.fullMaintenanceMargin,
			.lookAheadInitalMargin,
			.lookAheadMaintenaceMargin
		]
	}
	
	public static var allCash: [IBAccountKey]{
		return [
			.netLiquidation,
			.totalCash,
			.settledCash,
			.accruedCash,
		]
	}
		
}


extension IBAccountKey: CustomStringConvertible {
	
	
	public var description: String {
		
		switch self {
			case .accountType: 					return "Account Type"
			case .netLiquidation: 				return "Net Liquidation"
			case .totalCash: 					return "Total Cash"
			case .settledCash: 					return "Settled Cash"
			case .accruedCash: 					return "Accrued Cash"
			case .buyingPower: 					return "Buying Power"
			case .equityWithLoan: 				return "Equity With Loan"
			case .previousEquityWithLoans: 		return "Previous Equity With Loan"
			case .grossPosition: 				return "Gross Position"
			case .regTEquity: 					return "Reg T Equity"
			case .regTMargin: 					return "Reg T Margin"
			case .sma: 							return "SMA"
			case .initialMargin: 				return "Initial Margin"
			case .maintenanceMargin: 			return "Maintenance Margin"
			case .availableFunds: 				return "Available Funds"
			case .excessLiquidity: 				return "Excess Liquidity"
			case .cushion: 						return "Cushion"
			case .fullInitalMargin: 			return "Full Initial MarginReq"
			case .fullMaintenanceMargin: 		return "Full Maintenance Margin"
			case .fullAvailableFunds: 			return "Full Available Funds"
			case .fullExcessLiquidity: 			return "Full Excess Liquidity"
			case .lookAheadNextTime: 			return "Look Ahead Next Change"
			case .lookAheadInitalMargin: 		return "Look Ahead Initial Margin"
			case .lookAheadMaintenaceMargin: 	return "Look Ahead Maintenance Margin"
			case .lookAheadAvailableFunds: 		return "Look Ahead Available Funds"
			case .lookAheadExcessLiquidity: 	return "Look Ahead Excess Liquidity"
			case .severity: 					return "Highest Severity"
			case .dayTradesLeft: 				return "Remaining Day Trades"
			case .leverege: 					return "Leverage"
		}
		
	}
	
}
