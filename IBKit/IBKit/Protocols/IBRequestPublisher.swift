//
//  IBRequestWrapper.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.02.2025.
//


import Foundation
import Combine

public protocol IBRequestPublisher {
	
	// MARK: - ACCOUNT
	
	/// Requests account identifiers
	func requestManagedAccounts() throws -> Future<IBManagedAccounts,Never>

	
	/// Subscribe account values, portfolio and last update time information
	/// - Parameter accountName: account name
	func subscribeAccountUpdates(accountName: String) throws -> AnyPublisher<AnyAccountUpdate, Never>

	
	/// Unsubscribe account values, portfolio and last update time information
	/// - Parameter accountName: account name
	func unsubscribeAccountUpdates(accountName: String) throws

	
	/// Subscribes account summary. Emits AccountSummaryEnd message after initial values, thereafter incremental updates
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter tags: Array of IBAccountKeys to specify what to subscribe. As a default, all keys will be subscribed
	/// - Parameter accountGroup:
	/// - Returns: AccountSummary event per specified tag and will be updated once per 3 minutes
	func subscribeAccountSummary(_ requestID: Int, tags: [IBAccountKey], accountGroup group: String) throws -> AnyPublisher<AnyAccountSummary,Never>
	
	
	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event
	func unsubscribeAccountSummary(_ requestID: Int) throws
	
	
	/// Subscribes account summary.
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter tags: Array of IBAccountKeys to specify what to subscribe. As a default, all keys will be subscribed
	/// - Parameter accountGroup:
	/// - Returns: AccountSummary event per specified tag and will be updated once per 3 minutes
	func subscribeAccountSummaryMulti(_ requestID: Int, accountName: String, ledger:Bool, modelCode:String?) throws -> AnyPublisher<AnyAccountSummary,Never>
	
	
	/// Unsubscribes account summary
	/// - Parameter requestID: 	unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Returns: AccountSummaryEnd event
	func unsubscribeAccountSummaryMulti(_ requestID: Int) throws
	
	
	/// Subscribes account profit and loss reporting
	/// - Parameter requestID: unique request identifier. Best way to obtain one, is by calling client.getNextID().
	/// - Parameter account: account identifier.
	/// - Parameter modelCode:
	/// - Returns: AccountPNL event
	func subscribeAccountPNL(_ requestID: Int, account: String, modelCode: [String]?) throws -> AnyPublisher<IBAccountPNL,Never>
	
	
	/// Unsubscribes account profit and loss reporting
	/// - Parameter requestIDunique request identifier. Best way to obtain one, is by calling client.getNextID().
	func unsubscribeAccountPNL(_ requestID: Int) throws
	

	func subscribePositions() throws -> AnyPublisher<AnyPosition,Never>

	func unsubscribePositions() throws

	func subscribePositionsMulti(_ requestID: Int, accountName: String, modelCode: String) throws
	
	func unsubscribePositionsMulti(_ requestID: Int) throws
	
	func subscribePositionPNL(_ requestID: Int, accountName: String, contract: IBContract, modelCode: [String]) throws -> AnyPublisher<IBPositionPNL,IBServerError>

	
	// MARK: - MARKET DATA

	
	/// Requests first date for specific dataset
	/// - Parameter reqId: request ID
	/// - Parameter contract: contract description
	/// - Parameter barSource: data type to build a bar
	/// - Parameter extendedTrading: use only data from regular trading hours
	/// - Returns: FirstDatapoint event
	func firstDatapointDate(_ requestID: Int, contract: IBContract, barSource: IBBarSource, extendedTrading: Bool) throws -> Future<IBHeadTimestamp, IBServerError>

	
	/// Requests historic prices and continues updates for contract
	/// - Parameter reqId: request ID
	/// - Parameter contract: contract description
	/// - Parameter barSize: what resolution one bar should be
	/// - Parameter barSource: data type to build a bar
	/// - Parameter lookback: date interval of request.
	/// - Parameter extendedTrading: shall data from extended trading hours be included or not
	/// - Returns: PriceHistory event. If IBDuration continousUpdates selected, also PriceBar event of requested resolution will be included as they occur
	
	func subscribePriceHistory(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: DateInterval, extendedTrading: Bool, includeExpired: Bool) throws -> AnyPublisher<IBAnyPriceObservation, IBServerError>

	/// Requests real time bars with duration of 5 second
	/// - Parameter reqId: request ID
	/// - Parameter contract: contract description
	/// - Parameter barSource: data type to build a bar
	/// - Parameter lookback: date interval of request.
	/// - Parameter extendedTrading: shall data from extended trading hours be included or not
	/// - Returns: PriceHistory event. If IBDuration continousUpdates selected, also PriceBar event of requested resolution will be included as they occur
	//func requestPriceHistory(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: DateInterval, extendedTrading: Bool, includeExpired: Bool) throws -> Future<IBPriceHistory, IBServerError>
	
	
	func subscribeRealTimeBar(_ requestID: Int, contract: IBContract,  barSource: IBBarSource, extendedTrading: Bool) throws -> AnyPublisher<IBPriceBarUpdate, IBServerError>
	
	//func requestMarketData(_ requestID: Int, contract:IBContract, events: [IBMarketDataRequest.SubscriptionType], snapshot: Bool, regulatory: Bool) throws -> AnyPublisher<any IBAnyMarketData,IBServerError>
	
	
	/// subscribes live quote events including bid / ask / last trade and respective sizes
	/// - Parameter reqId:
	/// - Parameter contract:
	/// - Parameter snapshot:
	/// - Parameter regulatory:
	
	func subscribePriceQuote(_ requestID: Int, contract: IBContract, snapshot: Bool, regulatory: Bool) throws -> AnyPublisher<any IBAnyMarketData,IBServerError>
		
	func unsubscribeMarketData(_ requestID: Int) throws
	
	
	func subscribeMarketDepth(_ requestID: Int, contract: IBContract, rows: Int, smart: Bool) throws -> AnyPublisher<IBMarketDepth,IBServerError>

	func unsubscribeMarketDepth(_ requestID: Int) throws
	
	
	func requestTickByTick(_ requestID: Int, contract: IBContract, tickType: IBTickRequest.TickType, tickCount: Int, ignoreSize: Bool) throws -> AnyPublisher<any IBAnyMarketData, IBServerError>
	
	
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
	
	
	func subscribeNews(_ requestID: Int, contract: IBContract, snapshot: Bool, regulatory: Bool) throws -> AnyPublisher<IBNews,IBServerError>


	// MARK: - ORDERS
	
	///	Requests details about how the minimum price increment changes with price
	/// - Parameter marketRuleID: market rule id (as defined in ContractDetails marketRuleId list)
	func requestMarketRule(_ marketRuleID: Int) throws -> Future<IBMarketRule, Never>

	func requestOpenOrders() throws
	
	func requestAllOpenOrders() throws
	
	func requestAllOpenOrders(autoBind: Bool) throws
	
	func requestCompletedOrders(apiOnly: Bool) throws
	
	/// Sends order to the broker
	/// - Parameters:
	/// - requestID: Request id
	/// - oredr: IBOrder object
	/// - Returns: IBOpenOrder, IBOrderStatus, IBOrderExecution
	func placeOrder(_ requestID: Int, order: IBOrder) throws -> AnyPublisher<AnyOrderUpdate,IBServerError>

	func cancelAllOrders() throws
	
	func cancelOrder(_ requestID:Int) throws
	
	func requestExecutions(_ requestID: Int, clientID: Int?, accountName: String?, date: Date?, symbol: String?, securityType type: IBSecuritiesType?, market: IBExchange?, side: IBAction?) throws


	//MARK: - CONTRACTS
	
	
	func searchSymbols(_ requestID: Int, nameOrSymbol text: String) throws -> Future<IBContractSearchResult,IBServerError>
	
	func contractDetails(_ requestID: Int, contract: IBContract) throws -> Future<AnyContractDetails,IBServerError>
	
	func subscribeFundamentals(_ requestID: Int, contract: IBContract, reportType: IBFundamantalsRequest.ReportType) throws -> Future<IBFinancialReport,IBServerError>

	func unsubscribeFundamentals(_ requestID: Int) throws
	
	
	/// Requests security definition option parameters for viewing a contract's option chain.
	/// - Parameters:
	/// - requestID: request index
	/// - underlying: underlying contract. symbol, type and contractID are required
	/// - exchange: exhange where options are traded. leaving empty will return all exchanges.
	
	func optionChain(_ requestID: Int, underlying contract: IBContract, exchange: IBExchange) throws -> AnyPublisher<IBOptionChain,IBServerError>
	
}



public extension IBRequestPublisher where Self: IBAnyClient {
	
	
	func optionChain(_ requestID: Int, underlying contract: IBContract, exchange: IBExchange) throws  -> AnyPublisher<IBOptionChain,IBServerError> {
		let request = IBOptionChainRequest(requestID: requestID, underlying: contract, exchange: exchange)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> IBOptionChain in
				switch response {
				case let event as IBOptionChain: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
		
	}
	
	func requestNextRequestID() throws {
		let request = IBNextIDRquest()
		try send(request: request)
	}
	
	func requestServerTime() throws {
		let request = IBServerTimeRequest()
		try send(request: request)
	}
	
	func requestBulletins(includePast all: Bool = false) throws -> AnyPublisher<IBNewsBulletin,Never>{
		let request = IBBulletinBoardRequest(includePast: all)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.compactMap { $0 as? IBNewsBulletin }
			.eraseToAnyPublisher()
		)
		
	}
	
	func cancelNewsBulletins() throws {
		let request = IBBulletinBoardCancellationRequest()
		try send(request: request)
	}

	func requestManagedAccounts() throws -> Future<IBManagedAccounts,Never> {
		let request = IBManagedAccountsRequest()
		try send(request: request)
	
		return Future { promise in
			var cancellable: AnyCancellable?
			cancellable = self.eventFeed
				.compactMap { $0 as? IBManagedAccounts }
				.sink{ value in
					promise(.success(value))
					cancellable?.cancel()
				}
		}
	
	}
	
	func subscribeAccountUpdates(accountName: String) throws -> AnyPublisher<AnyAccountUpdate, Never>{
		let request = IBAccountUpdateRequest(accountName: accountName, subscribe: true)
		try send(request: request)
		
		return self.eventFeed
			.compactMap({ $0 as? AnyAccountUpdate })
			.filter { $0.accountName == accountName }
			.eraseToAnyPublisher()
		
	}

	func unsubscribeAccountUpdates(accountName: String) throws {
		let request = IBAccountUpdateRequest(accountName: accountName, subscribe: false)
		try send(request: request)
	}

	func subscribeAccountSummary(_ requestID: Int, tags: [IBAccountKey] = IBAccountKey.allValues, accountGroup group: String = "All") throws -> AnyPublisher<AnyAccountSummary,Never>{
		let request = IBAccountSummaryRequest(requestID: requestID, tags: tags, group: group)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.compactMap{ response -> AnyAccountSummary? in
				switch response {
				case let event as IBAccountSummary: return event
				case let event as IBAccountSummaryEnd: return event
				default: return nil
				}
			}
			.eraseToAnyPublisher()
		)
		
	}
		
	func unsubscribeAccountSummary(_ requestID: Int) throws {
		let request = IBCancelAccountSummaryRequest(requestID: requestID)
		try send(request: request)
	}
	
	func subscribeAccountSummaryMulti(_ requestID: Int, accountName: String, ledger:Bool = true, modelCode:String? = nil) throws  -> AnyPublisher<AnyAccountSummary,Never> {
		let request = IBAccountSummaryMultiRequest(requestID: requestID, accountName: accountName, ledger: ledger, model: modelCode)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.compactMap{ response -> AnyAccountSummary? in
				switch response {
				case let event as IBAccountSummaryMulti: return event
				case let event as IBAccountSummaryMultiEnd: return event
				default: return nil
				}
			}
			.eraseToAnyPublisher()
		)
	}
	
	func unsubscribeAccountSummaryMulti(_ requestID: Int) throws {
		let request = IBAccountSummaryMultiCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func subscribeAccountPNL(_ requestID: Int, account: String, modelCode: [String]? = nil) throws -> AnyPublisher<IBAccountPNL,Never>{
		let request = IBAccountPNLRequest(requestID: requestID, accountName: account, model: modelCode)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.compactMap { $0 as? IBAccountPNL }
			.filter { $0.requestID == requestID }
			.eraseToAnyPublisher()
		)
	}
	
	func unsubscribeAccountPNL(_ requestID: Int) throws {
		let request = IBAccountPNLCancellation(requestID: requestID)
		try send(request: request)
	}
		
	func requestMarketRule(_ marketRuleID: Int) throws -> Future<IBMarketRule, Never>{
		let request = IBMarketRuleRequest(marketRuleID: marketRuleID)
		try send(request: request)
		
		return Future { promise in
			var cancellable: AnyCancellable?
			cancellable = self.eventFeed
				.compactMap { $0 as? IBMarketRule }
				.sink { completion in
					switch completion {
					case .failure(let error):
						promise(.failure(error))
						cancellable?.cancel()
					case .finished:
						cancellable?.cancel()
					}
				} receiveValue: { value in
					promise(.success(value))
					cancellable?.cancel()
				}
		}
	}
	
	func setMarketDataType(_ type: IBMarketDataType ) throws {
		let request = IBMarketDataTypeRequest(type)
		try send(request: request)
	}

	func firstDatapointDate(_ requestID: Int, contract: IBContract, barSource: IBBarSource = .trades , extendedTrading: Bool = false) throws -> Future<IBHeadTimestamp, IBServerError>{
		
		let request = IBHeadTimestampRequest(requestID: requestID, contract: contract, source: barSource, extendedTrading: extendedTrading)
		try send(request: request)
		
		return Future { promise in
			var cancellable: AnyCancellable?
			cancellable = self.eventFeed
				.setFailureType(to: IBServerError.self)
				.compactMap { $0 as? IBIndexedEvent }
				.filter { $0.requestID == requestID }
				.tryMap{ response -> IBHeadTimestamp in
					switch response {
					case let event as IBHeadTimestamp: return event
					case let event as IBServerError: throw event
					default: fatalError("\(#function) uknown event type received")
					}
				}
				.mapError { $0 as! IBServerError }
				.sink { completion in
					switch completion {
					case .failure(let error):
						promise(.failure(error))
						cancellable?.cancel()
					case .finished:
						cancellable?.cancel()
					}
				} receiveValue: { value in
					promise(.success(value))
					cancellable?.cancel()
				}
		}

		
	}
	
	func requestScannerParameters() throws -> Future<IBScannerParameters,Never> {
		let request = IBScannerParametersRequest()
		try send(request: request)
		
		return Future { promise in
			var cancellable: AnyCancellable?
			cancellable = self.eventFeed
				.compactMap({$0 as? IBScannerParameters })
				.sink { completion in
					switch completion {
					case .failure(let error):
						promise(.failure(error))
						cancellable?.cancel()
					case .finished:
						cancellable?.cancel()
					}
				} receiveValue: { value in
					promise(.success(value))
					cancellable?.cancel()
				}
		}
		
	}

	func requestPriceHistory(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: DateInterval, extendedTrading: Bool = false, includeExpired: Bool = false) throws -> AnyPublisher<IBAnyPriceObservation, IBServerError> {
		
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
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> IBAnyPriceObservation in
				switch response {
				case let event as IBPriceHistory: return event
				case let event as IBPriceBarUpdate: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
		
	}
	
	func subscribeRealTimeBar(_ requestID: Int, contract: IBContract, barSource: IBBarSource, extendedTrading: Bool = false) throws -> AnyPublisher<IBPriceBarUpdate, IBServerError> {
		let request = IBRealTimeBarRequest(requestID: requestID, contract: contract, source: barSource, extendedTrading: extendedTrading)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> IBPriceBarUpdate in
				switch response {
				case let event as IBPriceBarUpdate: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
	}
	
	func unsubscribeRealTimeBar(_ requestID: Int) throws {
		let request = IBRealTimeBarCancellationRequest(requestID: requestID)
		try send(request: request)
	}

	
	func requestMarketData(_ requestID: Int, contract: IBContract, events: [IBMarketDataRequest.SubscriptionType] = [], snapshot: Bool = false, regulatory: Bool = false) throws {
		let request = IBMarketDataRequest(requestID: requestID, contract: contract, events: events, snapshot: snapshot, regulatory: regulatory)
		try send(request: request)
	}
	
	
	func subscribePriceQuote(_ requestID: Int, contract: IBContract, snapshot: Bool = false, regulatory: Bool = false) throws -> AnyPublisher<any IBAnyMarketData,IBServerError>{
		
		let request = IBMarketDataRequest(requestID: requestID, contract: contract, events: [], snapshot: snapshot, regulatory: regulatory)
		try send(request: request)

		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> any IBAnyMarketData in
				switch response {
				case let event as IBTick: return event
				case let event as IBTickParameters: return event
				case let event as IBCurrentMarketDataType: return event
				case let event as IBTickExchange: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received\n\(response)")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
		
		
		
	}
	
	func unsubscribeMarketData(_ requestID: Int) throws {
		let request = IBMarketDataCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func cancelHistoricalData(_ requestID: Int) throws {
		let request = IBIBPriceHistoryCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func subscribeMarketDepth(_ requestID: Int, contract: IBContract, rows: Int, smart: Bool = false) throws -> AnyPublisher<IBMarketDepth,IBServerError>{
		let request = IBMarketDepthRequest(requestID: requestID, contract: contract, rows: rows, smart: smart)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> IBMarketDepth in
				switch response {
				case let event as IBMarketDepth: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
	}
	
	func unsubscribeMarketDepth(_ requestID: Int) throws {
		let request = IBMarketDepthCancellation(requestID: requestID)
		try send(request: request)
	}
	
	func requestTickByTick(_ requestID: Int, contract: IBContract, tickType: IBTickRequest.TickType, tickCount: Int, ignoreSize: Bool) throws -> AnyPublisher<any IBAnyMarketData, IBServerError> {
		let request = IBTickRequest(requestID: requestID, contract: contract, type: tickType, count: tickCount, ignoreSize: ignoreSize)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> any IBAnyMarketData in
				switch response {
				case let event as IBTick: return event
				case let event as IBTickExchange: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received \(response)")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
	}
	
	func cancelTickByTickData(_ requestID: Int) throws {
		let request = IBTickCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	
	func historicalTicks(_ requestID: Int, contract: IBContract, numberOfTicks: Int, interval: DateInterval, whatToShow: IBTickHistoryRequest.TickSource, useRth: Bool, ignoreSize: Bool) throws {
		let request = IBTickHistoryRequest( requestID: requestID,contract: contract,count: numberOfTicks,interval: interval,source: whatToShow,extendedHours: useRth,ignoreSize: ignoreSize)
		try send(request: request)
	}
	
	func subscribePositions() throws -> AnyPublisher<AnyPosition,Never>{
		let request = IBPositionRequest()
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.compactMap { $0 as? AnyPosition }
			.eraseToAnyPublisher()
		)
	
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
	
	func requestExecutions(_ requestID: Int, clientID: Int? = nil, accountName: String? = nil, date: Date? = nil, symbol: String? = nil, securityType type: IBSecuritiesType? = nil, market: IBExchange? = nil, side: IBAction? = nil ) throws {
		let request = IBExcecutionRequest( requestID: requestID, clientID: clientID, accountName: accountName, date: date, symbol: symbol, securityType: type, market: market, side: side)
		try send(request: request)
	}

	
	
	// - TODO
	func subscribeNews(_ requestID: Int, contract: IBContract, snapshot: Bool = false, regulatory: Bool = false) throws -> AnyPublisher<IBNews,IBServerError>{
		
		try requestMarketData(requestID, contract: contract, events: [], snapshot: snapshot, regulatory: regulatory)
		
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> IBNews in
				switch response {
				case let event as IBNews: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
		
	}
	
	
	func searchSymbols(_ requestID: Int, nameOrSymbol text: String) throws -> Future<IBContractSearchResult,IBServerError>{
		let request = IBSymbolSearchRequest(requestID: requestID, text: text)
		try send(request: request)
		
		return Future { promise in
			var cancellable: AnyCancellable?
			cancellable = self.eventFeed
				.setFailureType(to: IBServerError.self)
				.compactMap { $0 as? IBIndexedEvent }
				.filter { $0.requestID == requestID }
				.tryMap{ response -> IBContractSearchResult in
					switch response {
					case let event as IBContractSearchResult: return event
					case let event as IBServerError: throw event
					default: fatalError("\(#function) uknown event type received")
					}
				}
				.mapError { $0 as! IBServerError }
				.sink { completion in
					switch completion {
					case .failure(let error):
						promise(.failure(error))
						cancellable?.cancel()
					case .finished:
						cancellable?.cancel()
					}
				} receiveValue: { value in
					promise(.success(value))
					cancellable?.cancel()
				}
		}
	}
	
	
	func contractDetails(_ requestID: Int, contract: IBContract) throws -> Future<AnyContractDetails,IBServerError>{
		let request = IBContractDetailsRequest(requestID: requestID, contract: contract)
		try send(request: request)
	
		return Future { promise in
			var cancellable: AnyCancellable?
			cancellable = self.eventFeed
				.setFailureType(to: IBServerError.self)
				.compactMap { $0 as? IBIndexedEvent }
				.filter { $0.requestID == requestID }
				.tryMap{ response -> AnyContractDetails in
					switch response {
					case let event as IBContractDetails: return event
					case let event as IBContractDetailsEnd: return event
					case let event as IBServerError: throw event
					default: fatalError("\(#function) uknown event type received")
					}
				}
				.mapError { $0 as! IBServerError }
				.sink { completion in
					switch completion {
					case .failure(let error):
						promise(.failure(error))
						cancellable?.cancel()
					case .finished:
						cancellable?.cancel()
					}
				} receiveValue: { value in
					promise(.success(value))
					cancellable?.cancel()
				}
		}
	
	}
	
	
	func subscribeFundamentals(_ requestID: Int, contract: IBContract, reportType: IBFundamantalsRequest.ReportType) throws -> Future<IBFinancialReport,IBServerError> {
		
		let request = IBFundamantalsRequest(requestID: requestID, contract: contract, reportType: reportType)
		try send(request: request)
		
		return Future { promise in
			var cancellable: AnyCancellable?
			cancellable = self.eventFeed
				.setFailureType(to: IBServerError.self)
				.compactMap { $0 as? IBIndexedEvent }
				.filter { $0.requestID == requestID }
				.tryMap{ response -> IBFinancialReport in
					switch response {
					case let event as IBFinancialReport: return event
					case let event as IBServerError: throw event
					default: fatalError("\(#function) uknown event type received")
					}
				}
				.mapError { $0 as! IBServerError }
				.sink { completion in
					switch completion {
					case .failure(let error):
						promise(.failure(error))
						cancellable?.cancel()
					case .finished:
						cancellable?.cancel()
					}
				} receiveValue: { value in
					promise(.success(value))
					cancellable?.cancel()
				}
		}
		
	}

	
	func unsubscribeFundamentals(_ requestID: Int) throws {
		let request = IBFundamantalsCancellationRequest(requestID: requestID)
		try send(request: request)
	}
	

	
	func subscribePositionPNL(_ requestID: Int, accountName: String, contract: IBContract, modelCode: [String] = []) throws -> AnyPublisher<IBPositionPNL,IBServerError> {
		
		guard let contractID = contract.id else { throw IBClientError.invalidValue("contract id expected") }
		let request = IBPositionPNLRequest(requestID: requestID, accountName: accountName, contractID: contractID, modelCode: modelCode)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> IBPositionPNL in
				switch response {
				case let event as IBPositionPNL: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
		
	}
	
	
	func subscribePriceHistory(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: DateInterval, extendedTrading: Bool, includeExpired: Bool) throws -> AnyPublisher<any IBAnyPriceObservation, IBServerError> {
		
		
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> IBAnyPriceObservation in
				switch response {
				case let event as IBPriceHistory: return event
				case let event as IBPriceBarUpdate: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
		
		
	}
	

	
	func placeOrder(_ requestID: Int, order: IBOrder) throws -> AnyPublisher<any AnyOrderUpdate, IBServerError> {
		
		let request = IBPlaceOrderRequest(requestID: requestID, order: order)
		try send(request: request)
		
		return AnyPublisher(self.eventFeed
			.setFailureType(to: IBServerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap{ response -> AnyOrderUpdate in
				switch response {
				case let event as IBOpenOrder: return event
				case let event as IBOrderStatus: return event
				case let event as IBOrderExecution: return event
				case let event as IBOrderExecutionEnd: return event
				case let event as IBOrderCompletion: return event
				case let event as IBOrderCompletionEnd: return event
				case let event as IBServerError: throw event
				default: fatalError("\(#function) uknown event type received")
				}
			}
			.mapError { $0 as! IBServerError }
			.eraseToAnyPublisher()
		)
	}
	

	/*
	public func requestPriceHistory(_ requestID: Int, contract: IBContract, barSize size: IBBarSize, barSource: IBBarSource, lookback: DateInterval, extendedTrading: Bool, includeExpired: Bool) throws -> Future<IBPriceHistory, IBServerError> {
		
	}
	
	public func requestMarketData(_ requestID: Int, contract: IBContract, events: [IBMarketDataRequest.SubscriptionType], snapshot: Bool, regulatory: Bool) throws -> AnyPublisher<any IBAnyMarketData, IBServerError> {
		
	}
	*/

}
