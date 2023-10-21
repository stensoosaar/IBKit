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





public struct IBOpenOrder: IBEvent, Decodable {
	
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



