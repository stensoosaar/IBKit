//
//  File.swift
//  
//
//  Created by Sten Soosaar on 28.10.2023.
//

import Foundation


public struct IBAccountValue: Decodable, IBEvent{
	
	public enum AccountKey: String {
		
		///The account ID number
		case AccountCode						= "AccountCode"
		
		//"All" to return account summary data for all accounts, or set to a specific Advisor Account Group name that has already been created in TWS Global Configuration
		case AccountOrGroup						= "AccountOrGroup"
		
		///For internal use only
		case AccountReady	 					= "AccountReady"
		
		///Identifies the IB account structure
		case AccountType 						= "AccountType"
		
		///Total accrued cash value of stock, commodities and securities
		case AccruedCash						= "AccruedCash"
		
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
		
		///This value tells what you have available for trading
		case AvailableFunds						= "AvailableFunds"
		
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
		
		///Cash Account: Minimum (Equity with Loan Value, Previous Day Equity with Loan Value)-Initial Margin,
		///Standard Margin Account: Minimum (Equity with Loan Value, Previous Day Equity with Loan Value) - Initial Margin
		case BuyingPower						= "BuyingPower"
		
		///Cash recognized at the time of trade + futures PNL
		case CashBalance						= "CashBalance"
		
		///Value of non-Government bonds such as corporate bonds and municipal bonds
		case CorporateBondValue					= "CorporateBondValue"
		
		/// Open positions are grouped by currency
		case Currency							= "Currency"
		
		///Excess liquidity as a percentage of net liquidation value
		case Cushion							= "Cushion"
		
		/// Number of Open/Close trades one could do before Pattern Day Trading is detected
		case DayTradesRemaining					= "DayTradesRemaining"
		
		/// Number of Open/Close trades one could do tomorrow before Pattern Day Trading is detected
		case DayTradesRemainingT1				= "DayTradesRemainingT+1"
		
			///Number of Open/Close trades one could do two days from today before Pattern Day Trading is detected
		case DayTradesRemainingT2				= "DayTradesRemainingT+2"
		
			///Number of Open/Close trades one could do three days from today before Pattern Day Trading is detected
		case DayTradesRemainingT3 				= "DayTradesRemainingT+3"
		
			/// Number of Open/Close trades one could do four days from today before Pattern Day Trading is detected
		case DayTradesRemainingT4				= "DayTradesRemainingT+4"
		
			///Forms the basis for determining whether a client has the necessary assets to either initiate or maintain security positions
		case EquityWithLoanValue				= "EquityWithLoanValue"
		
			///Cash account: Total cash value + commodities option value - futures maintenance margin requirement + minimum
		///(0, futures PNL) Margin account: Total cash value + commodities option value - futures maintenance margin requirement
		case EquityWithLoanValueC				= "EquityWithLoanValue-C"
		
			///Cash account: Settled Cash Margin Account: Total cash value + stock value + bond value + (non-U.S. & Canada securities options value)
		case EquityWithLoanValueS				= "EquityWithLoanValue-S"
		
			///This value shows your margin cushion, before liquidation
		case ExcessLiquidity					= "ExcessLiquidity"
		
			///Equity with Loan Value - Maintenance Margin
		case ExcessLiquidityC					= "ExcessLiquidity-C"
		
			///Net Liquidation Value - Maintenance Margin
		case ExcessLiquidityS					= "ExcessLiquidity-S"
		
			///The exchange rate of the currency to your base currency
		case ExchangeRate						= "ExchangeRate"
		
			///Available funds of whole portfolio with no discounts or intraday credits
		case FullAvailableFunds					= "FullAvailableFunds"
		
			///Net Liquidation Value - Full Initial Margin
		case FullAvailableFundsC				= "FullAvailableFunds-C"
		
			///Equity with Loan Value - Full Initial Margin
		case FullAvailableFundsS				= "FullAvailableFunds-S"
		
			/// Excess liquidity of whole portfolio with no discounts or intraday credits
		case FullExcessLiquidity				= "FullExcessLiquidity"
		
			///Net Liquidation Value - Full Maintenance Margin
		case FullExcessLiquidityC 				= "FullExcessLiquidity-C "
		
			///Equity with Loan Value - Full Maintenance Margin
		case FullExcessLiquidityS				= "FullExcessLiquidity-S"
		
			/// Initial Margin of whole portfolio with no discounts or intraday credits
		case FullInitMarginReq					= "FullInitMarginReq"
		
			/// Initial Margin of commodity segment's portfolio with no discounts or intraday credits
		case FullInitMarginReqC					= "FullInitMarginReq-C"
		
			///Initial Margin of security segment's portfolio with no discounts or intraday credits
		case FullInitMarginReqS					= "FullInitMarginReq-S"
		
			///Maintenance Margin of whole portfolio with no discounts or intraday credits
		case FullMaintMarginReq					= "FullMaintMarginReq"
		
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
		
			///Gross Position Value in securities segment
		case GrossPositionValue					= "GrossPositionValue"
		
			///Long Stock Value + Short Stock Value + Long Option Value + Short Option Value
		case GrossPositionValueS				= "GrossPositionValue-S"
		
			///Margin rule for IB-IN accounts
		case IndianStockHaircut					= "IndianStockHaircut"
		
			///Initial Margin requirement of whole portfolio
		case InitMarginReq						= "InitMarginReq"
		
			///Initial Margin of the commodity segment in base currency
		case InitMarginReqC						= "InitMarginReq-C"
		
			///Initial Margin of the security segment in base currency
		case InitMarginReqS						= "InitMarginReq-S"
		
			///Real-time mark-to-market value of Issued Option
		case IssuerOptionValue					= "IssuerOptionValue"
		
			///GrossPositionValue / NetLiquidation in security segment
		case LeverageS							= "Leverage-S"
		
			///Time when look-ahead values take effect
		case LookAheadNextChange				= "LookAheadNextChange"
		
			///This value reflects your available funds at the next margin change
		case LookAheadAvailableFunds			= "LookAheadAvailableFunds"
		
			///Net Liquidation Value - look ahead Initial Margin
		case LookAheadAvailableFundsC			= "LookAheadAvailableFunds-C"
		
			///Equity with Loan Value - look ahead Initial Margin
		case LookAheadAvailableFundsS			= "LookAheadAvailableFunds-S"
		
			///This value reflects your excess liquidity at the next margin change
		case LookAheadExcessLiquidity			= "LookAheadExcessLiquidity"
		
			///Net Liquidation Value - look ahead Maintenance Margin
		case LookAheadExcessLiquidityC			= "LookAheadExcessLiquidity-C"
		
			///Equity with Loan Value - look ahead Maintenance Margin
		case LookAheadExcessLiquidityS			= "LookAheadExcessLiquidity-S"
		
			///Initial margin requirement of whole portfolio as of next period's margin change
		case LookAheadInitMarginReq				= "LookAheadInitMarginReq"
		
			///Initial margin requirement as of next period's margin change in the base currency of the account
		case LookAheadInitMarginReqC			= "LookAheadInitMarginReq-C"
		
			///Initial margin requirement as of next period's margin change in the base currency of the account
		case LookAheadInitMarginReqS			= "LookAheadInitMarginReq-S"
		
			///Maintenance margin requirement of whole portfolio as of next period's margin change
		case LookAheadMaintMarginReq			= "LookAheadMaintMarginReq"
		
			///Maintenance margin requirement as of next period's margin change in the base currency of the account
		case LookAheadMaintMarginReqC			= "LookAheadMaintMarginReq-C"
	
			///Maintenance margin requirement as of next period's margin change in the base currency of the account
		case LookAheadMaintMarginReqS			= "LookAheadMaintMarginReq-S"
	
			/// Maintenance Margin requirement of whole portfolio
		case MaintMarginReq						= "MaintMarginReq"
		
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
		
			///The basis for determining the price of the assets in your account
		case NetLiquidation						= "NetLiquidation"
	
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
			
			///Regulation T equity for universal account
		case RegTEquity							= "RegTEquity"
			
			///Regulation T equity for security segment
		case RegTEquityS						= "RegTEquity-S"
			
			///Regulation T margin for universal account
		case RegTMargin							= "RegTMargin"
			
			///Regulation T margin for security segment
		case RegTMarginS						= "RegTMargin-S"
			
			///Line of credit created when the market value of securities in a Regulation T account increase in value
		case SMA								= "SMA"
			
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
			
			///Total cash value of stock, commodities and securities
		case TotalCashValue						= "TotalCashValue"
			
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

	}
	
	
	
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		let version = try container.decode(Int.self)
		let key = try container.decode(String.self)
		let value = try container.decode(String.self)
		let currency = try container.decode(String.self)
		let accountName = try container.decode(String.self)
	}
	
}


public struct IBAccountValueEnd: Decodable, IBEvent {
	
	public var accountName: String
	
	public init(from decoder: Decoder) throws {
		
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		accountName = try container.decode(String.self)

	}
	
}
