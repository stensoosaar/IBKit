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
	
	var store: Store?
	
	private var accounts: [String: Account] = [:]
	
	private var accountUpdateSubject = PassthroughSubject<[Account], Never>()
	
	public let accountSummaryPublisher: AnyPublisher<[AccountSummary], Never>
		
	public init(id: Int, port: Int){
		
		accountSummaryPublisher = accountUpdateSubject.share()
			.throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: true)
			.map { accounts in accounts.map { $0.convert() } }
			.eraseToAnyPublisher()

		super.init(id: id, address: "https://127.0.0.1", port: port)


	}
	
	public enum ConnectionType: Int{
		case gateway
		case workstation
		
		public var livePort: Int {
			switch self {
			case .gateway: return 4001
			case .workstation: return 7496
			}
		}
		
		public var simulatedPort: Int {
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
	
	
	// MARK: - REQUEST BUFFER
	var accountSubscriptions: [AnyCancellable] = []
	var positionPNLSubscriptions: [String: AnyCancellable] = [:]

	
	// MARK: - ACCOUNT BALANCES
	
	open func subscribeAccountBalances(for identifiers:[String]) {
				
		let accountUpdatePublishers = identifiers.map{
			IBAccountUpdateMultiRequest(id: nextRequestID, accountName: $0, ledger: false)
		}.map{ dataTaskPublisher(for: $0)}
		
		let accountPNLRequests = identifiers.map{
			IBAccountPNLRequest(id: nextRequestID, accountName: $0)
		}.map{ accountPNLPublisher(for: $0)}

		let positionRequests = identifiers.map{
			IBMultiPositionRequest(id: nextRequestID, accountName: $0)
		}.map{ dataTaskPublisher(for: $0)}
		
		Publishers.MergeMany(accountUpdatePublishers)
			.compactMap({$0 as? IBAccountUpdateMulti})
			.collect(.byTime(DispatchQueue.main, .milliseconds(100)))
			.sink { completion in
				print(#function, completion)
			} receiveValue: { [weak self] event in
				self?.onAccountUpdate(events: event)
			}
			.store(in: &cancellables)

		Publishers.MergeMany(accountPNLRequests)
			.sink { completion in
				print(#function, completion)
			} receiveValue: { [weak self] event in
				guard let selectedAccount = self?.accounts[event.accountName],
				let update = event.result as? IBAccountPNL
				else {return}
				selectedAccount.unrealisedPNL = update.unrealized
			}
			.store(in: &cancellables)
		
		Publishers.MergeMany(positionRequests)
			.compactMap({$0 as? IBPositionSizeMulti})
			.sink { completion in
				print(completion)
			} receiveValue: { [weak self] event in
				self?.updatePositions(event)
			}
			.store(in: &cancellables)
		
		
	}
	
	private func onAccountUpdate(events: [IBAccountUpdateMulti]) {

		let groupedUpdates = Dictionary(grouping: events, by: { $0.accountName })

		for (accountName, updates) in groupedUpdates {
			
			guard let selectedAccount = accounts[accountName] else {
				print(#function, "No account found for", accountName)
				continue
			}

			for event in updates {
				switch event.key {
				case .netLiquidation:
					guard let value = event.value else {return}
					selectedAccount.netLiquidation = value
					if selectedAccount.currency == nil {
						selectedAccount.currency = event.currency
					}
				case .fullInitalMargin:
					guard let value = event.value else {return}
					selectedAccount.initialMargin = value
				case .fullMaintenanceMargin:
					guard let value = event.value else {return}
					selectedAccount.maintenanceMargin = value
				case .buyingPower:
					guard let value = event.value else {return}
					selectedAccount.buyingPower = value
				case .fullAvailableFunds:
					guard let value = event.value else {return}
					selectedAccount.availableFunds = value
				case .fullExcessLiquidity:
					guard let value = event.value else {return}
					selectedAccount.excessLiquidity = value
				case .cushion:
					guard let value = event.value else {return}
					selectedAccount.cushion = value
				case .leverage:
					selectedAccount.leverage = event.value ?? 0
				case .accountType:
					selectedAccount.type = event.currency
				case .CashBalance:
					guard let value = event.value else {return}
					selectedAccount.cash.update(event.currency, value)
				case .ExchangeRate:
					guard let value = event.value else {return}
					selectedAccount.updateRate(value, for: event.currency)
				default:
					break
				}
			}
		}
		accountUpdateSubject.send(Array(accounts.values))
	}
	
	private func populateAccounts(_ identifiers:[String]){
		
		// ensure we do not overwrte populated accounts
		guard accounts.count != identifiers.count else { return }
		
		// load persisted accounts
		let storedAccounts = try? store?.fetchAccounts(identifiers: identifiers)
		if storedAccounts?.rows.count > 0{
			print("lets populate account state from db")
		} else {
			print("populating empty accounts")
			accounts = identifiers.reduce(into: [:]) { $0[$1] = Account(name: $1) }
		}

		subscribeAccountBalances(for: identifiers)

	}
	
	
	//MARK: - POSITIONS
	// we will receive alla positions of account but need to subscribe respective position pnl separately
	// or listen prices and mark to market manually
	
	public func updatePositions(_ event: IBPositionSizeMulti){
		
		guard let contractID = event.contract.id else { return }
		
		guard let position = accounts[event.accountName]?.positions[contractID.description] else {
			let position = event.convert()
			if position.units != 0 {
				accounts[event.accountName]?.positions[contractID.description] = position
				subscribePositionPNL(for: contractID, atAccount: event.accountName)
			}
			return
		}
		
		position.units = event.position
		position.costPerUnit = event.avgCost
		position.averageCost = event.position * event.avgCost
		
		// if position is closed, unsubscribe pnl updates, update portfolio statistics and remove position from account
		
		if position.units == 0 {
			print("unsubscribing pnl \(event)")
			accounts[event.accountName]?.updateTradeStatistics(position.realizedPNL)
			accounts[event.accountName]?.positions.removeValue(forKey: contractID.description)
			let subscriptionKey = String(format:"%@_%@", contractID.description, event.accountName)
			positionPNLSubscriptions[subscriptionKey]?.cancel()
			positionPNLSubscriptions.removeValue(forKey: subscriptionKey)
		}
		
		accountUpdateSubject.send(Array(accounts.values))

	}
	
	func subscribePositionPNL(for contractID: Int, atAccount name: String){

		let request = IBPositionPNLRequest(id: nextRequestID, accountName: name, contractID: contractID)
		let subscriptionKey = String(format:"%@_%@",request.contractID.description, name)

		positionPNLPublisher(for: request)
			.sink(receiveCompletion: {completion in
				print(completion)
			}) { [weak self] event in
	
				guard let position = self?.accounts[request.accountName]?.positions[contractID.description] else { return }
				position.marketValue = event.result.marketValue
				position.marketPrice = position.marketValue / position.units
				position.unrealizedPNL = event.result.unrealizedPNL
				position.realizedPNL = event.result.realizedPNL ?? 0
				
				if let accounts = self?.accounts.values {
					self?.accountUpdateSubject.send(Array(accounts))
				}
				
			}
			.store(in: &positionPNLSubscriptions, for: subscriptionKey)

	}
	
	//MARK: - FILLS
	
	
	//MARK: - ORDER MANAGEMENT

	open func placeOrder(_ order: IBOrder) throws {

	}
	
	open func cancelOrder(_ order: IBOrder) throws {
		
	}
	
	open func onFill(){}
		
	
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
					self?.populateAccounts(event.identifiers)
					
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



extension Broker {
	
	
	func positionPNLPublisher(for request: IBPositionPNLRequest) -> AnyPublisher<PositionPNLUpdate, Error> {
		return dataTaskPublisher(for: request)
			.compactMap{$0 as? IBPositionPNL}
			.tryMap { PositionPNLUpdate(accountName: request.accountName, contractID: request.contractID, result: $0) }
			.eraseToAnyPublisher()

	}
	
	func marketDataPublisher(for request: IBMarketDataRequest) -> AnyPublisher<MarketData, Error> {
		return dataTaskPublisher(for: request)
			.tryMap { MarketData(contract: request.contract, result: $0) }
			.eraseToAnyPublisher()
	}
	
	func accountPNLPublisher(for request: IBAccountPNLRequest) -> AnyPublisher<AccountPNLUpdate, Error> {
		return dataTaskPublisher(for: request)
			.tryMap { AccountPNLUpdate(accountName: request.accountName, result: $0) }
			.eraseToAnyPublisher()
	}

}
