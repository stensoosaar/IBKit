//
//  File.swift
//  
//
//  Created by Sten Soosaar on 11.05.2024.
//

import Foundation


public protocol IBAnyClient{
	
	var serverVersion: Int? {get set}
	
	func connect() throws
	
	func disconnect()
	
	func send(request: IBRequest) throws
		
}



public protocol IBRequestWrapper {
	
	func requestNextRequestID() throws
	
	func requestServerTime() throws
	
	func requestBulletins(includePast all: Bool) throws
	
	func cancelNewsBulletins() throws
	
	func setMarketDataType(_ type: IBMarketDataType) throws
	
	func requestScannerParameters() throws
	
	/// Requests account identifiers

	func requestManagedAccounts() throws

	/// Subscribe account values, portfolio and last update time information
	/// - Parameter accountName: account name
	/// - Parameter subscribe: true for start and false to end
	func subscribeAccountUpdates(accountName: String, subscribe:Bool) throws

	
	/// Subscribes account summary.
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter tags: Array of IBAccountKeys to specify what to subscribe. As a default, all keys will be subscribed
	/// - Parameter accountGroup:
	/// - Returns: AccountSummary event per specified tag and will be updated once per 3 minutes
	func subscribeAccountSummary(_ requestID: Int, tags: [IBAccountKey], accountGroup group: String) throws
	
	
	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event
	func unsubscribeAccountSummary(_ requestID: Int) throws
	
	
	/// Subscribes account summary.
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter tags: Array of IBAccountKeys to specify what to subscribe. As a default, all keys will be subscribed
	/// - Parameter accountGroup:
	/// - Returns: AccountSummary event per specified tag and will be updated once per 3 minutes
	func subscribeAccountSummaryMulti(_ requestID: Int, accountName: String, ledger:Bool, modelCode:String?) throws
	
	
	
	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event
	func unsubscribeAccountSummaryMulti(_ requestID: Int) throws
	
	
	/// Subscribes account profit and loss reporting
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter account: account identifier.
	/// - Parameter modelCode:
	/// - Returns: AccountPNL event
	func subscribeAccountPNL(_ requestID: Int, account: String, modelCode: [String]?) throws
	
	
	/// Unsubscribes account profit and loss reporting
	/// - Parameter requestIDunique request identifier. Best way to obtain one, is by calling client.getNextID().
	func unsubscribeAccountPNL(_ requestID: Int) throws
	
	
	func requestMarketRule(_ requestID: Int) throws
	
	
	/// Requests first datapoint date for specific dataset
	/// - Parameter reqId: request ID
	/// - Parameter contract: contract description
	/// - Parameter barSource: data type to build a bar
	/// - Parameter extendedTrading: use only data from regular trading hours
	/// - Returns: FirstDatapoint event
	func firstDatapointDate(_ requestID: Int, contract: IBContract, barSource: IBBarSource , extendedTrading: Bool) throws
	
	
	/// Requests first datapoint date for specific dataset
	/// - Parameter reqId: request ID
	/// - Parameter contract: contract description
	/// - Parameter barSize: what resolution one bar should be
	/// - Parameter barSource: data type to build a bar
	/// - Parameter lookback: date interval of request.
	/// - Parameter extendedTrading: shall data from extended trading hours be included or not
	/// - Returns: PriceHistory event. If IBDuration continousUpdates selected, also PriceBar event of requested resolution will be included as they occur
	
	func requestPriceHistory(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: DateInterval, extendedTrading: Bool, includeExpired: Bool) throws
	
	
	func subscribeRealTimeBar(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, extendedTrading: Bool) throws
	
	func requestMarketData(_ requestID: Int, contract:IBContract, events: [IBMarketDataRequest.SubscriptionType], snapshot: Bool, regulatory: Bool) throws
	
	
	/// subscribes live quote events including bid / ask / last trade and respective sizes
	/// - Parameter reqId:
	/// - Parameter contract:
	/// - Parameter snapshot:
	/// - Parameter regulatory:
	
	func subscribeMarketData(_ requestID: Int, contract: IBContract, snapshot: Bool, regulatory: Bool) throws
	
	func unsubscribeMarketData(_ requestID: Int) throws
	
	
	func subscribeMarketDepth(_ requestID: Int, contract: IBContract, rows: Int, smart: Bool) throws
	
	func unsubscribeMarketDepth(_ requestID: Int) throws
	
	
	func requestTickByTick(_ requestID: Int, contract: IBContract, tickType: IBTickRequest.TickType, tickCount: Int, ignoreSize: Bool) throws
	
	
	func cancelTickByTickData(_ requestID: Int) throws

	
	
	/// High Resolution Historical Data
	/// - Parameter requestId: id of the request
	/// - Parameter contract: Contract object that is subject of query.
	/// - Parameter numberOfTicks, Number of distinct data points. Max is 1000 per request.
	/// - Parameter fromDate: requested period's starttime
	/// - Parameter whatToShow, (Bid_Ask, Midpoint, or Trades) Type of data requested.
	/// - Parameter useRth, Data from regular trading hours (1), or all available hours (0).
	/// - Parameter ignoreSize: Omit updates that reflect only changes in size, and not price. Applicable to Bid_Ask data requests.
	
	func historicalTicks(_ requestID: Int, contract: IBContract, numberOfTicks: Int, interval: DateInterval, whatToShow: IBTickHistoryRequest.TickSource, useRth: Bool, ignoreSize: Bool) throws
	
	func subscribePositions() throws
	
	func unsubscribePositions() throws

	func subscribePositionsMulti(_ requestID: Int, accountName: String, modelCode: String) throws
	
	func unsubscribePositionsMulti(_ requestID: Int) throws
	
	func subscribePositionPNL(_ requestID: Int, accountName: String, contractID: Int, modelCode: [String]) throws
	
	func cancelAllOrders() throws
	
	func cancelOrder(_ requestID:Int) throws
	
	func requestExecutions(_ requestID: Int, clientID: Int?, accountName: String?, date: Date?, symbol: String?, securityType type: IBSecuritiesType?, market: IBExchange?, side: IBAction?) throws
	
	func requestOpenOrders() throws
	
	func requestAllOpenOrders() throws
	
	func requestAllOpenOrders(autoBind: Bool) throws
	
	func requestCompletedOrders(apiOnly: Bool) throws
	
	func placeOrder(_ requestID: Int, order: IBOrder) throws
	
	func subscribeNews(_ requestID: Int, contract: IBContract, snapshot: Bool, regulatory: Bool) throws
	
	func searchSymbols(_ requestID: Int, nameOrSymbol text: String) throws
	
	func contractDetails(_ requestID: Int, contract: IBContract) throws
	
	func subscribeFundamentals(_ requestID: Int, contract: IBContract, reportType: IBFundamantalsRequest.ReportType) throws

	func unsubscribeFundamentals(_ requestID: Int) throws
	
	
	/// Requests security definition option parameters for viewing a contract's option chain.
	/// - Parameters:
	/// - requestID: request index
	/// - underlying: underlying contract. symbol, type and contractID are required
	/// - exchange: exhange where options are traded. leaving empty will return all exchanges.
	
	func optionChain(_ requestID: Int, underlying contract: IBContract, exchange: IBExchange) throws
	
}


public extension IBRequestWrapper where Self: IBAnyClient {
	
	func subscribePositionPNL(_ requestID: Int, accountName: String, contractID: Int, modelCode: [String] = []) throws {
		let request = IBPositionPNLRequest(requestID: requestID, accountName: accountName, contractID: contractID, modelCode: modelCode)
	}
	
	func optionChain(_ requestID: Int, underlying contract: IBContract, exchange: IBExchange) throws {
		let request = IBOptionChainRequest(requestID: requestID, underlying: contract, exchange: exchange)
		try send(request: request)
	}
	
	func requestNextRequestID() throws {
		let request = IBNextIDRquest()
		try send(request: request)
	}
	
	func requestServerTime() throws {
		let request = IBServerTimeRequest()
		try send(request: request)
	}
	
	func requestBulletins(includePast all: Bool = false) throws {
		let request = IBBulletinBoardRequest(includePast: all)
		try send(request: request)
	}
	
	func cancelNewsBulletins() throws {
		let request = IBBulletinBoardCancellationRequest()
		try send(request: request)
	}
	
	func setMarketDataType(_ type: IBMarketDataType ) throws {
		let request = IBMarketDataTypeRequest(type)
		try send(request: request)
	}
	
	func requestScannerParameters() throws {
		let request = IBScannerParametersRequest()
		try send(request: request)
	}
	
	func requestManagedAccounts() throws {
		let request = IBManagedAccountsRequest()
		try send(request: request)
	}
	
	func subscribeAccountUpdates(accountName: String, subscribe:Bool) throws {
		let request = IBAccountUpdateRequest(accountName: accountName, subscribe: subscribe)
		try send(request: request)
	}

	func subscribeAccountSummary(_ requestID: Int, tags: [IBAccountKey] = IBAccountKey.allValues, accountGroup group: String = "All") throws {
		let request = IBAccountSummaryRequest(requestID: requestID, tags: tags, group: group)
		try send(request: request)
	}
		
	func unsubscribeAccountSummary(_ requestID: Int) throws {
		let request = IBCancelAccountSummaryRequest(requestID: requestID)
		try send(request: request)
	}
	
	func subscribeAccountSummaryMulti(_ requestID: Int, accountName: String, ledger:Bool = true, modelCode:String? = nil) throws {
		let request = IBAccountSummaryMultiRequest(requestID: requestID, accountName: accountName, ledger: ledger, model: modelCode)
		try send(request: request)
	}
	
	func unsubscribeAccountSummaryMulti(_ requestID: Int) throws {
		let request = IBAccountSummaryMultiCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func subscribeAccountPNL(_ requestID: Int, account: String, modelCode: [String]? = nil) throws {
		let request = IBAccountPNLRequest(requestID: requestID, accountName: account, model: modelCode)
		try send(request: request)
	}
	
	func unsubscribeAccountPNL(_ requestID: Int) throws {
		let request = IBAccountPNLCancellation(requestID: requestID)
		try send(request: request)
	}
		
	func requestMarketRule(_ requestID: Int) throws {
		let request = IBMarketRuleRequest(requestID: requestID)
		try send(request: request)
	}
	
	func firstDatapointDate(_ requestID: Int, contract: IBContract, barSource: IBBarSource = .trades , extendedTrading: Bool = false) throws {
		let request = IBHeadTimestampRequest(requestID: requestID, contract: contract, source: barSource, extendedTrading: extendedTrading)
		try send(request: request)
	}
	
	func requestPriceHistory(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: DateInterval, extendedTrading: Bool = false, includeExpired: Bool = false) throws {
		
		let request = IBPriceHistoryRequest(
			requestID: requestID,
			contract: contract,
			size: size,
			source: barSource,
			lookback: lookback,
			extendedTrading: extendedTrading,
			includeExpired: includeExpired
		)
		
		try send(request: request)

	}
	
	
	func subscribeRealTimeBar(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, extendedTrading: Bool = false) throws {
		let request = IBRealTimeBarRequest(requestID: requestID, contract: contract, source: barSource, extendedTrading: extendedTrading)
		try send(request: request)
	}
	
	func unsubscribeRealTimeBar(_ requestID: Int) throws {
		let request = IBRealTimeBarCancellationRequest(requestID: requestID)
		try send(request: request)
	}

	
	func requestMarketData(_ requestID: Int, contract: IBContract, events: [IBMarketDataRequest.SubscriptionType] = [], snapshot: Bool = false, regulatory: Bool = false) throws {
		let request = IBMarketDataRequest(requestID: requestID, contract: contract, events: events, snapshot: snapshot, regulatory: regulatory)
		try send(request: request)
	}
	
	func subscribeMarketData(_ requestID: Int, contract: IBContract, snapshot: Bool = false, regulatory: Bool = false) throws {
		try requestMarketData(requestID, contract: contract, events: [], snapshot: snapshot, regulatory: regulatory)
	}
	
	func unsubscribeMarketData(_ requestID: Int) throws {
		let request = IBMarketDataCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func subscribeMarketDepth(_ requestID: Int, contract: IBContract, rows: Int, smart: Bool = false) throws {
		let request = IBMarketDepthRequest(requestID: requestID, contract: contract, rows: rows, smart: smart)
		try send(request: request)
	}
	
	func unsubscribeMarketDepth(_ requestID: Int) throws {
		let request = IBMarketDepthCancellation(requestID: requestID)
		try send(request: request)
	}
	
	func requestTickByTick(_ requestID: Int, contract: IBContract, tickType: IBTickRequest.TickType, tickCount: Int, ignoreSize: Bool = true) throws {
		let request = IBTickRequest(requestID: requestID, contract: contract, type: tickType, count: tickCount, ignoreSize: ignoreSize)
		try send(request: request)
	}
	
	func cancelTickByTickData(_ requestID: Int) throws {
		let request = IBTickCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func historicalTicks(_ requestID: Int, contract: IBContract, numberOfTicks: Int, interval: DateInterval, whatToShow: IBTickHistoryRequest.TickSource, useRth: Bool, ignoreSize: Bool) throws {
		let request = IBTickHistoryRequest( requestID: requestID,contract: contract,count: numberOfTicks,interval: interval,source: whatToShow,extendedHours: useRth,ignoreSize: ignoreSize)
		try send(request: request)
	}
	
	func subscribePositions() throws {
		let request = IBPositionRequest()
		try send(request: request)
	}
	
	func unsubscribePositions() throws {
		let request = IBPositionCancellationRequest()
		try send(request: request)
	}

	
	func subscribePositionsMulti(_ requestID: Int, accountName: String, modelCode: String = "") throws {
		let request = IBMultiPositionRequest(requestID: requestID, accountName: accountName, model: modelCode)
		try send(request: request)
	}
	
	func unsubscribePositionsMulti(_ requestID: Int) throws {
		let request = IBMultiPositionCancellationRequest(requestID: requestID)
	}
	
	
	func subscribePositionPNL(_ requestID: Int, accountName: String, contractID: Int, modelCode: [String]? = nil) throws {
		let request = IBPositionPNLRequest(requestID: requestID, accountName: accountName, contractID: contractID, modelCode: modelCode)
		try send(request: request)
	}
	
	func cancelAllOrders() throws {
		let request = IBGlobalCancelRequest()
		try send(request: request)
	}
	
	func cancelOrder(_ requestID:Int) throws {
		let request = IBCancelOrderRequest(requestID: requestID)
		try send(request: request)
	}
	
	func requestExecutions(_ requestID: Int, clientID: Int? = nil, accountName: String? = nil, date: Date? = nil, symbol: String? = nil, securityType type: IBSecuritiesType? = nil, market: IBExchange? = nil, side: IBAction? = nil ) throws {
		let request = IBExcecutionRequest( requestID: requestID, clientID: clientID, accountName: accountName, date: date, symbol: symbol, securityType: type, market: market, side: side)
		try send(request: request)
	}
	
	func requestOpenOrders() throws {
		let request = IBOpenOrderRequest()
		try send(request: request)
	}
	
	func requestAllOpenOrders() throws {
		let request = IBOpenOrderRequest.all()
		try send(request: request)
	}
	
	func requestAllOpenOrders(autoBind: Bool) throws {
		let request = IBOpenOrderRequest.autoBind(autoBind)
		try send(request: request)
	}
	
	func requestCompletedOrders(apiOnly: Bool) throws {
		let request = IBCompletedOrdersRequest(apiOnly: apiOnly)
		try send(request: request)
	}
	
	func placeOrder(_ requestID: Int, order: IBOrder) throws {
		let request = IBPlaceOrderRequest(requestID: requestID, order: order)
		try send(request: request)
	}
	
	func subscribeNews(_ requestID: Int, contract: IBContract, snapshot: Bool = false, regulatory: Bool = false) throws {
		try requestMarketData(requestID, contract: contract, events: [], snapshot: snapshot, regulatory: regulatory)
	}
	
	func searchSymbols(_ requestID: Int, nameOrSymbol text: String) throws {
		let request = IBSymbolSearchRequest(requestID: requestID, text: text)
		try send(request: request)
	}
	
	func contractDetails(_ requestID: Int, contract: IBContract) throws {
		let request = IBContractDetailsRequest(requestID: requestID, contract: contract)
		try send(request: request)
	}
	
	func subscribeFundamentals(_ requestID: Int, contract: IBContract, reportType: IBFundamantalsRequest.ReportType) throws {
		let request = IBFundamantalsRequest(requestID: requestID, contract: contract, reportType: reportType)
		try send(request: request)
	}

	
	func unsubscribeFundamentals(_ requestID: Int) throws {
		let request = IBFundamantalsCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func optionChain(_ requestID: Int, underlying contract: IBContract, exchange: IBExchange? = nil) throws {
		let request = IBOptionChainRequest(requestID: requestID, underlying: contract, exchange: exchange)
		try send(request: request)
	}
	
}
