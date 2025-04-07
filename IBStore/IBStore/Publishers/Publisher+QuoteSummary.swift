//
//  Publishers+QuoteSummary.swift
//  IBKit
//
//  Created by Sten Soosaar on 22.03.2025.
//


import Foundation
import IBClient
import Combine



public extension Publisher where Output == AnyTickProtocol {
	
	/// Summarizes downstreamed tick events into summary and publish summary on each update
	/// if you dont need every update, adjust update frequency with debounce operator
	func summarize() -> Publishers.Summarize<Self> where Output == AnyTickProtocol {
		return Publishers.Summarize(upstream: self)
	}
	
}


public extension Publishers {
	
	struct Summarize<Upstream: Publisher>: Publisher where Upstream.Output == AnyTickProtocol {
		
		public typealias Output = QuoteSummary
		public typealias Failure = Upstream.Failure

		private let upstream: Upstream

		init(upstream: Upstream) {
			self.upstream = upstream
		}

		public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
			let subscription = SummarizeSubscription(subscriber: subscriber, upstream: upstream )
			subscriber.receive(subscription: subscription)
		}
	}
	
}


extension Publishers.Summarize {
	
	final class SummarizeSubscription<S: Subscriber>: Subscription where S.Input == QuoteSummary, S.Failure == Upstream.Failure {
		
		private var subscriber: S?
		private var upstreamSubscription: AnyCancellable?
		private var quoteSummary = QuoteSummary()

		init(subscriber: S, upstream: Upstream) {
			self.subscriber = subscriber
			
			self.upstreamSubscription = upstream
				.sink(receiveCompletion: { [weak self] completion in
					self?.subscriber?.receive(completion: completion)
					self?.cancel()
				}, receiveValue: { [weak self] quoteEvent in
					self?.handleNewQuote(quoteEvent)
				})
		}

		func request(_ demand: Subscribers.Demand) {}

		func cancel() {
			subscriber = nil
			upstreamSubscription?.cancel()
			upstreamSubscription = nil
		}
		
		private func handleNewQuote(_ event: AnyTickProtocol) {
			quoteSummary.update(event)
			_ = subscriber?.receive(quoteSummary)
		}
	}
}
