//
//  IBStore.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
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
import Combine
import IBClient
import Collections



open class Broker: IBClient {
	
	private var accounts: [String:Account] = [:]
	
	private var accountUpdateSubject = PassthroughSubject<[Account], Never>()
	
	public let accountSummaryPublisher: AnyPublisher<[AccountSummary], Never>
		
	public init(id: Int, port: Int){
		
		accountSummaryPublisher = accountUpdateSubject.share()
			.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
			.map { accounts in accounts.map { $0.convert() } }
			.eraseToAnyPublisher()

		super.init(id: id, address: "https://127.0.0.1", port: port)
	}
	
	public enum ConnectionType: Int{
		case gateway
		case workstation
		
		var livePort: Int {
			switch self {
			case .gateway: return 4001
			case .workstation: return 7496
			}
		}
		
		var simulatedPort: Int {
			switch self {
			case .gateway: return 4002
			case .workstation: return 7497
			}
		}
		
	}
	
	public static func live(id: Int, type: ConnectionType) -> Broker {
		return Broker(id: id, port: type.livePort)
	}
	
	public static func test(id: Int, type: ConnectionType) -> Broker {
		return Broker(id: id, port: type.simulatedPort)
	}
	
	
	//MARK: - REQUEST BUFFER

	private var activeRequests: [IBRequest] = []

	private func store(request: IBRequest) throws {
		guard !activeRequests.contains(where: {$0.id == request.id && $0.type == request.type}) else {
			throw IBError.invalidValue("request already stored")
		}
		activeRequests.append(request)
		print("STORED",request)
	}
	
	private func remove(request: IBRequest) throws {
		guard let index = activeRequests.firstIndex(where: {$0.id == request.id && $0.type == request.type}) else {
			throw IBError.invalidValue("no such request stored")
		}
		activeRequests.remove(at: index)
	}
	
	
	//MARK: - ACCOUNT MANAGEMENT

	
	private func onAccountUpdate(event: IBAccountUpdateMulti){
		
		guard accounts.keys.contains(where: {$0 == event.accountName}),
			let selectedAccount = self.accounts[event.accountName] else {
			print(#function, "no account found")
			return
		}
			
		switch event.key {
		case .netLiquidation:
			selectedAccount.netLiquidation = event.value ?? 0
			if selectedAccount.currency == nil {
				selectedAccount.currency = event.currency
			}
		case .fullInitalMargin:
			selectedAccount.initialMargin = event.value ?? 0
		case .fullMaintenanceMargin:
			selectedAccount.maintenanceMargin = event.value ?? 0
		case .buyingPower:
			selectedAccount.buyingPower = event.value ?? 0
		case .fullAvailableFunds:
			selectedAccount.availableFunds = event.value ?? 0
		case .fullExcessLiquidity:
			selectedAccount.excessLiquidity = event.value ?? 0
		case .cushion:
			selectedAccount.cushion = event.value ?? 0
		case .leverege:
			selectedAccount.leverage = event.value ?? 0
		case .accountType:
			selectedAccount.type = event.currency
		case .CashBalance:
			selectedAccount.cash.update(event.currency, event.value ?? 0)
		case .ExchangeRate:
			selectedAccount.rates[event.currency] = event.value ?? 0
			break

		default:
			break
		}
				
		accountUpdateSubject.send(Array(accounts.values))
		
	}
		
	public func updatePositions(_ event: IBPositionSizeMulti){
		guard let contractKey = event.contract.id?.description else { return }
		guard let position = accounts[event.accountName]?.positions[contractKey] else {
			let position = event.convert()
			accounts[event.accountName]?.positions[contractKey] = position
			let request = IBPositionPNLRequest(id: nextRequestID, accountName: event.accountName, contractID: event.contract.id!)
			subscribePositionPNL(request)
			return
		}
		position.units = event.position
		position.costPerUnit = event.avgCost
		position.averageCost = event.position * event.avgCost
		
		
		//
		// if position is closed, unsubscribe pnl updates, update portfolio statistics and remove position from account
		//
		
		if position.units == 0 {
			let storedRequest = activeRequests.compactMap({$0 as? IBPositionPNLRequest}).first(where: {$0.contractID == event.contract.id})
			if let requestID = storedRequest?.id {
				let unsubscribeRequest = IBMultiPositionCancellationRequest(id: requestID)
				try? remove(request: unsubscribeRequest)
			}
			accounts[event.accountName]?.updateTradeStatistics(position.realizedPNL)
			accounts[event.accountName]?.positions.removeValue(forKey: contractKey)
		}
		
		accountUpdateSubject.send(Array(accounts.values))

	}
	
	func subscribePositionPNL(_ request: IBPositionPNLRequest){

		let contractKey = request.contractID.description

		dataTaskPublisher(for: request)
			.sink(receiveCompletion: {completion in
				
			}) { [weak self] event in
				
				guard let event = event as? IBPositionPNL,
					  let position = self?.accounts[request.accountName]?.positions[contractKey]
				else { return }
				
				position.marketValue = event.marketValue
				position.marketPrice = position.marketValue / position.units
				position.unrealizedPNL = event.unrealizedPNL
				position.realizedPNL = event.realizedPNL ?? 0
				
				if let accounts = self?.accounts.values {
					self?.accountUpdateSubject.send(Array(accounts))
				}
				
			}
			.store(in: &cancellables)

	}
	
	open func subscribeAccountBalances(for identifiers:[String]) {

		for identifier in identifiers {

			let accountUpdateRequest = IBAccountUpdateMultiRequest(id: nextRequestID, accountName: identifier, ledger: false)
			dataTaskPublisher(for:accountUpdateRequest)
				.compactMap({$0 as? IBAccountUpdateMulti})
				.sink(receiveCompletion: { completion in
					print(#function, completion)
				}, receiveValue: { [weak self] update in
					self?.onAccountUpdate(event: update)
				})
				.store(in: &cancellables)
				
			let accountPNLRequest = IBAccountPNLRequest(id: nextRequestID, accountName: identifier)
			dataTaskPublisher(for: accountPNLRequest)
				.compactMap({$0 as? IBAccountPNL})
				.sink(receiveCompletion: { completion in
					print(#function, completion)
				}, receiveValue: { [weak self] update in
					guard let selectedAccount = self?.accounts[identifier] else {return}
					selectedAccount.unrealisedPNL = update.unrealized
				})
				.store(in: &cancellables)
				
			let positionRequest = IBMultiPositionRequest(id: nextRequestID, accountName: identifier)
			dataTaskPublisher(for: positionRequest)
				.compactMap({$0 as? IBPositionSizeMulti})
				.sink(receiveCompletion: { completion in
					print(#function, completion)
				}, receiveValue: { [weak self] update in
					self?.updatePositions(update)
				})
				.store(in: &cancellables)
				
		}
		
	}

	
	//MARK: - ORDER MANAGEMENT

	open func placeOrder(_ order: IBOrder) throws {
		let id = nextRequestID
		let request = IBPlaceOrderRequest(id: id, order: order)
		try send(request)
	}
	
	open func cancelOrder(_ order: IBOrder) throws {
		
	}
		
	
	//MARK: - ON CONNECT
	
	open override func onConnect() {
		self.eventFeed
			.compactMap{ try? $0.get() }
			.sink { completion in
				print(completion)
			} receiveValue: { [weak self] response in
				
				switch response {
	
				case let event as IBNextRequestID:
					self?.nextRequestID = event.value
				
				case let event as IBManagedAccounts:
					guard self?.accounts.count != event.identifiers.count else { break }
					self?.accounts = event.identifiers.reduce(into: [:]) { $0[$1] = Account(name: $1) }
					//TODO: - update statistics from persistance
					self?.subscribeAccountBalances(for: event.identifiers)
					
				case let event as IBPositionSizeMulti:
					self?.updatePositions(event)
					
				case let event as IBAccountUpdateTime:
					self?.accounts.keys.forEach { key in
						self?.accounts[key]?.updatedAt = event.timestamp
					}
					
				case let event as IBOpenOrder:
					
					let rejections: [IBOrder.Status] = [.apiCancelled, .cancelled]
					if !rejections.contains(event.order.orderState.status) { return }
					
					guard let account = self?.accounts[event.order.account] else { return }
					account.orders[event.order.permID.description] = event.order
					
					print(account.orders)
					
				case let event as IBOrderExecution:
					print("orderevent", event)
					
					
				case let event as IBOrderStatus:
					print("orderevent", event)
					// updte fills
					
				default:
					break
				}
			}
			.store(in: &cancellables)
	}
	
}



