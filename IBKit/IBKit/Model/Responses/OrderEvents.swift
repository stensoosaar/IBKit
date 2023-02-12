//
//  OrderEvents.swift
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



public struct IBOrderStatus: IBAccountEvent, Decodable {
	
	public var orderId: Int
	public var status: IBOrder.Status
	public var filled: Double
	public var remaining: Double
	public var avgFillPrice: Double
	public var permId: Int
	public var parentId: Int
	public var lastFillPrice: Double
	public var clientId: Int
	public var whyHeld: String
	public var mktCapPrice: Double?
	
	public init(from decoder: Decoder) throws {
		
		guard let serverVersion = (decoder as? IBDecoder)?.serverVersion else {
			throw IBError.invalidValue("Server version not found.")
		}
		
		var container = try decoder.unkeyedContainer()
		
		if serverVersion < IBServerVersion.MARKET_CAP_PRICE {
			_ = try container.decode(Int.self)
		}
		
		orderId = try container.decode(Int.self)
		status = try container.decode(IBOrder.Status.self)
		filled = try container.decode(Double.self)
		remaining = try container.decode(Double.self)
		avgFillPrice = try container.decode(Double.self)
		permId = try container.decode(Int.self)
		parentId = try container.decode(Int.self)
		lastFillPrice = try container.decode(Double.self)
		clientId = try container.decode(Int.self)
		whyHeld = try container.decode(String.self)
		
		if serverVersion >= IBServerVersion.MARKET_CAP_PRICE {
			mktCapPrice = try container.decode(Double.self)
		}
	}
	
	
}


public struct IBOpenOrder: IBAccountEvent, Decodable {
	
	public var contract: IBContract
	public var order: IBOrder
	public var orderState: IBOrderState
	
	public init(from decoder: Decoder) throws {
		
		guard let serverVersion = (decoder as? IBDecoder)?.serverVersion else {
			throw IBError.invalidValue("Server version not found.")
		}
				
		var container = try decoder.unkeyedContainer()
		
		let version = serverVersion < IBServerVersion.ORDER_CONTAINER ? try container.decode(Int.self) : serverVersion
		
		let orderId = try container.decode(Int.self)
		
		contract = try container.decode(IBContract.self)
		
		let action = try container.decode(IBAction.self)
		let quantity = try container.decode(Double.self)
		let orderType = try container.decode(IBOrder.OrderType.self)
		let priceLimit =  try container.decodeOptional(Double.self)
		let priceAux =  try container.decodeOptional(Double.self)
		let tif = try container.decode(IBOrder.TimeInForce.self)
		let ocaGroup = try container.decodeOptional(String.self)
		let account = try container.decode(String.self)
		let openClose = try container.decodeOptional(IBOrder.OpenClose.self)
		let origin = try container.decode(IBOrder.Origin.self)
		let orderReference = try container.decodeOptional(String.self)
		let clientId = try container.decode(Int.self)
		let permId = try container.decode(Int.self)
		let outsideRth = try container.decode(Bool.self)
		let hidden = try container.decode(Bool.self)
		let discretionaryAmt=try container.decode(Double.self)
		let goodAfterTime = try container.decodeOptional(Date.self)
		
		
		order = IBOrder(action: action,
						totalQuantity: quantity,
						orderType: orderType,
						lmtPrice: priceLimit,
						auxPrice: priceAux,
						tif: tif,
						outsideRth: outsideRth,
						hidden: hidden,
						account: account)
		
		order.orderId = orderId
		order.ocaGroup = ocaGroup
		order.permId = permId
		order.discretionaryAmt = discretionaryAmt
		order.goodAfterTime = goodAfterTime
		order.origin = origin
		order.openClose = openClose
		order.orderRef = orderReference
		order.clientId = clientId
		
		// skipSharesAllocation
		_ = try container.decode(String.self)
		
		//MARK: -FA Parameters
		order.faGroup = try container.decodeOptional(String.self)
		order.faMethod = try container.decodeOptional(String.self)
		order.faPercentage = try container.decodeOptional(String.self)
		order.faProfile = try container.decodeOptional(String.self)
		
		if serverVersion >= IBServerVersion.MODELS_SUPPORT {
			order.modelCode = try container.decodeOptional(String.self)
		}
		
		order.goodTillDate = try container.decodeOptional(Date.self)
		
		order.rule80A = try container.decodeOptional(IBOrder.Rule80A.self)
		order.percentOffset = try container.decodeOptional(Double.self)
		order.settlingFirm = try container.decodeOptional(String.self)
		order.shortSaleSlot = try container.decode(Int.self)
		order.designatedLocation = try container.decodeOptional(String.self)
		order.exemptCode = try container.decode(Int.self)
		
		//MARK: -AUCTION STRATEGY
		order.auctionStrategy = try container.decodeOptional(IBOrder.AuctionStrategy.self)
		
		//MARK: -BOX ORDER
		order.startingPrice = try container.decodeOptional(Double.self)
		order.stockRefPrice = try container.decodeOptional(Double.self)
		order.delta = try container.decodeOptional(Double.self)
		
		//MARK: - PegToStkOrVol OrderParams
		order.stockRangeLower = try container.decodeOptional(Double.self)
		order.stockRangeUpper = try container.decodeOptional(Double.self)
		
		order.displaySize = try container.decodeOptional(Int.self)
		order.blockOrder = try container.decode(Bool.self)
		order.sweepToFill = try container.decode(Bool.self)
		order.allOrNone = try container.decode(Bool.self)
		order.minQty = try container.decodeOptional(Int.self)
		order.ocaType = try container.decodeOptional(IBOrder.OCAType.self)
		
		// deprecated
		_ = try container.decode(Bool.self)
		// deprecated
		_ = try container.decode(Bool.self)
		// deprecated
		_ = try container.decodeOptional(Double.self)
		
		
		order.parentId = try container.decode(Int.self)
		order.triggerMethod = try container.decodeOptional(IBOrder.TriggerMethod.self)
		
		
		//MARK: - Vol Order Parameters
		
		order.volatility = try container.decodeOptional(Double.self)
		order.volatilityType = try container.decodeOptional(IBOrder.VolaitilityType.self)
		order.deltaNeutralOrderType = try container.decodeOptional(String.self)
		order.deltaNeutralAuxPrice = try container.decodeOptional(Double.self)
		
		if version >= 27 && order.deltaNeutralOrderType != nil {
			order.deltaNeutralConId = try container.decode(Int.self)
			order.deltaNeutralSettlingFirm = try container.decode(String.self)
			order.deltaNeutralClearingAccount = try container.decode(String.self)
			order.deltaNeutralClearingIntent = try container.decode(String.self)
		}
		
		if version >= 31 && order.deltaNeutralOrderType != nil {
			order.deltaNeutralOpenClose = try container.decode(String.self)
			order.deltaNeutralShortSale = try container.decode(Bool.self)
			order.deltaNeutralShortSaleSlot = try container.decode(Int.self)
			order.deltaNeutralDesignatedLocation = try container.decode(String.self)
		}
		
		order.continuousUpdate = try container.decode(Bool.self)
		order.referencePriceType = try container.decodeOptional(IBOrder.ReferencePriceType.self)
		
		
		
		
		
		//MARK: - Trail Params
		order.trailStopPrice = try container.decodeOptional(Double.self)
		if version >= 30 {
			order.trailingPercent = try container.decodeOptional(Double.self)
		}
		
		//MARK: - Basis Points
		
		order.basisPoints = try container.decodeOptional(Double.self)
		order.basisPointsType = try container.decodeOptional(Int.self)
		
		
		//MARK: - Combo Legs
		
		contract.comboLegsDescrip = try container.decodeOptional(String.self)
		
		if version >= 29 {
			let comboLegCount = try container.decode(Int.self)
			if comboLegCount > 0{
				contract.comboLegs = []
				for _ in 0..<comboLegCount{
					let leg = try container.decode(IBContract.ComboLeg.self)
					contract.comboLegs?.append(leg)
				}
			}
			
			let orderComboLegCount = try container.decode(Int.self)
			if orderComboLegCount > 0{
				order.orderComboLegs = []
				for _ in 0..<orderComboLegCount {
					let orderLeg = try container.decode(IBOrder.ComboLeg.self)
					order.orderComboLegs?.append(orderLeg)
				}
			}
		}
		
		//MARK: - Smart Combo Routing Params
		
		if version >= 26 {
			let smartComboRoutingParameterCount = try container.decode(Int.self)
			order.smartComboRoutingParams = [String : String]()
			for _ in 0..<smartComboRoutingParameterCount {
				let key = try container.decode(String.self)
				let value = try container.decode(String.self)
				order.smartComboRoutingParams?[key]=value
			}
		}
		
		//MARK: - Scale Order Params
		
		if version >= 20 {
			order.scaleInitLevelSize = try container.decodeOptional(Int.self)
			order.scaleSubsLevelSize = try container.decodeOptional(Int.self)
		} else {
			_ = try container.decode(Int.self)
			order.scaleInitLevelSize = try container.decodeOptional(Int.self)
		}
		
		order.scalePriceIncrement = try container.decodeOptional(Double.self)
		
		if version >= 28 {
			if let increment = order.scalePriceIncrement {
				if increment > 0 && increment < Double.greatestFiniteMagnitude {
					order.scalePriceAdjustValue = try container.decode(Double.self)
					order.scalePriceAdjustInterval = try container.decode(Int.self)
					order.scaleProfitOffset = try container.decode(Double.self)
					order.scaleAutoReset = try container.decode(Bool.self)
					order.scaleInitPosition = try container.decode(Int.self)
					order.scaleInitFillQty = try container.decode(Int.self)
					order.scaleRandomPercent = try container.decode(Bool.self)
				}
			}
		}
		
		//MARK: - Hedge Params
		
		if version >= 24 {
			order.hedgeType = try container.decodeOptional(IBOrder.HedgeType.self)
			if order.hedgeType != nil {
				order.hedgeParam = try container.decode(String.self)
			}
		}
		
		//MARK: - Opt Out Smart Routing
		if version >= 25 {
			order.optOutSmartRouting = try container.decodeOptional(Bool.self)
		}
		
		//MARK: - Clearing Params
		order.clearingAccount = try container.decodeOptional(String.self)
		order.clearingIntent = try container.decodeOptional(IBOrder.ClearingIntent.self)
		
		//MARK: - Not Held
		if version >= 22 {
			order.notHeld = try container.decode(Bool.self)
		}
		
		//MARK: - Delta Neutral
		if version >= 20 {
			let hasUnderComp = try container.decodeOptional(Bool.self)
			if hasUnderComp == true {
				contract.deltaNeutralContract = try container.decode(IBContract.DeltaNeutral.self)
			}
		}
		
		//MARK: - Algo Params
		if version >= 21 {
			order.algoStrategy = try container.decodeOptional(IBOrder.AlgoStrategy.self)
			if order.algoStrategy != nil {
				let algoParameterCount = try container.decode(Int.self)
				order.algoParams=[String:String]()
				for _ in 0..<algoParameterCount{
					let key = try container.decode(String.self)
					let value = try container.decode(String.self)
					order.algoParams![key]=value
				}
			}
		}
		
		//MARK: - Solicited
		if version >= 33 {
			order.solicited=try container.decode(Bool.self)
		}
		
		
		//MARK: - What-If Info & Commission
		order.whatIf = try container.decode(Bool.self)
		orderState = try container.decode(IBOrderState.self)
	
		//MARK: - Vol Randomize Flags
		if version >= 34{
			order.randomizeSize = try container.decode(Bool.self)
			order.randomizePrice = try container.decode(Bool.self)
		}

		//MARK: - Peg To Bench Params
		if serverVersion >= IBServerVersion.PEGGED_TO_BENCHMARK {
			if order.orderType == .PEG_BENCH {
				order.referenceContractId = try container.decode(Int.self)
				order.isPeggedChangeAmountDecrease = try container.decode(Bool.self)
				order.peggedChangeAmount = try container.decode(Double.self)
				order.referenceChangeAmount=try container.decode(Double.self)
				order.referenceExchangeId = try container.decode(String.self)
			}
		}
		
		//MARK: - Conditions
			
		if serverVersion >= IBServerVersion.PEGGED_TO_BENCHMARK {
			let conditionCount = try container.decode(Int.self)
			
			if conditionCount > 0 {
				
				order.conditions = IBCondition()
				
				for _ in 0..<conditionCount {
					
					let type = try container.decode(IBConditionType.self)
					let connector = try container.decode(IBCondition.Connector.self)
					var condition: AnyCondition
					switch type {
						case .execution:
							condition = try container.decode(IBExecutionCondition.self)
						case .margin:
							condition = try container.decode(IBMarginCondition.self)
						case .percentChange:
							condition = try container.decode(IBChangePerCentCondition.self)
						case .price:
							condition = try container.decode(IBPriceCondition.self)
						case .time:
							condition = try container.decode(IBTimeCondition.self)
						case .volume:
							condition = try container.decode(IBVolumeCondition.self)
					}
					
					order.conditions?.buffer.append(connector)
					order.conditions?.buffer.append(condition)
					
				}
				order.conditionsIgnoreRth = try container.decode(Bool.self)
				order.conditionsCancelOrder = try container.decode(Bool.self)
			}
		}
		
		//MARK: - Adjusted Order Params
		
		if serverVersion >= IBServerVersion.PEGGED_TO_BENCHMARK {
			order.adjustedOrderType = try container.decode(String.self)
			order.triggerPrice = try container.decode(Double.self)
			order.trailStopPrice = try container.decode(Double.self)
			order.lmtPriceOffset = try container.decode(Double.self)
			order.adjustedStopPrice = try container.decode(Double.self)
			order.adjustedStopLimitPrice = try container.decode(Double.self)
			order.adjustedTrailingAmount = try container.decode(Double.self)
			order.adjustableTrailingUnit = try container.decode(Int.self)
		}

		//MARK: - SoftDollar Tier
		if serverVersion >= IBServerVersion.SOFT_DOLLAR_TIER{
			order.softDollarTier = try container.decode(IBOrder.SoftDollarTier.self)
		}
		
		//MARK: - Csh Quantity
		if serverVersion >= IBServerVersion.CASH_QTY{
			order.cashQuantity = try container.decode(Double.self)
		}
		
	}
	
}

/**
 
 Optional("11\0-1\010003\0265598\0AAPL\0STK\0\00.0\0\0\0ISLAND\0USD\0AAPL\0NMS\00000e0d5.63cefb1e.01.01\020221017  16:49:50\0DU3479983\0ISLAND\0SLD\03\0142.46\01481406469\0999\00\03\0142.46\0\0\0\0\02\0")

 */

public struct IBExecution: IBAccountEvent, Decodable {
	
	public var requestId: Int
	
	public var orderId: Int

	public var contract: IBContract
	
	public var executionId: String
	
	public var time: Date
	
	public var account: String
	
	public var exchange: String

	public var side: String
	
	public var shares: Double
	
	public var price: Double
	
	public var permId: Int
	
	public var clientId: Int
	
	public var liquidation: Int
	
	public var totalQuantity: Double
	
	public var priceAverage: Double
	
	public var orderReference: String?
	
	public var evRule: String?
	
	public var evMultiplier: Double?
	
	public var modelCode: String?
	
	public enum LiquidityType: Int, Decodable {
		case none 			= 0
		case added 			= 1
		case removed 		= 2
		case roudedOut 		= 3
	}
	
	public var lastLiquidity: LiquidityType?
	
	
	
	public init(from decoder: Decoder) throws {
		
		guard let serverVersion = (decoder as? IBDecoder)?.serverVersion else {
			throw IBError.invalidValue("Server version not found.")
		}
		
		var container = try decoder.unkeyedContainer()
		let version = serverVersion < IBServerVersion.LAST_LIQUIDITY ? try container.decode(Int.self) : serverVersion
		
		self.requestId = (version >= 7) ? try container.decode(Int.self) : -1
		self.orderId = try container.decode(Int.self)
		self.contract = try container.decode(IBContract.self)
		self.executionId = try container.decode(String.self)
		self.time = try container.decode(Date.self)
		self.account = try container.decode(String.self)
		self.exchange = try container.decode(String.self)
		self.side = try container.decode(String.self)
		self.shares = try container.decode(Double.self)
		self.price = try container.decode(Double.self)
		self.permId = try container.decode(Int.self)
		self.clientId = try container.decode(Int.self)
		self.liquidation = try container.decode(Int.self)
		self.totalQuantity = try container.decode(Double.self)
		self.priceAverage = try container.decode(Double.self)
		
		if version >= 8 {
			self.orderReference = try container.decodeOptional(String.self)
		}
		if version >= 9 {
			self.evRule = try container.decode(String.self)
			self.evMultiplier = try container.decodeOptional(Double.self)
		}
		if serverVersion >= IBServerVersion.MODELS_SUPPORT {
			self.modelCode = try container.decodeOptional(String.self)
		}
		if serverVersion >= IBServerVersion.LAST_LIQUIDITY {
			self.lastLiquidity = try container.decodeOptional(LiquidityType.self)
		}

	}
}


public struct IBExecutionEnd: IBAccountEvent, Decodable {
	
	public var reqId: Int
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		self.reqId = try container.decode(Int.self)
	}
	
}


public struct IBCompletedOrders: IBAccountEvent, Decodable {
	
	let version = Int.max
	
	public var contract: IBContract
	
	public var order: IBOrder
	
	public var completedTime: String
	
	public var completedStatus: String
	
	public init(from decoder: Decoder) throws {
		
		guard let serverVersion = (decoder as? IBDecoder)?.serverVersion else {
			throw IBError.invalidValue("Server version not found.")
		}
		
		var container = try decoder.unkeyedContainer()
		
		contract = try container.decode(IBContract.self)
		
		// Decode Action
		let action = try container.decode(IBAction.self)
		
		// Decode TotalQuantity
		let quantity = try container.decode(Double.self)
		
		// Decode OrderType
		let orderType = try container.decode(IBOrder.OrderType.self)
		
		// Decode LmtPrice
		let priceLimit =  try container.decodeOptional(Double.self)
		
		// Decode AuxPrice
		let priceAux =  try container.decodeOptional(Double.self)
		
		// Decode TIF
		let tif = try container.decode(IBOrder.TimeInForce.self)
		
		// Decode OcaGroup
		let ocaGroup = try container.decodeOptional(String.self)
		
		// Decode Account
		let account = try container.decode(String.self)
		
		// Decode OpenClose
		let openClose = try container.decodeOptional(IBOrder.OpenClose.self)
		
		// decDecodeode Origin
		let origin = try container.decode(IBOrder.Origin.self)
		
		// Decode OrderRef
		let orderReference = try container.decodeOptional(String.self)
		
		// Decode PermId
		let permId = try container.decode(Int.self)
		
		// Decode OutsideRth
		let outsideRth = try container.decode(Bool.self)
		
		// Decode Hidden
		let hidden = try container.decode(Bool.self)
		
		
		order = IBOrder(action: action,
						totalQuantity: quantity,
						orderType: orderType,
						lmtPrice: priceLimit,
						auxPrice: priceAux,
						tif: tif,
						outsideRth: outsideRth,
						hidden: hidden,
						account: account)
		
		
		order.openClose = openClose
		order.ocaGroup = ocaGroup
		order.origin = origin
		order.orderRef = orderReference
		order.permId = permId
		
		// Decode DiscretionaryAmt
		order.discretionaryAmt=try container.decode(Double.self)
		
		// Decode GoodAfterTime
		order.goodAfterTime = try container.decodeOptional(Date.self)
		
		// Decode FAParams
		order.faGroup = try container.decodeOptional(String.self)
		order.faMethod = try container.decodeOptional(String.self)
		order.faPercentage = try container.decodeOptional(String.self)
		order.faProfile = try container.decodeOptional(String.self)
		
		// Decode ModelCode
		if serverVersion >= IBServerVersion.MODELS_SUPPORT {
			order.modelCode = try container.decodeOptional(String.self)
		}
		
		// Decode GoodTillDate
		order.goodTillDate = try container.decodeOptional(Date.self)
		
		// Decode Rule80A
		order.rule80A = try container.decodeOptional(IBOrder.Rule80A.self)
		
		// Decode PercentOffset
		order.percentOffset = try container.decodeOptional(Double.self)
		
		// Decode SettlingFirm
		order.settlingFirm = try container.decodeOptional(String.self)
		
		// Decode ShortSaleParams
		order.shortSaleSlot = try container.decode(Int.self)
		order.designatedLocation = try container.decodeOptional(String.self)
		order.exemptCode = try container.decode(Int.self)
		
		// Decode BoxOrderParams
		order.startingPrice = try container.decodeOptional(Double.self)
		order.stockRefPrice = try container.decodeOptional(Double.self)
		order.delta = try container.decodeOptional(Double.self)
		
		// Decode PegToStkOrVolOrderParams
		order.stockRangeLower = try container.decodeOptional(Double.self)
		order.stockRangeUpper = try container.decodeOptional(Double.self)
		
		// Decode DisplaySize
		order.displaySize = try container.decodeOptional(Int.self)
		
		// Decode SweepToFill
		order.sweepToFill = try container.decode(Bool.self)
		
		// Decode AllOrNone
		order.allOrNone = try container.decode(Bool.self)
		
		// Decode MinQty
		order.minQty = try container.decodeOptional(Int.self)
		
		// Decode OcaType
		order.ocaType = try container.decodeOptional(IBOrder.OCAType.self)
		
		// Decode TriggerMethod
		order.triggerMethod = try container.decodeOptional(IBOrder.TriggerMethod.self)
		
		// Decode VolOrderParams
		order.volatility = try container.decodeOptional(Double.self)
		order.volatilityType = try container.decodeOptional(IBOrder.VolaitilityType.self)
		order.deltaNeutralOrderType = try container.decodeOptional(String.self)
		order.deltaNeutralAuxPrice = try container.decodeOptional(Double.self)
		
		if version >= 27 && order.deltaNeutralOrderType != nil {
			order.deltaNeutralConId = try container.decode(Int.self)
			order.deltaNeutralSettlingFirm = try container.decode(String.self)
			order.deltaNeutralClearingAccount = try container.decode(String.self)
			order.deltaNeutralClearingIntent = try container.decode(String.self)
		}
		
		if version >= 31 && order.deltaNeutralOrderType != nil {
			order.deltaNeutralOpenClose = try container.decode(String.self)
			order.deltaNeutralShortSale = try container.decode(Bool.self)
			order.deltaNeutralShortSaleSlot = try container.decode(Int.self)
			order.deltaNeutralDesignatedLocation = try container.decode(String.self)
		}
		
		order.continuousUpdate = try container.decode(Bool.self)
		order.referencePriceType = try container.decodeOptional(IBOrder.ReferencePriceType.self)
		
		// Decode TrailParams
		order.trailStopPrice = try container.decodeOptional(Double.self)
		if version >= 30 {
			order.trailingPercent = try container.decodeOptional(Double.self)
		}
		
		// Decode ComboLegs
		contract.comboLegsDescrip = try container.decodeOptional(String.self)
		
		if version >= 29 {
			let comboLegCount = try container.decode(Int.self)
			if comboLegCount > 0{
				contract.comboLegs = []
				for _ in 0..<comboLegCount{
					let leg = try container.decode(IBContract.ComboLeg.self)
					contract.comboLegs?.append(leg)
				}
			}
			
			let orderComboLegCount = try container.decode(Int.self)
			if orderComboLegCount > 0{
				order.orderComboLegs = []
				for _ in 0..<orderComboLegCount {
					let orderLeg = try container.decode(IBOrder.ComboLeg.self)
					order.orderComboLegs?.append(orderLeg)
				}
			}
		}
		
		// Decode SmartComboRoutingParams
		if version >= 26 {
			let smartComboRoutingParameterCount = try container.decode(Int.self)
			order.smartComboRoutingParams = [String : String]()
			for _ in 0..<smartComboRoutingParameterCount {
				let key = try container.decode(String.self)
				let value = try container.decode(String.self)
				order.smartComboRoutingParams?[key]=value
			}
		}
		
		// Decode ScaleOrderParams
		
		if version >= 20 {
			order.scaleInitLevelSize = try container.decodeOptional(Int.self)
			order.scaleSubsLevelSize = try container.decodeOptional(Int.self)
		} else {
			_ = try container.decode(Int.self)
			order.scaleInitLevelSize = try container.decodeOptional(Int.self)
		}
		
		order.scalePriceIncrement = try container.decodeOptional(Double.self)
		
		// Decode HedgeParams
		if version >= 24 {
			order.hedgeType = try container.decodeOptional(IBOrder.HedgeType.self)
			if order.hedgeType != nil {
				order.hedgeParam = try container.decode(String.self)
			}
		}
		
		// Decode ClearingParams
		order.clearingAccount = try container.decodeOptional(String.self)
		order.clearingIntent = try container.decodeOptional(IBOrder.ClearingIntent.self)
		
		// Decode NotHeld
		if version >= 22 {
			order.notHeld = try container.decode(Bool.self)
		}
		
		// Decode DeltaNeutral
		if version >= 20 {
			let hasUnderComp = try container.decodeOptional(Bool.self)
			if hasUnderComp == true {
				contract.deltaNeutralContract = try container.decode(IBContract.DeltaNeutral.self)
			}
		}
		
		// Decode AlgoParams
		if version >= 21 {
			order.algoStrategy = try container.decodeOptional(IBOrder.AlgoStrategy.self)
			if order.algoStrategy != nil {
				let algoParameterCount = try container.decode(Int.self)
				order.algoParams=[String:String]()
				for _ in 0..<algoParameterCount{
					let key = try container.decode(String.self)
					let value = try container.decode(String.self)
					order.algoParams![key]=value
				}
			}
		}
		
		// Decode Solicited
		if version >= 33 {
			order.solicited=try container.decode(Bool.self)
		}
		
		// Decode OrderStatus
		// self.orderState.status = decode(str, fields)
		
		
		// Decode VolRandomizeFlags
		if version >= 34{
			order.randomizeSize = try container.decode(Bool.self)
			order.randomizePrice = try container.decode(Bool.self)
		}
		
		// Decode PegToBenchParams
		if serverVersion >= IBServerVersion.PEGGED_TO_BENCHMARK {
			if order.orderType == .PEG_BENCH {
				order.referenceContractId = try container.decode(Int.self)
				order.isPeggedChangeAmountDecrease = try container.decode(Bool.self)
				order.peggedChangeAmount = try container.decode(Double.self)
				order.referenceChangeAmount=try container.decode(Double.self)
				order.referenceExchangeId = try container.decode(String.self)
			}
		}
		
		
		// Decode Conditions
		if serverVersion >= IBServerVersion.PEGGED_TO_BENCHMARK {
			let conditionCount = try container.decode(Int.self)
			if conditionCount > 0 {
				
				order.conditions = IBCondition()
				
				for _ in 0..<conditionCount {
					
					let type = try container.decode(IBConditionType.self)
					let connector = try container.decode(IBCondition.Connector.self)
					var condition: AnyCondition
					switch type {
						case .execution:
							condition = try container.decode(IBExecutionCondition.self)
						case .margin:
							condition = try container.decode(IBMarginCondition.self)
						case .percentChange:
							condition = try container.decode(IBChangePerCentCondition.self)
						case .price:
							condition = try container.decode(IBPriceCondition.self)
						case .time:
							condition = try container.decode(IBTimeCondition.self)
						case .volume:
							condition = try container.decode(IBVolumeCondition.self)
					}
					
					order.conditions?.buffer.append(connector)
					order.conditions?.buffer.append(condition)
					
				}
				order.conditionsIgnoreRth = try container.decode(Bool.self)
				order.conditionsCancelOrder = try container.decode(Bool.self)
			}
		}
		
		
		// Decode StopPriceAndLmtPriceOffset
		self.order.trailStopPrice = try container.decodeOptional(Double.self)
		self.order.lmtPriceOffset = try container.decodeOptional(Double.self)
		
		// Decode CashQty
		if serverVersion >= IBServerVersion.CASH_QTY {
			self.order.cashQuantity = try container.decodeOptional(Double.self)
		}
		
		// Decode DontUseAutoPriceForHedge
		if serverVersion >= IBServerVersion.AUTO_PRICE_FOR_HEDGE {
			self.order.dontUseAutoPriceForHedge = try container.decode(Bool.self)
		}
		
		// Decode IsOmsContainers
		if serverVersion >= IBServerVersion.ORDER_CONTAINER {
			self.order.isOmsContainer = try container.decode(Bool.self)
		}
		
		
		// Decode AutoCancelDate
		self.order.autoCancelDate = try container.decodeOptional(String.self)
		
		// Decode FilledQuantity
		self.order.filledQuantity = try container.decode(Double.self)
		
		
		// Decode RefFuturesConId
		self.order.refFuturesConId = try container.decodeOptional(Int.self)
		
		// Decode AutoCancelParent
		if serverVersion >= IBServerVersion.AUTO_CANCEL_PARENT {
			self.order.autoCancelParent = try container.decode(Bool.self)
		}
		
		// Decode Shareholder
		self.order.shareholder = try container.decodeOptional(String.self)

		// Decode ImbalanceOnly
		self.order.imbalanceOnly = try container.decode(Bool.self)

		// Decode RouteMarketableToBbo
		self.order.routeMarketableToBbo = try container.decode(Bool.self)
		
		// Decode ParentPermId
		self.order.parentPermId = try container.decode(Int.self)
		
		// Decode CompletedTime
		self.completedTime = try container.decode(String.self)

		// Decode CompletedStatus
		self.completedStatus = try container.decode(String.self)

		// Decode PegBestPegMidOrderAttributes
		if serverVersion >= IBServerVersion.PEGBEST_PEGMID_OFFSETS {
			self.order.minTradeQty = try container.decodeOptional(Int.self)
			self.order.minCompeteSize = try container.decodeOptional(Int.self)
			self.order.competeAgainstBestOffset = try container.decodeOptional(Double.self)
			self.order.midOffsetAtWhole = try container.decodeOptional(Double.self)
			self.order.midOffsetAtHalf = try container.decodeOptional(Double.self)
		}
		
		
	}
	
}


public struct IBCompletedOrdersEnd: IBAccountEvent, Decodable {
	public init(from decoder: Decoder) throws {}
}


/*
Optional("59\01\00000e1a7.634cfd14.01.01\00.57\0USD\01.7976931348623157E308\01.7976931348623157E308\0\0")
Optional("59\01\00000e0d5.63cefb1e.01.01\01.010177\0USD\01.7976931348623157E308\01.7976931348623157E308\0\0")
*/

public struct IBCommissionReport: IBAccountEvent, Decodable  {
	
	public var executionId: String
	public var commission: Double
	public var currency: String
	public var realizedPNL: Double?
	public var yield: Double?
	public var yieldRedemptionDate: Date?

	public init(from decoder: Decoder) throws {
		(decoder as? IBDecoder)?.dateFormatter.dateFormat = "yyyyMMdd"
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		executionId = try container.decode(String.self)
		commission = try container.decode(Double.self)
		currency = try container.decode(String.self)
		realizedPNL = try container.decodeOptional(Double.self)
		yield = try container.decodeOptional(Double.self)
		yieldRedemptionDate = try container.decodeOptional(Date.self)
	}
	
}

