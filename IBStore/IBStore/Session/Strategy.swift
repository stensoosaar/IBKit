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
	
	/**
	 Receives market updates and prepares feature to
	 pass for evaluation
	 
	 - Parameter data: any data type eg price history
	 - Returns: Feature
	*/
	open func onData(_ event: AnyMarketData)->Feature {
		fatalError("\(#function), not implemented")
	}
	
	/// generate optional signal
	/// - Parameter feature: collection on parameters
	/// - Returns: Signal describing trade idea
	open func onFeature(_ event: Feature)->TradeSignal? {
		fatalError("\(#function), not implemented")
	}
	
	/// evaluates account updates
	/// - Returns: Signal describing risk policy breach
	open func onAccountUpdate(_ event: [AccountSummary]) -> RiskSignal? {
		fatalError("\(#function), not implemented")
	}
	
	/// evaluates signal and update model portfolio
	/// - Parameter signal:
	/// - Returns: portfolio model
	open func onSignal(){
		fatalError("\(#function), not implemented")
	}

	/// calculate model and account delta and evaluate risks
	/// - Parameters:
	/// - model: portfolio model
	/// - accounts: simulated or real trading account
	/// - Returns: allocation model
	open func onModel(_ model:[Weight], account:AccountSummary) -> [IBOrder] {
		fatalError("\(#function), not implemented")
	}
	
	open func onOrder(_ event: IBOrder, quoteSummary: QuoteSummary) -> [IBOrder] {
		fatalError("\(#function), not implemented")
	}

	// validate
	open func warmup() throws {
		
		

	}
	
	public func run(in mode: Session.RunMode) throws {
		
		self.session = try Session(id: id, universe: universe, mode: mode)
		try session?.broker.connect()
		usleep(1_000_000)
		
		guard let session = self.session else {
			throw IBError.connection("Strategy failed to start session")
		}
		
		
		/*
		
		// MARK: - validation and fetching initial data should be moved into warmup
		
		session.fetchContractsPublisher()
			.queue(for: .milliseconds(250), scheduler: DispatchQueue.main)
			.flatMap{ session.contractDetailsPublisher(for: $0) }
			.flatMap {
				do {
					return try session.priceHistoryPublisher(for: $0.contract)
				} catch {
					return Fail(error: error).eraseToAnyPublisher() // Handle thrown error
				}
			}
			.sink { completion in
				print(completion)
			} receiveValue: { response in
				print(response)
			}
			.store(in: &subscriptions, for: "contract_validation")

		

		// make watchlist. reschedule refresh if needed
		
		// subscribe data for watchlist
		
		
		*/
		
		
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
				self?.subscribeMarketData(changes)
				self?.onWatchlist(changes: changes)
			}
			.store(in: &subscriptions, for: "WatchlistChanges")
		
		if watchlist.type == .schedulled{
			scheduleNextUpdate(for: session)
		}
		  

		// subscribe marketdata
		let req = IBMarketDataRequest(
			id: session.broker.nextRequestID,
			contract: IBContract.equity("NVDA", currency: "USD")
		)
		
		session.broker.dataTaskPublisher(for: req)
			.compactMap({$0 as? AnyTickProtocol })
			.summarize()
			.compactMap{[weak self] event in
				self?.onData(event)
			}
			.sink { completion in
				print(completion)
			} receiveValue: {  event in
				print(event)
			}
			.store(in: &subscriptions, for: "marketdatarequest")


		
		
		RunLoop.main.run()
			
	}
	
	
	
	private func subscribeMarketData(_ changes: Watchlist.Changes){
		
		guard let session = session else {return }
		
		/*
		changes.added.forEach { contract in
			print("ADDED",contract)
			do {
				let priceStream = try session.priceQuotePublisher(contract: contract)
				let cancellable = priceStream
					.handleEvents(receiveCancel: {
						print("Cancelled subscription for \(contract.symbol)")
					})
					.share()
					.multicast { PassthroughSubject<AnyTickProtocol, Error>() }

				// Bar stream
				cancellable
					.autoconnect()
					.compactMap({$0 as? TickQuote})
					.aggregate(into: 60, quoteType: .last)
					.sink(receiveCompletion: { _ in },
						receiveValue: { bar in
						print("Bar for \(contract.symbol): \(bar)")
					})
					.store(in: &session.watchlistCancellables, for: contract.symbol! + ".bar")

				// Quote summary stream
				cancellable
					.autoconnect()
					.summarize()
					.sink(receiveCompletion: { _ in },
						receiveValue: { summary in
						print("Quote summary for \(contract.symbol): \(summary)")
					})
					.store(in: &session.watchlistCancellables, for: contract.symbol! + ".summary")

			} catch {
				print("Failed to subscribe to \(contract.symbol): \(error)")
			}
		}

		changes.removed.forEach { contract in
			session.watchlistCancellables.removeValue(forKey: contract.symbol! + ".bar")?.cancel()
			session.watchlistCancellables.removeValue(forKey: contract.symbol! + ".summary")?.cancel()
			print("Unsubscribed from \(contract)")
		}
		 */
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
