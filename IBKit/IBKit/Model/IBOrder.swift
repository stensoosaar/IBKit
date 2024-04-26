//
//  IBOrder.swift
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



public struct IBOrder {
	
	public enum Status:String, Codable {
		case ApiPending 		= "ApiPending"
		case ApiCancelled		= "ApiCancelled"
		case PreSubmitted		= "PreSubmitted"
		case PendingCancel		= "PendingCancel"
		case Cancelled			= "Cancelled"
		case Submitted			= "Submitted"
		case Filled				= "Filled"
		case Inactive			= "Inactive"
		case PendingSubmit		= "PendingSubmit"
		case Unknown			= "Unknown"
	}
		
	/// The API client's order id.
	public var orderId: Int = 0
	
	/// The API client id which placed the order.
	public var clientId: Int = 0
	
	/// The Host order identifier.
	public var permId: Int = 0
	
	/// Identifies the side. Generally available values are BUY, SELL. Additionally, SSHORT, SLONG are available in some institutional-accounts only.
	/// For general account types, a SELL order will be able to enter a short position automatically if the order quantity is larger than your current long position. SSHORT is only supported for
	///  institutional account configured with Long/Short account segments or clearing with a separate account. SLONG is available in specially-configured institutional accounts to indicate that long
	///  position not yet delivered is being sold.
	public var action: IBAction
	
	/// The number of positions being bought/sold.
	public var totalQuantity: Double = 0
	
	public enum OrderType: String, Codable {
		case market                 = "MKT"
		case limit                  = "LMT"
		case stop                   = "STP"
		case stopLimit              = "STP LMT"
		case relative               = "REL"
		case trailing               = "TRAIL"
		case boxTop                 = "BOX TOP"
		case FIX_PEGGED             = "FIX PEGGED"
		case limitIfTouched         = "LIT"
		case LMT_PLUS_MKT           = "LMT + MKT"
		case limitOnClose           = "LOC"
		case marketIfTouched        = "MIT"
		case MKT_PRT                = "MKT PRT"
		case marketOnClose          = "MOC"
		case marketToLimit          = "MTL"
		case PASSV_REL              = "PASSV REL"
		case PEG_BENCH              = "PEG BENCH"
		case PEG_MID                = "PEG MID"
		case PEG_MKT                = "PEG MKT"
		case PEG_PRIM               = "PEG PRIM"
		case PEG_STK                = "PEG STK"
		case REL_PLUS_LMT           = "REL + LMT"
		case REL_PLUS_MKT           = "REL + MKT"
		case SNAP_MID               = "SNAP MID"
		case SNAP_MKT               = "SNAP MKT"
		case SNAP_PRIM              = "SNAP PRIM"
		case STP_PRT                = "STP PRT"
		case TRAIL_LIMIT            = "TRAIL LIMIT"
		case TRAIL_LIT              = "TRAIL LIT"
		case TRAIL_LMT_PLUS_MKT     = "TRAIL LMT + MKT"
		case TRAIL_MIT              = "TRAIL MIT"
		case TRAIL_REL_PLUS_MKT     = "TRAIL REL + MKT"
		case VOL                    = "VOL"
		case VWAP                   = "VWAP"
		case QUOTE                  = "QUOTE"
		case PEG_PRIM_VOL           = "PPV"
		case PEG_MID_VOL            = "PDV"
		case PEG_MKT_VOL            = "PMV"
		case PEG_SRF_VOL            = "PSV"
		
	}
	
	/// The order's type.
	public var orderType: OrderType
	
	/// Used for limit, stop-limit and relative orders. In all other cases specify zero. For relative orders with no limit price, also specify zero.
	public var lmtPrice: Double?
	
	/// Generic field to contain the stop price for STP LMT orders, trailing amount, etc.
	public var auxPrice: Double?
	
	public enum TimeInForce: String, Codable {
		
		/// Valid for the day only.
		case day 				= "DAY"
		
		/// Good until canceled. The order will continue to work within the system and in the marketplace until it executes or is canceled.
		/// GTC orders will be automatically be cancelled under the following conditions: If a corporate action on a security results in a stock
		/// split (forward or reverse), exchange for shares, or distribution of shares. If you do not log into your IB account for 90 days.
		case untilCancelled 	= "GTC"
		
		/// Immediate or Cancel. Any portion that is not filled as soon as it becomes available in the market is canceled.
		case immidiateOrCancel 	= "IOC"
		
		/// Good until Date. It will remain working within the system and in the marketplace until it executes or until the close of the market on the date specified
		case goodTilDate 		= "GTD"
		
		/// Fill-or-Kill order does not execute as soon as it becomes available, the entire order is canceled.
		case fillOrKill			= "FOK"
		
		///  Day until Canceled
		case dayTilCanceled		= "DTC"

	}

	/// Generic field to contain the stop price for STP LMT orders, trailing amount, etc.
	public var tif: TimeInForce = .untilCancelled
	
	///
	public var activeStartTime: Date?     // for GTC orders
	
	///
	public var activeStopTime: Date?      // for GTC orders
	
	/// One-Cancels-All group identifier.
	public var ocaGroup:String?            // one cancels all group name
	
	public enum OCAType: Int, Codable {
		
		/// Cancel all remaining orders with block.
		case cancelBlock 		= 1
		
		/// Remaining orders are proportionately reduced in size with block.
		case reduceWithBlock 	= 2
		
		/// Remaining orders are proportionately reduced in size with no block.
		case reduceNoBlock 		= 3
		
	}
	
	/// Tells how to handle remaining orders in an OCA group when one order or part of an order executes. If you use a value "with block" it gives
	/// the order overfill protection. This means that only one order in the group will be routed at a time to remove the possibility of an overfill.
	public var ocaType: OCAType?
	
	/// The order reference. Intended for institutional customers only, although all customers may use it to identify the API client that sent the
	/// order when multiple API clients are running.
	public var orderRef: String?
	
	/// Specifies whether the order will be transmitted by TWS. If set to false, the order will be created at TWS but will not be sent.
	public var transmit: Bool = true
	
	/// The order ID of the parent order, used for bracket and auto trailing stop orders.
	public var parentId: Int = 0
	
	/// If set to true, specifies that the order is an ISE Block order.
	public var blockOrder: Bool = false
	
	/// If set to true, specifies that the order is a Sweep-to-Fill order.
	public var sweepToFill: Bool = false
	
	/// The publicly disclosed order size, used when placing Iceberg orders.
	public var displaySize: Int?
	
	public enum TriggerMethod: Int, Codable {
				
		/// stop orders are triggered based on two consecutive bid or ask prices.
		case doubleBidAsk 	= 1
		
		/// stop orders are triggered based on the last price.
		case last 			= 2
		
		/// 3 double last function.
		case doubleLast 	= 3
		
		/// 4 bid/ask function.
		case bidAsk 		= 4
		
		/// 7 last or bid/ask function.
		case lastOrBidAsk 	= 7
		
		/// 8 mid-point function
		case midPoint 		= 8
		
	}

	/// Specifies how Simulated Stop, Stop-Limit and Trailing Stop orders are triggered. Valid values are:
	public var triggerMethod: TriggerMethod?
	
	/// If set to true, allows orders to also trigger or fill outside of regular trading hours.
	public var outsideRth: Bool = false
	
	/// If set to true, the order will not be visible when viewing the market depth. This option only applies to orders routed to the ISLAND exchange.
	public var hidden: Bool = false
	
	/// Specifies the date and time after which the order will be active. Format: yyyymmdd hh:mm:ss {optional Timezone}.
	public var goodAfterTime: Date?
	
	/// The date and time until the order will be active. You must enter GTD as the time in force to use this string.
	/// The trade's "Good Till Date," format "YYYYMMDD hh:mm:ss (optional time zone)".
	public var goodTillDate:Date?
	
	public enum Rule80A:String,Codable {
		case individual				= "I"
		case agency					= "A"
		case agentOtherMember		= "W"
		case individualPTIA			= "J"
		case agencyPTIA				= "U"
		case agentOtherMemberPTIA	= "M"
		case individualPT			= "K"
		case agencyPT				= "Y"
		case agentOtherMemberPT		= "N"
		case unknown				= ""
	}

	///
	public var rule80A:Rule80A?
	
	/// Indicates whether or not all the order has to be filled on a single execution.
	public var allOrNone: Bool = false
	
	/// Identifies a minimum quantity order type.
	public var minQty: Int?
	
	/// The percent offset amount for relative orders.
	public var percentOffset: Double?
	
	/// Overrides TWS constraints. Precautionary constraints are defined on the TWS Presets page, and help ensure tha tyour price and
	/// size order values are reasonable. Orders sent from the API are also validated against these safety constraints, and may be rejected
	/// if any constraint is violated. To override validation, set this parameter’s value to True.
	public var overridePercentageConstraints: Bool = false
	
	/// Trail stop price for TRAILIMIT orders.
	public var trailStopPrice: Double?
	
	/// Specifies the trailing amount of a trailing stop order as a percentage. Observe the following guidelines when using the trailingPercent field:
	public var trailingPercent: Double?
	
	//MARK: -financial advisors only
	
	/// The Financial Advisor group the trade will be allocated to. Use an empty string if not applicable.
	public var faGroup: String?
	
	/// The Financial Advisor allocation profile the trade will be allocated to. Use an empty string if not applicable.
	public var faProfile: String?
	
	/// The Financial Advisor allocation method the trade will be allocated to. Use an empty string if not applicable.
	public var faMethod: String?
	
	/// The Financial Advisor percentage concerning the trade's allocation. Use an empty string if not applicable.
	public var faPercentage: String?
	
	//MARK: -institutional (ie non-cleared) only
	
	/// Used only when shortSaleSlot is 2. For institutions only. Indicates the location where the shares to short come from.
	/// Used only when short sale slot is set to 2 (which means that the shares to short are held elsewhere and not with IB).
	public var designatedLocation: String?
	
	public enum OpenClose:String, Codable{
		case open 	= "O"
		case close 	= "C"
	}

	/// For institutional customers only. Valid values are O (open), C (close). Available for institutional clients to determine
	/// if this order is to open or close a position. When Action = "BUY" and OpenClose = "O" this will open a new position.
	/// When Action = "BUY" and OpenClose = "C" this will close an existing short position.
	public var openClose:OpenClose?
	
	public enum Origin: Int, Codable {
		case customer 		= 0
		case firm 			= 1
		case unknown 		= 2
	}
	
	/// The order's origin. Same as TWS "Origin" column. Identifies the type of customer from which the order originated. Valid values are 0 (customer), 1 (firm).
	public var origin: Origin = .customer  // 0=Customer, 1=Firm
	
	/// For institutions only. Valid values are: 1 (broker holds shares) or 2 (shares come from elsewhere).
	public var shortSaleSlot = 0    // type: int; 1 if you hold the shares, 2 if they will be delivered from elsewhere.  Only for Action=SSHORT
	
	/// Only available with IB Execution-Only accounts with applicable securities Mark order as exempt from short sale uptick rule.
	public var exemptCode:Int = -1
	
	//MARK: -SMART routing only
	
	/// The amount off the limit price allowed for discretionary orders.
	public var discretionaryAmt: Double = 0
	
	/// Trade with electronic quotes.
	public var eTradeOnly: Bool = true
	
	/// Trade with firm quotes.
	public var firmQuoteOnly: Bool = true
	
	/// Maximum smart order distance from the NBBO.
	public var nbboPriceCap: Double?
	
	/// Use to opt out of default SmartRouting for orders routed directly to ASX.
	///  This attribute defaults to false unless explicitly set to true.
	///  When set to false, orders routed directly to ASX will NOT use SmartRouting.
	///  When set to true, orders routed directly to ASX orders WILL use SmartRouting.
	public var optOutSmartRouting:Bool?
	
	//MARK:  -BOX exchange orders only
	
	public enum AuctionStrategy: Int, Codable {
		case unset			= 0
		case match			= 1
		case improvement	= 2
		case transparent	= 3
		
	}
	
	/// For BOX orders only.
	public var auctionStrategy: AuctionStrategy?
	
	/// The auction's starting price. For BOX orders only.
	public var startingPrice: Double?
	
	/// The stock's reference price.
	/// The reference price is used for VOL orders to compute the limit price sent to an exchange (whether or not Continuous Update is selected), and for price range monitoring.
	public var stockRefPrice: Double?
	
	/// The stock's Delta. For orders on BOX only.
	public var delta: Double?
	
	//MARK:  -pegged to stock and VOL orders only
	
	/// The lower value for the acceptable underlying stock price range. For price improvement option orders on BOX and VOL orders with dynamic management.
	public var stockRangeLower: Double?
	
	/// The upper value for the acceptable underlying stock price range. For price improvement option orders on BOX and VOL orders with dynamic management.
	public var stockRangeUpper: Double?
	
	///
	public var randomizePrice: Bool = false
	public var randomizeSize: Bool = false
	
	//MARK: -VOLATILITY ORDERS ONLY
	
	public enum VolaitilityType: Int, Codable {
		case daily 		= 1
		case annual 	= 2
	}
	
	/// The option price in volatility, as calculated by TWS' Option Analytics. This value is expressed as a percent
	/// and is used to calculate the limit price sent to the exchange.
	public var volatility: Double?
	
	/// Values include: 1 - Daily Volatility 2 - Annual Volatility.
	public var volatilityType: VolaitilityType?
	
	/// Enter an order type to instruct TWS to submit a delta neutral trade on full or partial execution
	/// of the VOL order. VOL orders only. For no hedge delta order to be sent, specify NONE.
	public var deltaNeutralOrderType: String?
	
	/// Use this field to enter a value if the value in the deltaNeutralOrderType
	/// field is an order type that requires an Aux price, such as a REL order. VOL orders only.
	public var deltaNeutralAuxPrice: Double?
	
	public var deltaNeutralConId: Int?
	
	public var deltaNeutralSettlingFirm: String?
	
	public var deltaNeutralClearingAccount: String?
	
	public var deltaNeutralClearingIntent: String?
	
	/// Specifies whether the order is an Open or a Close order and is used when the hedge involves a CFD and and the order is clearing away.
	public var deltaNeutralOpenClose:String?
	
	/// Used when the hedge involves a stock and indicates whether or not it is sold short.
	public var deltaNeutralShortSale:Bool = false
	
	/// Has a value of 1 (the clearing broker holds shares) or 2 (delivered from a third party).
	/// If you use 2, then you must specify a deltaNeutralDesignatedLocation.
	public var deltaNeutralShortSaleSlot:Int?
	
	public var deltaNeutralDesignatedLocation:String?
	
	public var continuousUpdate:Bool = false
	
	public enum ReferencePriceType:Int,Codable{
		case average 	= 1
		case bidOrAsk 	= 2
	}
	
	
	public var referencePriceType: ReferencePriceType?
	
	//MARK: - COMBO ORDERS ONLY
	
	/// EFP oredrs only
	public var basisPoints: Double?
	
	/// EFP orders only
	public var basisPointsType: Int?
	
	//MARK: - SCALE ORDERS ONLY
	
	/// Defines the size of the first, or initial, order component. For Scale orders only.
	public var scaleInitLevelSize:Int?
	
	/// Defines the order size of the subsequent scale order components. For Scale orders only. Used in conjunction with scaleInitLevelSize().
	public var scaleSubsLevelSize:Int?
	
	/// Defines the price increment between scale components. For Scale orders only. This value is compulsory.
	public var scalePriceIncrement:Double?
	
	public var scalePriceAdjustValue:Double?
	
	public var scalePriceAdjustInterval:Int?
	
	public var scaleProfitOffset:Double?
	
	public var scaleAutoReset:Bool = false
	
	public var scaleInitPosition:Int?
	
	public var scaleInitFillQty:Int?
	
	public var scaleRandomPercent:Bool = false
	
	public var scaleTable = ""
	
	//MARK: -HEDGE ORDERS
	
	public enum HedgeType:String, Codable {
		case delta		= "D"
		case beta 		= "B"
		case forex 		= "F"
		case pair 		= "P"
		
		var hedgeParameter: String? {
			switch self{
				case .beta: return "Beta = x"
				case .pair:	return "ratio = y"
				default: return nil
			}
		}
	}
	
	/// For hedge orders
	public var hedgeType: HedgeType?
	
	/// Beta = x for Beta hedge orders, ratio = y for Pair hedge order
	public var hedgeParam: String?
	
	//MARK: -Clearing info
	
	/// The account the trade will be allocated to.
	public var account: String?
	
	/// Institutions only. Indicates the firm which will settle the trade.
	public var settlingFirm: String?
	
	/// Specifies the true beneficiary of the order. For IBExecution customers.
	/// This value is required for FUT/FOP orders for reporting to the exchange.
	public var clearingAccount: String?
	
	/// For exeuction-only clients to know where do they want their shares to be cleared at.
	/// Valid values are: IB, Away, and PTA (post trade allocation).
	public enum ClearingIntent: String, Codable{
		case ib						= "IB"
		case away					= "Away"
		case postTradeAllocation 	= "PTA"
	}
	
	public var clearingIntent: ClearingIntent?
	
	//MARK: -ALGO ORDERS ONLY
	
	public enum AlgoStrategy: String, Codable {
		case arrivalPrive 				= "arrivalPx"
		case darkIce 					= "DarkIce"
		case volumePercentage 			= "PctVol"
		case timeWeightedAveragePrice	= "Twap"
		case volumeWeightedAveragePrice = "Vwap"
	}

	
	/// The algorithm strategy. As of API verion 9.6, the following algorithms are supported
	public var algoStrategy:AlgoStrategy?
	
	///
	public var algoParams:[String:String]?
	
	///
	public var smartComboRoutingParams:[String:String]?
	
	/// ??
	public var algoId:String?
	
	//MARK: -What-if
	
	/// Allows to retrieve the commissions and margin information.
	/// When placing an order with this attribute set to true, the order will not be placed as such.
	/// Instead it will used to request the commissions and margin information that would result from this order.
	public var whatIf:Bool = false
	
	//MARK: _Not Held
	
	/// Orders routed to IBDARK are tagged as “post only” and are held in IB's order book,
	/// where incoming SmartRouted orders from other IB customers are eligible to trade against them.
	/// For IBDARK orders only.
	public var notHeld:Bool = false
	
	/// ??
	public var solicited:Bool = false
	
	//MARK: -models
	
	/// Model code
	public var modelCode:String?
	
	
	public struct SoftDollarTier: Codable {
		
		var value: String
		var name: String
		var displayName: String
		
		init(name:String, value:String, displayName:String) {
			self.value = value
			self.name = name
			self.displayName = displayName
		}
		
		public init(from decoder: Decoder) throws {
			var container = try decoder.unkeyedContainer()
			self.name = try container.decode(String.self)
			self.value = try container.decode(String.self)
			self.displayName = try container.decode(String.self)
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.unkeyedContainer()
			try container.encode(name.self)
			try container.encode(value.self)
			try container.encode(displayName.self)
		}

		
	}
	/// Define the Soft Dollar Tier used for the order. Only provided for registered professional advisors and hedge and mutual funds.
	public var softDollarTier:SoftDollarTier?
	
	//MARK: -order combo legs
	
	public struct ComboLeg: Codable {
		
		/// The order's leg's price.
		public var price:Double
		
		public init(price:Double) {
			self.price=price
		}
		
		public init(from decoder: Decoder) throws {
			var container = try decoder.unkeyedContainer()
			self.price = try container.decode(Double.self)
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.unkeyedContainer()
			try container.encode(price)
		}
		
	}
	
	/// List of Per-leg price following the same sequence combo legs are added. The combo price must be left unspecified when using per-leg prices.
	public var orderComboLegs:[ComboLeg]?
	
	/// ??
	public var orderMiscOptions: [String:String]?
	
	//MARK: - VER PEG2BENCH fields:
	
	/// Pegged-to-benchmark orders: this attribute will contain the conId of the contract against which the order will be pegged.
	public var referenceContractId: Int = 0
	
	/// Pegged-to-benchmark orders: amount by which the order's pegged price should move.
	public var peggedChangeAmount: Double = 0.0
	
	/// Pegged-to-benchmark orders: indicates whether the order's pegged price should increase or decreases.
	public var isPeggedChangeAmountDecrease: Bool = false
	
	/// Pegged-to-benchmark orders: the amount the reference contract needs to move to adjust the pegged order.
	public var referenceChangeAmount: Double = 0.0
	
	/// Pegged-to-benchmark orders: the exchange against which we want to observe the reference contract.
	public var referenceExchangeId: String?
	
	/// Adjusted Stop orders: the parent order will be adjusted to the given type when the adjusted trigger price is penetrated.
	public var adjustedOrderType: String?
	
	/// ??
	public var triggerPrice: Double?
	
	/// Adjusted Stop orders: specifies the stop price of the adjusted (STP) parent.
	public var adjustedStopPrice: Double?
	
	/// Adjusted Stop orders: specifies the stop limit price of the adjusted (STPL LMT) parent.
	public var adjustedStopLimitPrice: Double?
	
	/// Adjusted Stop orders: specifies the trailing amount of the adjusted (TRAIL) parent.
	public var adjustedTrailingAmount: Double?
	
	/// Adjusted Stop orders: specifies where the trailing unit is an amount (set to 0) or a percentage (set to 1)
	public var adjustableTrailingUnit: Int?
	
	/// ???
	public var lmtPriceOffset: Double?
	
	/// Conditions determining when the order will be activated or canceled.
	public var conditions: IBCondition?
	
	/// Conditions can determine if an order should become active or canceled.
	public var conditionsCancelOrder: Bool = false
	
	/// Indicates whether or not conditions will also be valid outside Regular Trading Hours.
	public var conditionsIgnoreRth: Bool = false
	
	// ext operator
	public var extOperator: String = ""
	
	// native cash quantity
	public var cashQuantity: Double?
	
	/// Identifies a person as the responsible party for investment decisions within the firm.
	/// Orders covered by MiFID 2 (Markets in Financial Instruments Directive 2) must include either Mifid2DecisionMaker or Mifid2DecisionAlgo field (but not both).
	/// Requires TWS 969+.
	public var mifid2DecisionMaker: String?
	
	/// Identifies the algorithm responsible for investment decisions within the firm. Orders covered under MiFID 2 must include either Mifid2DecisionMaker or Mifid2DecisionAlgo, but cannot have both. Requires TWS 969+.
	public var mifid2DecisionAlgo: String?
	
	/// For MiFID 2 reporting; identifies a person as the responsible party for the execution of a transaction within the firm. Requires TWS 969+.
	public var mifid2ExecutionTrader: String?
	
	/// For MiFID 2 reporting; identifies the algorithm responsible for the execution of a transaction within the firm. Requires TWS 969+.
	public var mifid2ExecutionAlgo: String?

	/// Don't use auto price for hedge.
	public var dontUseAutoPriceForHedge: Bool = false

	/// Set to true to create tickets from API orders when TWS is used as an OMS
	public var isOmsContainer: Bool = false

	/// Set to true to convert order of type 'Primary Peg' to 'D-Peg'.
	public var discretionaryUpToLimitPrice: Bool = false

	public var autoCancelDate: String?
	
	public var filledQuantity: Double = .greatestFiniteMagnitude
	
	public var refFuturesConId: Int?
	
	public var autoCancelParent: Bool = false
	
	public var shareholder: String?
	
	public var imbalanceOnly: Bool = false
	
	public var routeMarketableToBbo: Bool = false
	
	public var parentPermId: Int = 0

	public var usePriceMgmtAlgo: Bool?
	
	public var duration: Int?
	
	public var postToAts: Int?
	
	public var advancedErrorOverride: String?
	
	public var manualOrderTime: String?
	
	public var minTradeQty: Int?
	
	public var minCompeteSize: Int?
	
	public var competeAgainstBestOffset: Double?
	
	public var midOffsetAtWhole: Double?
	
	public var midOffsetAtHalf: Double?
}


public extension IBOrder {
	static func market(_ action: IBAction, quantity: Double, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading:Bool = false) -> IBOrder {
		IBOrder(action: action, totalQuantity: quantity, orderType: .market, lmtPrice: nil, auxPrice: nil, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}

	static func limit(_ limit: Double, action: IBAction, quantity: Double, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading:  Bool = false) -> IBOrder {
		IBOrder(action: action, totalQuantity: quantity, orderType: .limit, lmtPrice: limit, auxPrice: nil, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}

	
	static func stop(_ stop: Double, action: IBAction, quantity: Double, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
		IBOrder(action: action, totalQuantity: quantity, orderType: .stop, lmtPrice: nil, auxPrice: stop, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}
	
	static func stopLimit(stop: Double, limit: Double, action: IBAction, quantity: Double, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
		IBOrder(action: action, totalQuantity: quantity, orderType: .stopLimit, lmtPrice: limit, auxPrice: stop, tif: tif, outsideRth: extendedTrading, hidden: hidden, account: account)
	}
    
    static func trail(trailingPercent: Double, action: IBAction, quantity: Double, account: String, validUntil tif: TimeInForce = .day, hidden: Bool = true, extendedTrading: Bool = false) -> IBOrder {
        IBOrder(action: action, totalQuantity: quantity, orderType: .trailing, tif: tif, outsideRth: extendedTrading, hidden: hidden, trailingPercent: trailingPercent, account: account)
    }
}
