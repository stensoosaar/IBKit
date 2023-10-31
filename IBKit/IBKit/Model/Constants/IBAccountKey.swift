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
	
	
	///The account ID number
	case AccountCode						= "AccountCode"
	
	//"All" to return account summary data for all accounts, or set to a specific Advisor Account Group name that has already been created in TWS Global Configuration
	case AccountOrGroup						= "AccountOrGroup"
	
	///For internal use only
	case AccountReady	 					= "AccountReady"
	
	/// Reflects the current's month accrued debit and credit interest to date, updated daily in commodity segment
	case AccruedCashC						= "AccruedCash-C"
	
	///Reflects the current's month accrued debit and credit interest to date, updated daily in security segment
	case AccruedCashS						= "AccruedCash-S"
	
	///Total portfolio value of dividends accrued
	case AccruedDividend					= "AccruedDividend"
	
	///Dividends accrued but not paid in commodity segment
	case AccruedDividendC					= "AccruedDividend-C"
	
	///Dividends accrued but not paid in security segment
	case AccruedDividendS					= "AccruedDividend-S"
		
	///Net Liquidation Value - Initial Margin
	case AvailableFundsC 					= "AvailableFunds-C"
	
	///Equity with Loan Value - Initial Margin
	case AvailableFundsS					= "AvailableFunds-S"
	
	///Total portfolio value of treasury bills
	case Billable							= "Billable"
	
	/// Value of treasury bills in commodity segment
	case BillableC							= "Billable-C"
	
	/// Value of treasury bills in security segment
	case BillableS							= "Billable-S"
		
	///Cash recognized at the time of trade + futures PNL
	case CashBalance						= "CashBalance"
	
	///Value of non-Government bonds such as corporate bonds and municipal bonds
	case CorporateBondValue					= "CorporateBondValue"
	
	/// Open positions are grouped by currency
	case Currency							= "Currency"
	
	/// Number of Open/Close trades one could do tomorrow before Pattern Day Trading is detected
	case DayTradesRemainingT1				= "DayTradesRemainingT+1"
	
		///Number of Open/Close trades one could do two days from today before Pattern Day Trading is detected
	case DayTradesRemainingT2				= "DayTradesRemainingT+2"
	
		///Number of Open/Close trades one could do three days from today before Pattern Day Trading is detected
	case DayTradesRemainingT3 				= "DayTradesRemainingT+3"
	
		/// Number of Open/Close trades one could do four days from today before Pattern Day Trading is detected
	case DayTradesRemainingT4				= "DayTradesRemainingT+4"
	
	
		///Cash account: Total cash value + commodities option value - futures maintenance margin requirement + minimum
	///(0, futures PNL) Margin account: Total cash value + commodities option value - futures maintenance margin requirement
	case EquityWithLoanValueC				= "EquityWithLoanValue-C"
	
		///Cash account: Settled Cash Margin Account: Total cash value + stock value + bond value + (non-U.S. & Canada securities options value)
	case EquityWithLoanValueS				= "EquityWithLoanValue-S"
		
		///Equity with Loan Value - Maintenance Margin
	case ExcessLiquidityC					= "ExcessLiquidity-C"
	
		///Net Liquidation Value - Maintenance Margin
	case ExcessLiquidityS					= "ExcessLiquidity-S"
	
		///The exchange rate of the currency to your base currency
	case ExchangeRate						= "ExchangeRate"
		
		///Net Liquidation Value - Full Initial Margin
	case FullAvailableFundsC				= "FullAvailableFunds-C"
	
		///Equity with Loan Value - Full Initial Margin
	case FullAvailableFundsS				= "FullAvailableFunds-S"
		
		///Net Liquidation Value - Full Maintenance Margin
	case FullExcessLiquidityC 				= "FullExcessLiquidity-C "
	
		///Equity with Loan Value - Full Maintenance Margin
	case FullExcessLiquidityS				= "FullExcessLiquidity-S"
		
		/// Initial Margin of commodity segment's portfolio with no discounts or intraday credits
	case FullInitMarginReqC					= "FullInitMarginReq-C"
	
		///Initial Margin of security segment's portfolio with no discounts or intraday credits
	case FullInitMarginReqS					= "FullInitMarginReq-S"
	
	
		///Maintenance Margin of commodity segment's portfolio with no discounts or intraday credits
	case FullMaintMarginReqC				= "FullMaintMarginReq-C"
	
		///Maintenance Margin of security segment's portfolio with no discounts or intraday credits
	case FullMaintMarginReqS				= "FullMaintMarginReq-S"
	
		///Value of funds value (money market funds + mutual funds)
	case FundValue							= "FundValue"
		
		/// Real-time market-to-market value of futures options
	case FutureOptionValue					= "FutureOptionValue"
	
		///Real-time changes in futures value since last settlement
	case FuturesPNL							= "FuturesPNL"
	
		///Cash balance in related IB-UKL account
	case FxCashBalance						= "FxCashBalance"
	
	
		///Long Stock Value + Short Stock Value + Long Option Value + Short Option Value
	case GrossPositionValueS				= "GrossPositionValue-S"
	
		///Margin rule for IB-IN accounts
	case IndianStockHaircut					= "IndianStockHaircut"
	
	
		///Initial Margin of the commodity segment in base currency
	case InitMarginReqC						= "InitMarginReq-C"
	
		///Initial Margin of the security segment in base currency
	case InitMarginReqS						= "InitMarginReq-S"
	
		///Real-time mark-to-market value of Issued Option
	case IssuerOptionValue					= "IssuerOptionValue"
	
		///GrossPositionValue / NetLiquidation in security segment
	case LeverageS							= "Leverage-S"
		
	
		///Net Liquidation Value - look ahead Initial Margin
	case LookAheadAvailableFundsC			= "LookAheadAvailableFunds-C"
	
		///Equity with Loan Value - look ahead Initial Margin
	case LookAheadAvailableFundsS			= "LookAheadAvailableFunds-S"
	
	
		///Net Liquidation Value - look ahead Maintenance Margin
	case LookAheadExcessLiquidityC			= "LookAheadExcessLiquidity-C"
	
		///Equity with Loan Value - look ahead Maintenance Margin
	case LookAheadExcessLiquidityS			= "LookAheadExcessLiquidity-S"
	
	
		///Initial margin requirement as of next period's margin change in the base currency of the account
	case LookAheadInitMarginReqC			= "LookAheadInitMarginReq-C"
	
		///Initial margin requirement as of next period's margin change in the base currency of the account
	case LookAheadInitMarginReqS			= "LookAheadInitMarginReq-S"
	
	
		///Maintenance margin requirement as of next period's margin change in the base currency of the account
	case LookAheadMaintMarginReqC			= "LookAheadMaintMarginReq-C"

		///Maintenance margin requirement as of next period's margin change in the base currency of the account
	case LookAheadMaintMarginReqS			= "LookAheadMaintMarginReq-S"
	
		///Maintenance Margin for the commodity segment
	case MaintMarginReqC					= "MaintMarginReq-C"
	
		///Maintenance Margin for the security segment
	case MaintMarginReqS					= "MaintMarginReq-S"
	
		///Market value of money market funds excluding mutual funds
	case MoneyMarketFundValue				= "MoneyMarketFundValue"
	
		///Market value of mutual funds excluding money market funds
	case MutualFundValue					= "MutualFundValue"
	
		///The sum of the Dividend Payable/Receivable Values for the securities and commodities segments of the account
	case NetDividend						= "NetDividend"
	
		///Total cash value + futures PNL + commodities options value
	case NetLiquidationC					= "NetLiquidation-C"
	
		///Total cash value + stock value + securities options value + bond value
	case NetLiquidationS					= "NetLiquidation-S"
	
		///Net liquidation for individual currencies
	case NetLiquidationByCurrency			= "NetLiquidationByCurrency"
	
		///Real-time mark-to-market value of options
	case OptionMarketValue					= "OptionMarketValue"
		
		///Personal Account shares value of whole portfolio
	case PASharesValue						= "PASharesValue"
		
		///Personal Account shares value in commodity segment
	case PASharesValueC						= "PASharesValue-C"
		
		///Personal Account shares value in security segment
	case PASharesValueS						= "PASharesValue-S"
		
		/// Total projected "at expiration" excess liquidity
	case PostExpirationExcess				= "PostExpirationExcess"
		
		///Provides a projected "at expiration" excess liquidity based on the soon-to expire contracts in your portfolio in commodity segment
	case PostExpirationExcessC				= "PostExpirationExcess-C"
		
		///Provides a projected "at expiration" excess liquidity based on the soon-to expire contracts in your portfolio in security segment
	case PostExpirationExcessS				= "PostExpirationExcess-S"
		
		///Total projected "at expiration" margin
	case PostExpirationMargin				= "PostExpirationMargin"
		
		///Provides a projected "at expiration" margin value based on the soon-to expire contracts in your portfolio in commodity segment
	case PostExpirationMarginC				= "PostExpirationMargin-C"
		
		///Provides a projected "at expiration" margin value based on the soon-to expire contracts in your portfolio in security segment
	case PostExpirationMarginS				= "PostExpirationMargin-S"
		
		///Marginable Equity with Loan value as of 16:00 ET the previous day in securities segment
	case PreviousDayEquityWithLoanValue		= "PreviousDayEquityWithLoanValue"
		
		/// IMarginable Equity with Loan value as of 16:00 ET the previous day
	case PreviousDayEquityWithLoanValueS	= "reviousDayEquityWithLoanValue-S"
		
		///Open positions are grouped by currency
	case RealCurrency						= "RealCurrency"
		
		///Shows your profit on closed positions, which is the difference between your entry execution cost and exit execution costs,
		///or (execution price + commissions to open the positions) - (execution price + commissions to close the position)
	case RealizedPnL						= "RealizedPnL"
		
		///Regulation T equity for security segment
	case RegTEquityS						= "RegTEquity-S"
		
		
		///Regulation T margin for security segment
	case RegTMarginS						= "RegTMargin-S"
		
		///Regulation T Special Memorandum Account balance for security segment
	case SMAS								= "SMA-S"
		
		///Account segment name
	case SegmentTitle						= "SegmentTitle"
		
		/// Real-time mark-to-market value of stock
	case StockMarketValue					= "StockMarketValue"
		
		/// Value of treasury bonds
	case TBondValue							= "TBondValue"
		
		///Value of treasury bills
	case TBillValue							= "TBillValue"
		
		///Total Cash Balance including Future PNL
	case TotalCashBalance					= "TotalCashBalance"
				
		/// CashBalance in commodity segment
	case TotalCashValueC					= "TotalCashValue-C"
		
		///CashBalance in security segment
	case TotalCashValueS					= "TotalCashValue-S"
		
		/// Account Type
	case TradingTypeS						= "TradingType-S"
		
		///The difference between the current market value of your open positions and the average cost, or Value - Average Cost
	case UnrealizedPnL						= "UnrealizedPnL"
		
		///Value of warrants
	case WarrantValue						= "WarrantValue"
		
		///To check projected margin requirements under Portfolio Margin model
	case WhatIfPMEnabled					= "WhatIfPMEnabled"
	
	
	
	
				
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
			default:							return rawValue
		}
		
	}
	
}
