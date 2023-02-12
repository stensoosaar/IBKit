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


public enum IBTickType: Int, Codable {
	
	/// Number of contracts or lots offered at the bid price.
	case BidSize								= 0
	
	/// Highest priced bid for the contract.
	case BidPrice								= 1
	
	/// Lowest price offer on the contract.
	case AskPrice								= 2
	
	/// Number of contracts or lots offered at the ask price.
	case AskSize								= 3
	
	/// Last price at which the contract traded (does not include some trades in RTVolume).
	case LastPrice								= 4
	
	/// Number of contracts or lots traded at the last price.
	case LastSize								= 5
	
	/// High price for the day.
	case HighPrice								= 6
	
	/// Low price for the day.
	case LowPrice								= 7
	
	/// Trading volume for the day for the selected contract (US Stocks: multiplier 100).
	case Volume									= 8
	
	/// The last available closing price for the previous day.
	///
	/// For US Equities, we use corporate action processing to get the closing price, so the close price is adjusted to reflect forward and reverse splits and cash and stock and dividends.
	case ClosePrice								= 9
	
	/// Computed Greeks and implied volatility based on the underlying stock price and the option bid price. See Option Greeks
	case BidOptionComputation					= 10
	
	/// Computed Greeks and implied volatility based on the underlying stock price and the option ask price. See Option Greeks
	case AskOptionComputation					= 11
	
	/// Computed Greeks and implied volatility based on the underlying stock price and the option last traded price. See Option Greeks
	case LastOptionComputation					= 12
	
	/// Computed Greeks and implied volatility based on the underlying stock price and the option model price. Correspond to greeks shown in TWS. See Option Greeks
	case ModelOptionComputation					= 13
	
	/// Current session's opening price. Before open will refer to previous day.
	/// The official opening price requires a market data subscription to the native exchange of the instrument.
	case OpenTick								= 14
	
	/// Lowest price for the last 13 weeks. For stocks only.
	case Low13Weeks								= 15
	
	/// Highest price for the last 13 weeks. For stocks only.
	case High13Weeks							= 16
	
	/// Lowest price for the last 26 weeks. For stocks only.
	case Low26Weeks								= 17
	
	/// Highest price for the last 26 weeks. For stocks only.
	case High26Weeks							= 18
	
	/// Lowest price for the last 52 weeks. For stocks only.
	case Low52Weeks								= 19
	
	/// Highest price for the last 52 weeks. For stocks only.
	case High52Weeks							= 20
	
	/// The average daily trading volume over 90 days. Multiplier of 100. For stocks only.
	case AverageVolume							= 21
	
	/// (Deprecated, not currently in use) Total number of options that are not closed.
	case OpenInterest							= 22
	
	/// The 30-day historical volatility (currently for stocks).
	case OptionHistoricalVolatility				= 23
	
	/// A prediction of how volatile an underlying will be in the future.
	///
	/// The IB 30-day volatility is the at-market volatility estimated for a maturity thirty calendar days forward of the current trading day, and is based on option prices from two consecutive expiration months.
	case OptionImpliedVolatility					= 24
	
	/// Not Used.
	case OptionBidExchange							= 25
	
	/// Not Used.
	case OptionAskExchange							= 26
	
	/// Call option open interest.
	case OptionCallOpenInterest						= 27
	
	/// Put option open interest.
	case OptionPutOpenInterest						= 28
	
	/// Call option volume for the trading day.
	case OptionCallVolume							= 29
	
	/// Put option volume for the trading day.
	case OptionPutVolume							= 30
	
	/// The number of points that the index is over the cash index.
	case IndexFuturePremium							= 31
	
	/// For stock and options, identifies the exchange(s) posting the bid price. See Component Exchanges
	case BidExchange								= 32
	
	/// For stock and options, identifies the exchange(s) posting the ask price. See Component Exchanges
	case AskExchange								= 33
	
	/// The number of shares that would trade if no new orders were received and the auction were held now.
	case AuctionVolume								= 34
	
	/// The price at which the auction would occur if no new orders were received and the auction were held now- the indicative price for the auction. Typically received after Auction imbalance (tick type 36)
	case AuctionPrice								= 35
	
	/// The number of unmatched shares for the next auction; returns how many more shares are on one side of the auction than the other. Typically received after Auction Volume (tick type 34)
	case AuctionImbalance							= 36
	
	/// The mark price is the current theoretical calculated value of an instrument. Since it is a calculated value, it will typically have many digits of precision.
	case MarkPrice									= 37
	
	/// Computed EFP bid price
	case BidEFPComputation							= 38
	
	/// Computed EFP ask price
	case AskEFPComputation							= 39
	
	/// Computed EFP last price
	case LastEFPComputation							= 40
	
	/// Computed EFP open price
	case OpenEFPComputation							= 41
	
	/// Computed high EFP traded price for the day
	case HighEFPComputation							= 42
	
	/// Computed low EFP traded price for the day
	case LowEFPComputation							= 43
	
	/// Computed closing EFP price for previous day
	case CloseEFPComputation						= 44
	
	/// Time of the last trade (in UNIX time).
	case LastTimestamp								= 45
	
	/// Describes the level of difficulty with which the contract can be sold short. See Shortable
	case Shortable									= 46
	
	/// Last trade details (Including both "Last" and "Unreportable Last" trades). See RT Volume
	case RTVolumeTimeAndSales						= 48
	
	/// Indicates if a contract is halted. See Halted
	case Halted										= 49
	
	/// Implied yield of the bond if it is purchased at the current bid.
	case BidYield									= 50
	
	/// Implied yield of the bond if it is purchased at the current ask.
	case AskYield									= 51
	
	/// Implied yield of the bond if it is purchased at the last price.
	case LastYield									= 52
	
	/// Greek values are based off a user customized price.
	case CustomOptionComputation					= 53
	
	/// Trade count for the day.
	case TradeCount									= 54
	
	/// Trade count per minute.
	case TradeRate									= 55
	
	/// Volume per minute.
	case VolumeRate									= 56
	
	/// Last Regular Trading Hours traded price.
	case LastRTHTrade								= 57
	
	/// 30-day real time historical volatility.
	case RTHistoricalVolatility						= 58
	
	/// Contract's dividends. See IB Dividends.
	case Dividends									= 59
	
	/// The bond factor is a number that indicates the ratio of the current bond principal to the original principal
	case BondFactorMultiplier						= 60
	
	/// The imbalance that is used to determine which at-the-open or at-the-close orders can be entered following the publishing of the regulatory imbalance.
	case RegulatoryImbalance						= 61
	
	/// Contract's news feed.
	case News										= 62
	
	/// The past three minutes volume. Interpolation may be applied. For stocks only.
	case ShortTermVolume3Minutes					= 63
	
	/// The past five minutes volume. Interpolation may be applied. For stocks only.
	case ShortTermVolume5Minutes					= 64
	
	/// The past ten minutes volume. Interpolation may be applied. For stocks only.
	case ShortTermVolume10Minutes					= 65
	
	/// Delayed bid price. See Market Data Types.
	case DelayedBid									= 66
	
	/// Delayed ask price. See Market Data Types.
	case DelayedAsk									= 67
	
	/// Delayed last traded price. See Market Data Types.
	case DelayedLast								= 68
	
	/// Delayed bid size. See Market Data Types.
	case DelayedBidSize								= 69
	
	/// Delayed ask size. See Market Data Types.
	case DelayedAskSize								= 70
	
	/// Delayed last size. See Market Data Types.
	case DelayedLastSize							= 71
	
	/// Delayed highest price of the day. See Market Data Types.
	case DelayedHighPrice							= 72
	
	/// Delayed lowest price of the day. See Market Data Types
	case DelayedLowPrice							= 73
	
	/// Delayed traded volume of the day. See Market Data Types
	case DelayedVolume								= 74
	
	/// The prior day's closing price.
	case DelayedClose								= 75
	
	/// Not currently available
	case DelayedOpen								= 76
	
	/// Last trade details that excludes "Unreportable Trades". See RT Trade Volume
	case RTTradeVolume								= 77
	
	/// Not currently available
	case CreditmanMarkPrice							= 78
	
	/// Slower mark price update used in system calculations
	case CreditmanSlowMarkPrice						= 79
	
	/// Computed greeks based on delayed bid price. See Market Data Types and Option Greeks.
	case DelayedBidOption							= 80
	
	/// Computed greeks based on delayed ask price. See Market Data Types and Option Greeks.
	case DelayedAskOption							= 81
	
	/// Computed greeks based on delayed last price. See Market Data Types and Option Greeks.
	case DelayedLastOption							= 82
	
	///Computed Greeks and model's implied volatility based on delayed stock and option prices.
	case DelayedModelOption							= 83
	
	/// Exchange of last traded price
	case LastExchange								= 84
	
	/// Timestamp (in Unix ms time) of last trade returned with regulatory snapshot
	case LastRegulatoryTime							= 85
	
	/// Total number of outstanding futures contracts (TWS v965+).
	///
	/// *HSI open interest requested with generic tick 101
	case FuturesOpenInterest						= 86
	
	/// Average volume of the corresponding option contracts(TWS Build 970+ is required)
	case AverageOptionVolume						= 87
	
	/// Delayed time of the last trade (in UNIX time) (TWS Build 970+ is required)
	case DelayedLastTimestamp						= 88
	
	/// Number of shares available to short (TWS Build 974+ is required)
	case ShortableShares							= 89
	
	/// Today's closing price of ETF's Net Asset Value (NAV).
	///
	/// Calculation is based on prices of ETF's underlying securities.
	case ETFNavClose								= 92
	
	/// Yesterday's closing price of ETF's Net Asset Value (NAV).
	///
	/// Calculation is based on prices of ETF's underlying securities.
	case ETFNavPriorClose							= 93
	
	/// The bid price of ETF's Net Asset Value (NAV).
	///
	/// Calculation is based on prices of ETF's underlying securities.
	case ETFNavBid									= 94
	
	/// The ask price of ETF's Net Asset Value (NAV).
	///
	/// Calculation is based on prices of ETF's underlying securities.
	case ETFNavAsk									= 95
	
	/// The last price of Net Asset Value (NAV). For ETFs:
	///
	/// Calculation is based on prices of ETF's underlying securities. For NextShares: Value is provided by NASDAQ
	case ETFNavLast									= 96
	
	/// ETF Nav Last for Frozen data
	case ETFNavFrozenLast							= 97
	
	/// The high price of ETF's Net Asset Value (NAV)
	case ETFNavHigh									= 98
	
	/// The low price of ETF's Net Asset Value (NAV)
	case ETFNavLow									= 99
	
	/// Midpoint is calculated based on IPO price range
	case EstimatedIPOMidpoint						= 101
	
	/// Final price for IPO
	case FinalIPOPrice								= 102
	
	
	var subsccriptionCode: Int? {
		
		switch self {
			case .OptionCallVolume:				return 100
			case .OptionPutVolume:				return 100
			case .OptionCallOpenInterest:		return 101
			case .OptionPutOpenInterest:		return 101
			case .OptionHistoricalVolatility:	return 104
			case .AverageOptionVolume:			return 105
			case .OptionImpliedVolatility:		return 106
			case .IndexFuturePremium:			return 162
			case .Low13Weeks:					return 165
			case .High13Weeks:					return 165
			case .Low26Weeks:					return 165
			case .High26Weeks:					return 165
			case .Low52Weeks:					return 165
			case .High52Weeks:					return 165
			case .AverageVolume:				return 165
			case .AuctionVolume:				return 225
			case .AuctionPrice:					return 225
			case .AuctionImbalance:				return 225
			case .RegulatoryImbalance:			return 225
			case .MarkPrice:					return 232
			case .RTVolumeTimeAndSales:			return 233
			case .Shortable:					return 236
			case .ShortableShares:				return 236
			case .News:							return 292
			case .TradeCount:					return 293
			case .TradeRate:					return 294
			case .VolumeRate:					return 295
			case .LastRTHTrade:					return 318
			case .RTTradeVolume:				return 375
			case .RTHistoricalVolatility:		return 411
			case .Dividends:					return 456
			case .BondFactorMultiplier:			return 460
			case .ETFNavBid:					return 576
			case .ETFNavAsk:					return 576
			case .ETFNavLast:					return 577
			case .ETFNavClose:					return 578
			case .ETFNavPriorClose:				return 578
			case .EstimatedIPOMidpoint:			return 586
			case .FinalIPOPrice:				return 586
			case .FuturesOpenInterest:			return 588
			case .ShortTermVolume3Minutes:		return 595
			case .ShortTermVolume5Minutes:		return 595
			case .ShortTermVolume10Minutes:		return 595
			case .ETFNavHigh:					return 614
			case .ETFNavLow:					return 614
			case .CreditmanSlowMarkPrice:		return 619
			case .ETFNavFrozenLast:				return 623
			default: 							return nil
		}
		
	}
	
	var isDelayed: Bool {
		
		let arr:[IBTickType] = [
			.DelayedAsk,
			.DelayedBid,
			.DelayedLast,
			.DelayedAskSize,
			.DelayedBidSize,
			.DelayedLastSize,
			.DelayedOpen,
			.DelayedClose,
			.DelayedLowPrice,
			.DelayedHighPrice
		]
		
		return arr.contains(self)
		
	}
	
	
	
}
