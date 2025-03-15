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

public enum IBAccountKey: String, CaseIterable, Codable, Sendable {
	
	//MARK: - account summary keys
	
	///Identifies the IB account structure
	case accountType = "AccountType"
	
	/// The basis for determining the price of the assets in your account.
	///
	/// Total cash value + stock value + options value + bond value
	case netLiquidation = "NetLiquidation"
	
	/// Total cash balance recognized at the time of trade + futures PNL
	case totalCash = "TotalCashValue"
	
	/// Cash recognized at the time of settlement - purchases at the time of trade - commissions - taxes - fees
	case settledCash = "SettledCash"
	
	/// Total accrued cash value of stock, commodities and securities
	case accruedCash = "AccruedCash"
	
	/// Buying power serves as a measurement of the dollar value of securities that one may purchase in a securities account without depositing additional funds
	case buyingPower = "BuyingPower"
	
	/// Determines whether a client has the necessary assets to either initiate or maintain security positions.
	///
	/// Cash + stocks + bonds + mutual funds
	case equityWithLoan = "EquityWithLoanValue"
	
	/// Marginable Equity with Loan value as of 16:00 ET the previous day
	case previousEquityWithLoans = "PreviousEquityWithLoanValue"
	
	/// The sum of the absolute value of all stock and equity option positions
	case grossPosition = "GrossPositionValue"
	
	/// Regulation T equity for universal account
	case regTEquity = "RegTEquity"
	
	/// Regulation T margin for universal account
	case regTMargin = "RegTMargin"
	
	///Special Memorandum Account
	///Line of credit created when the market value of securities in a Regulation T account increase in value
	case sma = "SMA"
	
	/// Initial Margin requirement of whole portfolio
	case initialMargin = "InitMarginReq"
	
	/// Maintenance Margin requirement of whole portfolio
	case maintenanceMargin = "MaintMarginReq"
	
	/// Tells what you have available for trading
	case availableFunds = "AvailableFunds"
	
	/// This value shows your margin cushion, before liquidation
	case excessLiquidity = "ExcessLiquidity"
	
	/// Excess liquidity as a percentage of net liquidation value
	case cushion = "Cushion"
	
	/// Initial Margin of whole portfolio with no discounts or intraday credits
	case fullInitalMargin = "FullInitMarginReq"
	
	/// Maintenance Margin of whole portfolio with no discounts or intraday credits
	case fullMaintenanceMargin = "FullMaintMarginReq"
	
	/// Available funds of whole portfolio with no discounts or intraday credits
	case fullAvailableFunds = "FullAvailableFunds"
	
	///  Excess liquidity of whole portfolio with no discounts or intraday credits
	case fullExcessLiquidity = "FullExcessLiquidity"
	
	/// Time when look-ahead values take effect
	case lookAheadNextTime = "LookAheadNextChange"
	
	///  Initial Margin requirement of whole portfolio as of next period's margin change
	case lookAheadInitalMargin = "LookAheadInitMarginReq"
	
	/// Maintenance Margin requirement of whole portfolio as of next period's margin change
	case lookAheadMaintenaceMargin = "LookAheadMaintMarginReq"
	
	/// This value reflects your available funds at the next margin change
	case lookAheadAvailableFunds = "LookAheadAvailableFunds"
	
	/// This value reflects your excess liquidity at the next margin change
	case lookAheadExcessLiquidity = "LookAheadExcessLiquidity"
	
	/// A measure of how close the account is to liquidation
	case severity = "HighestSeverity"
	
	/// The Number of Open/Close trades a user could put on before Pattern Day Trading is detected.
	/// A value of "-1" means that the user can put on unlimited day trades.
	case dayTradesLeft = "DayTradesRemaining"
	
	/// GrossPositionValue / NetLiquidation
	case leverege = "Leverage"
	
	//MARK: - ACCOUNT UPDATE & ACCOUNT UPDATE MULTI KEYS
	
	case AccountCode = "AccountCode"
	
	case AccountOrGroup = "AccountOrGroup"
	
	case AccountReady = "AccountReady"
	
	case AccruedCashC = "AccruedCash-C"
	
	case AccruedCashS = "AccruedCash-S"
	
	case AccruedDividend = "AccruedDividend"
	
	case AccruedDividendC = "AccruedDividend-C"
	
	case AccruedDividendS = "AccruedDividend-S"
	
	case AvailableFundsC = "AvailableFunds-C"
	
	case AvailableFundsS = "AvailableFunds-S"
	
	case Billable = "Billable"
	
	case BillableC = "Billable-C"
	
	case BillableS = "Billable-S"
	
	case CashBalance = "CashBalance"
	
	case CorporateBondValue = "CorporateBondValue"
	
	case Currency = "Currency"
	
	case DayTradesRemainingT1 = "DayTradesRemainingT+1"
	
	case DayTradesRemainingT2 = "DayTradesRemainingT+2"
	
	case DayTradesRemainingT3 = "DayTradesRemainingT+3"
	
	case DayTradesRemainingT4 = "DayTradesRemainingT+4"
	
	case EquityWithLoanValueC = "EquityWithLoanValue-C"
	
	case EquityWithLoanValueS = "EquityWithLoanValue-S"
	
	case ExcessLiquidityC = "ExcessLiquidity-C"
	
	case ExcessLiquidityS = "ExcessLiquidity-S"
	
	case ExchangeRate = "ExchangeRate"
	
	case FullAvailableFundsC = "FullAvailableFunds-C"
	
	case FullAvailableFundsS = "FullAvailableFunds-S"
	
	case FullExcessLiquidityC = "FullExcessLiquidity-C "
	
	case FullExcessLiquidityS = "FullExcessLiquidity-S"
	
	case FullInitMarginReqC = "FullInitMarginReq-C"
	
	case FullInitMarginReqS = "FullInitMarginReq-S"
	
	case FullMaintMarginReqC = "FullMaintMarginReq-C"
	
	case FullMaintMarginReqS = "FullMaintMarginReq-S"
	
	case FundValue = "FundValue"
	
	case FutureOptionValue = "FutureOptionValue"
	
	case FuturesPNL = "FuturesPNL"
	
	case FxCashBalance = "FxCashBalance"
	
	case GrossPositionValueS = "GrossPositionValue-S"
	
	case IndianStockHaircut = "IndianStockHaircut"
	
	case InitMarginReqC = "InitMarginReq-C"
	
	case InitMarginReqS = "InitMarginReq-S"
	
	case IssuerOptionValue = "IssuerOptionValue"
	
	case LeverageS = "Leverage-S"
	
	case LookAheadAvailableFundsC = "LookAheadAvailableFunds-C"
	
	case LookAheadAvailableFundsS = "LookAheadAvailableFunds-S"
	
	case LookAheadExcessLiquidityC = "LookAheadExcessLiquidity-C"
	
	case LookAheadExcessLiquidityS = "LookAheadExcessLiquidity-S"
	
	case LookAheadInitMarginReqC = "LookAheadInitMarginReq-C"
	
	case LookAheadInitMarginReqS = "LookAheadInitMarginReq-S"
	
	case LookAheadMaintMarginReqC = "LookAheadMaintMarginReq-C"
	
	case LookAheadMaintMarginReqS = "LookAheadMaintMarginReq-S"
	
	case MaintMarginReqC = "MaintMarginReq-C"
	
	case MaintMarginReqS = "MaintMarginReq-S"
	
	case MoneyMarketFundValue = "MoneyMarketFundValue"
	
	case MutualFundValue = "MutualFundValue"
	
	case NetDividend = "NetDividend"
	
	case NetLiquidationC = "NetLiquidation-C"
	
	case NetLiquidationS = "NetLiquidation-S"
	
	case NetLiquidationByCurrency = "NetLiquidationByCurrency"
	
	case OptionMarketValue = "OptionMarketValue"
	
	case PASharesValue = "PASharesValue"
	
	case PASharesValueC = "PASharesValue-C"
	
	case PASharesValueS = "PASharesValue-S"
	
	case PostExpirationExcess = "PostExpirationExcess"
	
	case PostExpirationExcessC = "PostExpirationExcess-C"
	
	case PostExpirationExcessS = "PostExpirationExcess-S"
	
	case PostExpirationMargin = "PostExpirationMargin"
	
	case PostExpirationMarginC = "PostExpirationMargin-C"
	
	case PostExpirationMarginS = "PostExpirationMargin-S"
	
	case PreviousDayEquityWithLoanValue = "PreviousDayEquityWithLoanValue"
	
	case PreviousDayEquityWithLoanValueS = "reviousDayEquityWithLoanValue-S"
	
	case RealCurrency = "RealCurrency"
	
	case RealizedPnL = "RealizedPnL"
	
	case RegTEquityS = "RegTEquity-S"
	
	case RegTMarginS = "RegTMargin-S"
	
	case SMAS = "SMA-S"
	
	case SegmentTitle = "SegmentTitle"
	
	case StockMarketValue = "StockMarketValue"
	
	case TBondValue = "TBondValue"
	
	case TBillValue = "TBillValue"
	
	case TotalCashBalance = "TotalCashBalance"
	
	case TotalCashValueC = "TotalCashValue-C"
	
	case TotalCashValueS = "TotalCashValue-S"
	
	case TradingTypeS = "TradingType-S"
	
	case UnrealizedPnL = "UnrealizedPnL"
	
	case WarrantValue = "WarrantValue"
	
	case WhatIfPMEnabled = "WhatIfPMEnabled"
	
	case Cryptocurrency = "Cryptocurrency"
	
	case ColumnPrioS = "ColumnPrio-S"
	
	case SegmentTitleS = "SegmentTitle-S"
	
	case Guarantee = "Guarantee"
	
	case IncentiveCoupons = "IncentiveCoupons"
	
	case NLVAndMarginInReview = "NLVAndMarginInReview"
	
	case NetLiquidationUncertainty = "NetLiquidationUncertainty"
	
	case PhysicalCertificateValue = "PhysicalCertificateValue"
	
	case TotalDebitCardPendingCharges = "TotalDebitCardPendingCharges"
	
	case AccruedCashP = "AccruedCash-P"
	
	case AccruedDividendP = "AccruedDividend-P"
	
	case AvailableFundsP = "AvailableFunds-P"
	
	case BillableP = "Billable-P"
	
	case ColumnPrioP = "ColumnPrio-P"
	
	case EquityWithLoanValueP = "EquityWithLoanValue-P"
	
	case ExcessLiquidityP = "ExcessLiquidity-P"
	
	case FullAvailableFundsP = "FullAvailableFunds-P"
	
	case FullExcessLiquidityP = "FullExcessLiquidity-P"
	
	case FullInitMarginReqP = "FullInitMarginReq-P"
	
	case FullMaintMarginReqP = "FullMaintMarginReq-P"
	
	case GrossPositionValueP = "GrossPositionValue-P"
	
	case GuaranteeP = "Guarantee-P"
	
	case IncentiveCouponsP = "IncentiveCoupons-P"
	
	case IndianStockHaircutP = "IndianStockHaircut-P"
	
	case InitMarginReqP = "InitMarginReq-P"
	
	case LeverageP = "Leverage-P"
	
	case LookAheadAvailableFundsP = "LookAheadAvailableFunds-P"
	
	case LookAheadExcessLiquidityP = "LookAheadExcessLiquidity-P"
	
	case LookAheadInitMarginReqP = "LookAheadInitMarginReq-P"
	
	case LookAheadMaintMarginReqP = "LookAheadMaintMarginReq-P"
	
	case MaintMarginReqP = "MaintMarginReq-P"
	
	case NetLiquidationP = "NetLiquidation-P"
	
	case PASharesValueP = "PASharesValue-P"
	
	case PhysicalCertificateValueP = "PhysicalCertificateValue-P"
	
	case PostExpirationExcessP = "PostExpirationExcess-P"
	
	case PostExpirationMarginP = "PostExpirationMargin-P"
	
	case SegmentTitleP = "SegmentTitle-P"
	
	case TotalCashValueP = "TotalCashValue-P"
	
	case TotalDebitCardPendingChargesP = "TotalDebitCardPendingCharges-P"
	
}


extension IBAccountKey: CustomStringConvertible {
	public var description: String {
		return self.rawValue
	}
}
