//
//  IBClient+Order.swift
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

/*
public extension IBClient {
	
	
	func cancelAllOrders() throws {
		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.globalCancel)
		try container.encode(version)
		try send(encoder: encoder)
	}
	
	
	func cancelOrder(_ reqId:Int) throws {
		let version = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelOrder)
		try container.encode(version)
		try container.encode(reqId)
		try send(encoder: encoder)
	}
	
	
	func requestExecutions(_ reqId: Int, filter: IBExecutionFilter) throws {

		let version: Int = 3
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.executions)
		try container.encode(version)
		try container.encode(reqId)
		try container.encode(filter)
		try send(encoder: encoder)
	}
	
	
	func requestOpenOrders() throws {

		let version:Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.openOrders)
		try container.encode(version)
		try send(encoder: encoder)
	}
	
	
	func requestAllOpenOrders() throws {

		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.allOpenOrders)
		try container.encode(version)
		try send(encoder: encoder)
	}
	
	
	func requestAllOpenOrders(autoBind: Bool) throws {

		let version: Int = 1
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.autoOpenOrders)
		try container.encode(version)
		try container.encode(autoBind)
		try send(encoder: encoder)

	}
	

	func requestCompletedOrders(apiOnly: Bool) throws {

		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.completedOrders)
		try container.encode(apiOnly)
		try send(encoder: encoder)

	}
	
	
	func placeOrder(_ reqId: Int, contract: IBContract, order: IBOrder) throws {
		
		guard let serverVersion = serverVersion else {
			throw IBError.failedToSend("Failed to read server version")
		}


		let version:Int = (serverVersion < IBServerVersion.NOT_HELD) ? 27 : 45
		
		let encoder = IBEncoder(serverVersion: serverVersion)
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.placeOrder)

		if serverVersion < IBServerVersion.ORDER_CONTAINER{
			try container.encode(version)
		}
		try container.encode(reqId)
		
		try container.encode(contract)
				
		if serverVersion >= IBServerVersion.SEC_ID_TYPE{
			try container.encode(contract.secId?.type)
			try container.encode(contract.secId?.value)
		}
		
		//order main fields
		try container.encode(order.action)
		
		if serverVersion >= IBServerVersion.FRACTIONAL_POSITIONS{
			try container.encode(order.totalQuantity)
		} else {
			try container.encode(Int(order.totalQuantity))
		}
		
		try container.encode(order.orderType)
		try container.encode(order.lmtPrice)
		try container.encode(order.auxPrice)
		
		// extended order fields
		try container.encode(order.tif)
		try container.encode(order.ocaGroup)
		try container.encode(order.account)
		try container.encodeOptional(order.openClose)
		try container.encode(order.origin)
		try container.encode(order.orderRef)
		try container.encode(order.transmit)
		try container.encode(order.parentId)
		try container.encode(order.blockOrder)
		try container.encode(order.sweepToFill)
		try container.encode(order.displaySize)
		try container.encode(order.triggerPrice)
		try container.encode(order.outsideRth)
		try container.encode(order.hidden)
		
		// combo
		if contract.securitiesType == .combo {
			if let legs = contract.comboLegs{
				try container.encode(legs.count)
				if legs.count > 0{
					for leg in legs {
						try container.encode(leg.conId)
						try container.encode(leg.ratio)
						try container.encode(leg.action)
						try container.encode(leg.exchange)
						try container.encode(leg.openClose)
						try container.encode(leg.shortSaleSlot)
						try container.encode(leg.designatedLocation)
						if serverVersion > IBServerVersion.SSHORTX_OLD {
							try container.encode(leg.exemptCode)
						}
					}
				}
			}
		}
		
		if contract.securitiesType == .combo && serverVersion >= IBServerVersion.ORDER_COMBO_LEGS_PRICE {
			if let legs = order.orderComboLegs {
				try container.encode(legs.count)
				if legs.count > 0 {
					for leg in legs {
						try container.encode(leg.price)
					}
				}
			}
		}
		
		if contract.securitiesType == .combo && serverVersion > IBServerVersion.SMART_COMBO_ROUTING_PARAMS {
			if let params = order.smartComboRoutingParams {
				try container.encode(params.count)
				for (key,value) in params {
					try container.encode(key)
					try container.encode(value)
				}
			}
		}

		try container.encodeOptional("")
		try container.encodeOptional(order.discretionaryAmt)
		try container.encodeOptional(order.goodAfterTime)
		try container.encodeOptional(order.goodTillDate)
		
		//financial advisor methods
		try container.encodeOptional(order.faGroup)
		try container.encodeOptional(order.faMethod)
		try container.encodeOptional(order.faPercentage)
		try container.encodeOptional(order.faProfile)
		
		if serverVersion > IBServerVersion.MODELS_SUPPORT {
			try container.encodeOptional(order.modelCode)
		}
		
		try container.encodeOptional(order.shortSaleSlot)         // only populate when order.m_shortSaleSlot = 2
		try container.encodeOptional(order.designatedLocation)    // 0 for retail, 1 or 2 only for institution.
		
		if serverVersion >= IBServerVersion.SSHORTX_OLD {
			try container.encodeOptional(order.exemptCode)
		}
		
		try container.encodeOptional(order.ocaType)
		try container.encodeOptional(order.rule80A)
		try container.encodeOptional(order.settlingFirm)
		try container.encodeOptional(order.allOrNone)
		try container.encodeOptional(order.minQty)
		try container.encodeOptional(order.percentOffset)
		try container.encodeOptional(order.eTradeOnly)
		try container.encodeOptional(order.firmQuoteOnly)
		try container.encodeOptional(order.nbboPriceCap)
		try container.encodeOptional(order.auctionStrategy)
		try container.encodeOptional(order.startingPrice)
		try container.encodeOptional(order.stockRefPrice)
		try container.encodeOptional(order.delta)
		try container.encodeOptional(order.stockRangeLower)
		try container.encodeOptional(order.stockRangeUpper)
		try container.encodeOptional(order.overridePercentageConstraints)
		
		try container.encodeOptional(order.volatility)
		try container.encodeOptional(order.volatilityType)
		try container.encodeOptional(order.deltaNeutralOrderType)
		try container.encodeOptional(order.deltaNeutralAuxPrice)
		
		if serverVersion >= IBServerVersion.DELTA_NEUTRAL_CONID && order.deltaNeutralOrderType != nil {
			try container.encodeOptional(order.deltaNeutralConId)
			try container.encodeOptional(order.deltaNeutralSettlingFirm)
			try container.encodeOptional(order.deltaNeutralClearingAccount)
			try container.encodeOptional(order.deltaNeutralClearingIntent)
		}
		
		if serverVersion >= IBServerVersion.DELTA_NEUTRAL_OPEN_CLOSE && order.deltaNeutralOrderType != nil {
			try container.encodeOptional(order.deltaNeutralOpenClose)
			try container.encodeOptional(order.deltaNeutralShortSale)
			try container.encodeOptional(order.deltaNeutralShortSaleSlot)
			try container.encodeOptional(order.deltaNeutralDesignatedLocation)
		}
		try container.encodeOptional(order.continuousUpdate)
		try container.encodeOptional(order.referencePriceType)

		if serverVersion >= 30{
			try container.encodeOptional(order.trailStopPrice)
		}
		
		if serverVersion >= IBServerVersion.TRAILING_PERCENT {
			try container.encodeOptional(order.trailingPercent)
		}
		
		if serverVersion >= IBServerVersion.SCALE_ORDERS2 {
			try container.encodeOptional(order.scaleInitLevelSize)
			try container.encodeOptional(order.scaleSubsLevelSize)
		} else {
			try container.encodeOptional("")
			try container.encodeOptional(order.scaleInitLevelSize)
		}
		
		try container.encodeOptional(order.scalePriceIncrement)
		
		if serverVersion >= IBServerVersion.SCALE_ORDERS3  {
			if let increment = order.scalePriceIncrement{
				if increment > 0 {
					try container.encodeOptional(order.scalePriceAdjustValue)
					try container.encodeOptional(order.scalePriceAdjustInterval)
					try container.encodeOptional(order.scaleProfitOffset)
					try container.encodeOptional(order.scaleAutoReset)
					try container.encodeOptional(order.scaleInitPosition)
					try container.encodeOptional(order.scaleInitFillQty)
					try container.encodeOptional(order.scaleRandomPercent)
				}
			}
		}
		
		
		if serverVersion >= IBServerVersion.SCALE_TABLE {
			try container.encodeOptional(order.scaleTable)
			try container.encodeOptional(order.activeStartTime)
			try container.encodeOptional(order.activeStopTime)
		}
		
		if serverVersion >= IBServerVersion.HEDGE_ORDERS {
			try container.encodeOptional(order.hedgeType)
			if order.hedgeType != nil {
				try container.encodeOptional(order.hedgeParam)
			}
		}
		
		if serverVersion >= IBServerVersion.OPT_OUT_SMART_ROUTING {
			try container.encodeOptional(order.optOutSmartRouting)
		}
		
		if serverVersion >= IBServerVersion.PTA_ORDERS {
			try container.encodeOptional(order.clearingAccount)
			try container.encodeOptional(order.clearingIntent)
		}

		if serverVersion >= IBServerVersion.NOT_HELD {
			try container.encodeOptional(order.notHeld)
		}
		
		if serverVersion >= IBServerVersion.DELTA_NEUTRAL {
			if let underComp = contract.deltaNeutralContract {
				try container.encodeOptional(true)
				try container.encodeOptional(underComp.conId)
				try container.encodeOptional(underComp.delta)
				try container.encodeOptional(underComp.price)
			} else {
				try container.encodeOptional(false)
			}
		}
		
		if serverVersion >= IBServerVersion.ALGO_ORDERS {
			try container.encodeOptional(order.algoStrategy)
			if let strategy = order.algoParams {
				try container.encodeOptional(strategy.count)
				for (key,value) in strategy {
					try container.encodeOptional(key)
					try container.encodeOptional(value)
				}
			}
		}
		

		
		if serverVersion >= IBServerVersion.ALGO_ID {
			try container.encodeOptional(order.algoId)
		}
		
		if serverVersion >= IBServerVersion.WHAT_IF_EXT_FIELDS {
			try container.encodeOptional(order.whatIf)
		}
		
		if serverVersion >= IBServerVersion.LINKING {
			var str = ""
			if let options = order.orderMiscOptions{
				for (key,value) in options {
					str += "\(key)=\(value)"
				}
			}
			try container.encodeOptional(str)
		}
		
		if serverVersion >= IBServerVersion.ORDER_SOLICITED {
			try container.encodeOptional(order.solicited)
		}
		
		if serverVersion >= IBServerVersion.RANDOMIZE_SIZE_AND_PRICE {
			try container.encodeOptional(order.randomizeSize)
			try container.encodeOptional(order.randomizePrice)
		}
		

		if serverVersion >= IBServerVersion.PEGGED_TO_BENCHMARK {
			if order.orderType == IBOrder.OrderType.PEG_BENCH {
				try container.encodeOptional(order.referenceContractId)
				try container.encodeOptional(order.isPeggedChangeAmountDecrease)
				try container.encodeOptional(order.peggedChangeAmount)
				try container.encodeOptional(order.referenceChangeAmount)
				try container.encodeOptional(order.referenceExchangeId)
			}
			
			if let conditions = order.conditions{
				try container.encodeOptional(conditions.count)
				
				if conditions.count > 0 {
					try container.encodeOptional(order.conditions)

					try container.encodeOptional(order.conditionsIgnoreRth)
					try container.encodeOptional(order.conditionsCancelOrder)
				}
			} else{
				try container.encodeOptional(0)
			}

			try container.encodeOptional(order.adjustedOrderType)
			try container.encodeOptional(order.triggerPrice)
			try container.encodeOptional(order.lmtPriceOffset)
			try container.encodeOptional(order.adjustedStopPrice)
			try container.encodeOptional(order.adjustedStopLimitPrice)
			try container.encodeOptional(order.adjustedTrailingAmount)
			try container.encodeOptional(order.adjustableTrailingUnit)
		}
		

		if serverVersion >= IBServerVersion.EXT_OPERATOR {
			try container.encodeOptional(order.extOperator)
		}
		
		if serverVersion >= IBServerVersion.SOFT_DOLLAR_TIER {
			try container.encodeOptional(order.softDollarTier?.name)
			try container.encodeOptional(order.softDollarTier?.value)
		}
		
		if serverVersion >= IBServerVersion.CASH_QTY {
			try container.encodeOptional(order.cashQuantity)
		}
		
		if serverVersion >= IBServerVersion.DECISION_MAKER{
			try container.encodeOptional(order.mifid2DecisionMaker)
			try container.encodeOptional(order.mifid2DecisionAlgo)
		}
		
		if serverVersion >= IBServerVersion.MIFID_EXECUTION{
			try container.encodeOptional(order.mifid2ExecutionTrader)
			try container.encodeOptional(order.mifid2ExecutionAlgo)
		}
		
		if serverVersion >= IBServerVersion.AUTO_PRICE_FOR_HEDGE{
			try container.encode(order.dontUseAutoPriceForHedge)
		}


		if serverVersion >= IBServerVersion.ORDER_CONTAINER{
			try container.encode(order.isOmsContainer)
		}

		if serverVersion >= IBServerVersion.D_PEG_ORDERS{
			try container.encodeOptional(order.usePriceMgmtAlgo)
		}
		
		try send(encoder: encoder)

	}
	
	
}
*/
