//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBOrderCompetion: IBEvent, Decodable {
	
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


public struct IBOrderCompetionEnd: IBEvent, Decodable {
	public init(from decoder: Decoder) throws {}
}

