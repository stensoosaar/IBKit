//
//  IBTickType.swift
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

public enum IBTickType: Int, Decodable, Sendable {
	///Number of contracts or lots offered at the bid price.
	case Bid_Size =	0
	
	///Highest priced bid for the contract.
	case Bid = 1
	
	///Lowest price offer on the contract.
	case Ask = 2
	
	///Number of contracts or lots offered at the ask price.
	case Ask_Size = 3
	
	///Last price at which the contract traded (does not include some trades in RTVolume).
	case Last = 4
	
	///Number of contracts or lots traded at the last price.
	case Last_Size = 5
	
	///High price for the day.
	case High_Price =	6
	
	///Low price for the day.
	case Low_Price = 7
	
	///Trading volume for the day for the selected contract (US Stocks volume is display as Round Lots).
	case Volume	= 8
	
	///The last available closing price for the previous day. For US Equities we use corporate action processing
	///to get the closing price so the close price is adjusted to reflect forward and reverse splits and cash and stock dividends.
	case Close_Price = 9
	
	///Computed Greeks and implied volatility based on the underlying stock price and the option bid price. See Option Greeks
	case Bid_Option_Computation	= 10
	
	///Computed Greeks and implied volatility based on the underlying stock price and the option ask price. See Option Greeks
	case Ask_Option_Computation	= 11
	
	///Computed Greeks and implied volatility based on the underlying stock price and the option last traded price. See Option Greeks
	case Last_Option_Computation = 12
	
	///Computed Greeks and implied volatility based on the underlying stock price and the option model price.
	///Correspond to greeks shown in TWS. See Option Greeks
	case Model_Option_Computation = 13
	
	///Current session’s opening price. Before open will refer to previous day. The official opening price requires
	///a market data subscription to the native exchange of the instrument.
	case Open_Price = 14
	
	///Lowest price for the last 13 weeks. For stocks only.
	case Low_13_Weeks = 15
	
	///Highest price for the last 13 weeks. For stocks only.
	case High_13_Weeks = 16
	
	///Lowest price for the last 26 weeks. For stocks only.
	case Low_26_Weeks = 17
	
	///Highest price for the last 26 weeks. For stocks only.
	case High_26_Weeks = 18
	
	///Lowest price for the last 52 weeks. For stocks only.
	case Low_52_Weeks = 19
	
	///Highest price for the last 52 weeks. For stocks only.
	case High_52_Weeks = 20
	
	///The average daily trading volume over 90 days. Multiplier of 100. For stocks only.
	case Average_Volume	= 21
	
	///“(Deprecated not currently in use) Total number of options that are not closed.”
	case Open_Interest = 22
	
	///	The 30-day historical volatility (currently for stocks).
	case Option_Historical_Volatility = 23
	
	///A prediction of how volatile an underlying will be in the future. The IB 30-day volatility is the at-market volatility
	///estimated for a maturity thirty calendar days forward of the current trading day and is based on option prices from two consecutive expiration months.”
	case Option_Implied_Volatility = 24
	
	@available(*, deprecated, message: "Not Used")
	case Option_Bid_Exchange = 25
	
	@available(*, deprecated, message: "Not Used")
	case Option_Ask_Exchange = 26
	
	///Call option open interest.
	case Option_Call_Open_Interest = 27
	
	///Put option open interest.
	case Option_Put_Open_Interest = 28
	
	///Call option volume for the trading day.
	case Option_Call_Volume	= 29
	
	///Put option volume for the trading day.
	case Option_Put_Volume = 30
	
	///The number of points that the index is over the cash index.
	case Index_Future_Premium = 31
	
	///For stock and options identifies the exchange(s) posting the bid price. See Component Exchanges”
	case Bid_Exchange = 32
	
	///For stock and options identifies the exchange(s) posting the ask price. See Component Exchanges”
	case Ask_Exchange = 33
	
	///The number of shares that would trade if no new orders were received and the auction were held now.
	case Auction_Volume	= 34
	
	///The price at which the auction would occur if no new orders were received and the auction were held now-
	///the indicative price for the auction. Typically received after Auction imbalance (tick type 36)
	case Auction_Price = 35
	
	///The number of unmatched shares for the next auction; returns how many more shares are on one side of the
	///auction than the other. Typically received after Auction Volume (tick type 34)
	case Auction_Imbalance = 36
	
	///The mark price is the current theoretical calculated value of an instrument. Since it is a calculated
	///value it will typically have many digits of precision.”
	case Mark_Price	= 37
	
	///Computed EFP bid price
	case Bid_EFP_Computation = 38
	
	///Computed EFP ask price
	case Ask_EFP_Computation = 39
	
	///Computed EFP last price
	case Last_EFP_Computation =	40
	
	///Computed EFP open price
	case Open_EFP_Computation = 41
	
	///Computed high EFP traded price for the day
	case High_EFP_Computation = 42
	
	///Computed low EFP traded price for the day
	case Low_EFP_Computation = 43
	
	///Computed closing EFP price for previous day
	case Close_EFP_Computation = 44
	
	///Time of the last trade (in UNIX time).
	case Last_Timestamp = 45
	
	///Describes the level of difficulty with which the contract can be sold short. See Shortable
	case Shortable_Info = 46
	
	///Last trade details (Including both “”Last”” and “”Unreportable Last”” trades). See RT Volume”
	case RT_Volume_Time_Sales = 48
	
	///Indicates if a contract is halted. See Halted
	case Halted = 49
	
	///Implied yield of the bond if it is purchased at the current bid.
	case Bid_Yield = 50
	
	///Implied yield of the bond if it is purchased at the current ask.
	case Ask_Yield = 51
	
	///Implied yield of the bond if it is purchased at the last price.
	case Last_Yield = 52
	
	///Greek values are based off a user customized price.
	case Custom_Option_Computation = 53
	
	///Trade count for the day.
	case Trade_Count = 54
	
	///Trade count per minute.
	case Trade_Rate = 55
	
	///Volume per minute.
	case Volume_Rate = 56
	
	///Last Regular Trading Hours traded price.
	case Last_RTH_Trade = 57
	
	///30-day real time historical volatility.
	case RT_Historical_Volatility = 58
	
	///Contract’s dividends. See IB Dividends.
	case Dividend_Info = 59
	
	///The bond factor is a number that indicates the ratio of the current bond principal to the original principal
	case Bond_Factor_Multiplier	= 60
	
	///The imbalance that is used to determine which at-the-open or at-the-close orders can be entered following the publishing of the regulatory imbalance.
	case Regulatory_Imbalance = 61
	
	///Contract’s news feed.
	case News = 62
	
	///The past three minutes volume. Interpolation may be applied. For stocks only.
	case Short_Term_Volume_3_Minutes = 63
	
	///The past five minutes volume. Interpolation may be applied. For stocks only.
	case Short_Term_Volume_5_Minutes = 64
	
	///The past ten minutes volume. Interpolation may be applied. For stocks only.
	case Short_Term_Volume_10_Minutes = 65
	
	///Delayed bid price. See Market Data Types.
	case Delayed_Bid = 66
	
	///Delayed ask price. See Market Data Types.
	case Delayed_Ask = 67
	
	///Delayed last traded price. See Market Data Types.
	case Delayed_Last = 68
	
	///Delayed bid size. See Market Data Types.
	case Delayed_Bid_Size = 69
	
	///Delayed ask size. See Market Data Types.
	case Delayed_Ask_Size = 70
	
	///Delayed last size. See Market Data Types.
	case Delayed_Last_Size = 71
	
	///Delayed highest price of the day. See Market Data Types.
	case Delayed_High_Price	= 72
	
	///Delayed lowest price of the day. See Market Data Types
	case Delayed_Low_Price = 73
	
	///Delayed traded volume of the day. See Market Data Types
	case Delayed_Volume	= 74
	
	///The prior day’s closing price.
	case Delayed_Close_Price = 75
	
	///Not currently available
	case Delayed_Open_Price = 76
	
	///Last trade details that excludes “”Unreportable Trades””. See RT Trade Volume”
	case RT_Trade_Volume = 77
	
	///Not currently available
	case Creditman_mark_price = 78
	
	///Slower mark price update used in system calculations
	case Creditman_slow_mark_price = 79
	
	///Computed greeks based on delayed bid price. See Market Data Types and Option Greeks.
	case Delayed_Bid_Option	= 80
	
	///Computed greeks based on delayed ask price. See Market Data Types and Option Greeks.
	case Delayed_Ask_Option	= 81
	
	///Computed greeks based on delayed last price. See Market Data Types and Option Greeks.
	case Delayed_Last_Option = 82
	
	///Computed Greeks and model’s implied volatility based on delayed stock and option prices.
	case Delayed_Model_Option = 83
	
	///Exchange of last traded price
	case Last_Exchange = 84
	
	///Timestamp (in Unix ms time) of last trade returned with regulatory snapshot
	case Last_Regulatory_Time = 85
	
	///Total number of outstanding futures contracts. *HSI open interest requested with generic tick 101
	case Futures_Open_Interest = 86
	
	///Average volume of the corresponding option contracts(TWS Build 970+ is required)
	case Average_Option_Volume = 87
	
	///Delayed time of the last trade (in UNIX time) (TWS Build 970+ is required)
	case Delayed_Last_Timestamp	= 88
	
	///Number of shares available to short (TWS Build 974+ is required)
	case Shortable_Shares = 89
	
	///The last price of Net Asset Value (NAV). For ETFs: Calculation is based on prices of
	///ETF’s underlying securities. For NextShares: Value is provided by NASDAQ
	case ETF_Nav_Last = 96
	
	///ETF Nav Last for Frozen data
	case ETF_Nav_Frozen_Last = 97
	
	///The high price of ETF’s Net Asset Value (NAV)
	case ETF_Nav_High = 98
	
	///The low price of ETF’s Net Asset Value (NAV)
	case ETF_Nav_Low = 99
	
	///Midpoint is calculated based on IPO price range
	case Estimated_IPO_Midpoint = 101
	
	///Final price for IPO
	case Final_IPO_Price = 102
	
	///	Delayed implied yield of the bond if it is purchased at the current bid.
	case Delayed_Yield_Bid = 103
	
	///Delayed implied yield of the bond if it is purchased at the current ask.
	case Delayed_Yield_Ask = 104
}
