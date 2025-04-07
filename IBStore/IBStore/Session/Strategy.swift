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
import IBClient
import Combine


open class Strategy {
	
	let id: Int
	var session: Session?
	var universe: URL
	var watchlist: Watchlist
	public var dataNeed: [ScheduledDataItem] = []
	var subscriptions: [String:AnyCancellable] = [:]
	let modelPublisher = CurrentValueSubject<[Weight], Never>([])
	
	public init(id: Int, universe: URL, watchlist: Watchlist){
		self.id = id
		self.universe = universe
		self.watchlist = watchlist
	}
	
	open func onWatchlist(changes: Watchlist.Changes) {
		fatalError("\(#function), not implemented")
	}
	
	// calculates indicators and stuff
	open func onData(_ event: MarketData)->Feature {
		fatalError("\(#function), not implemented")
	}
	
	// evaluates indicators and stuff
	open func onFeature(_ event: Feature)->TradeSignal? {
		fatalError("\(#function), not implemented")
	}
	
	// evaluates account updates
	open func onAccountUpdate(_ event: [AccountSummary]) -> RiskSignal? {
		fatalError("\(#function), not implemented")
	}
	
	// generate model portfolio weightings
	open func onSignal(){
		fatalError("\(#function), not implemented")
	}

	
	open func onModel(_ model:[Weight], account:AccountSummary) -> [IBOrder] {
		fatalError("\(#function), not implemented")
	}
	
	open func onOrder(_ event: IBOrder, quoteSummary: QuoteSummary) -> [IBOrder] {
		fatalError("\(#function), not implemented")
	}

	open func warmup() throws {
		
	}
	
	public func run(in mode: Session.RunMode) throws {
		
		self.session = try Session(id: id, universe: universe, mode: mode)
		try session?.broker.connect()
		usleep(1_000_000)
		
		guard let session = self.session else {
			throw IBError.connection("Strategy failed to start session")
		}
		
		
		// MARK: - validation and fetching initial data should be moved into warmup
		// validate contracts
		for contract in try session.store.fetchContracts(){
			let key = UUID().uuidString
			session.contractDetailsPublisher(for: contract)
				.sink { completion in
					print("will cancel \(key)")
					self.subscriptions.removeValue(forKey: key)
				} receiveValue: { details in
					do{
						try self.session?.store.addContracts([details])
					} catch {
						print(error)
					}
				}
				.store(in: &subscriptions, for: key)
		}

		// download initial historic data
		
			
		
		
		// make watchlist. reschedule refresh if needed
		
		// subscribe data for watchlist
		
		
		
		
		
		// risk metrics pipeline
		session.broker
			.accountSummaryPublisher
			.compactMap({[weak self] event -> RiskSignal? in
				self?.onAccountUpdate(event)
			})
			.sink(receiveCompletion: { completion in
				print("account summary publisher \(completion)")
			}, receiveValue: { [weak self] signal in
				print(signal)
			})
			.store(in: &subscriptions, for: "AccountSummaryPublisher")
		
	
		watchlist.makeWatchlist(store: session.store)
		
		watchlist.watchlistChangesPublisher()
			.sink { [weak self] changes in
				self?.onWatchlist(changes: changes)
			}
			.store(in: &subscriptions, for: "WatchlistChanges")
		scheduleNextUpdate(for: session)
		  

		// subscribe marketdata
		let req = IBMarketDataRequest(
			id: session.broker.nextRequestID,
			contract: IBContract.equity("NVDA", currency: "USD")
		)
		
			
	}
	
	
	// watchlist scheduller
	private func scheduleNextUpdate(for session: Session) {
				
		if let schedule = watchlist.schedule {
			session.datePublisher
				.receive(on: DispatchQueue.main)
				.sink { [weak self] date in
					guard let self = self else { return }
					if let nextDate = self.watchlist.nextDate {
						let comparison = Calendar.current.compare(date, to: nextDate, toGranularity: .hour)
						if comparison == .orderedSame || comparison == .orderedDescending {
							self.watchlist.makeWatchlist(store: session.store)
							self.watchlist.nextDate = schedule.nextDate(from: date)
						}
					}
				}
				.store(in: &subscriptions, for: "WatchlistScheduler")
		}
	}

}
