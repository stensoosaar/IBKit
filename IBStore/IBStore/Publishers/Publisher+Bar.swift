//
//  Publisher+Bar.swift
//  IBKit
//
//  Created by Sten Soosaar on 20.03.2025.
//

import Foundation
import IBClient
import Combine


public extension Publisher where Output == TickQuote {
	
	//TODO: - add midpoint and constant volume bars. Shall we publish intermediate bar updates?
	
	/// Aggregates quote events into constant time bars with open, high, low, close, volume parameters
	/// Publisher will emit new bar after its completion.
	/// Parameters:
	/// - sampleSize: time interval observation is composed
	/// - quoteType: bid, ask or trades
	func aggregate(into sampleSize: TimeInterval, quoteType: TickQuote.Side) -> Publishers.Aggregate<Self> where Output == TickQuote {
		return Publishers.Aggregate(upstream: self, sampleSize: sampleSize, quoteType: quoteType)
	}
	
}


public extension Publishers {
	
	struct Aggregate<Upstream: Publisher>: Publisher where Upstream.Output == TickQuote {
		
		public typealias Output = AnyBar
		public typealias Failure = Upstream.Failure

		private let upstream: Upstream
		private let sampleSize: TimeInterval
		private let quoteType: TickQuote.Side

		init(upstream: Upstream, sampleSize: TimeInterval, quoteType: TickQuote.Side) {
			self.upstream = upstream
			self.sampleSize = sampleSize
			self.quoteType = quoteType
		}

		public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
			let subscription = AggregateSubscription(
				subscriber: subscriber,
				upstream: upstream,
				sampleSize: sampleSize,
				quoteType: quoteType
			)
			subscriber.receive(subscription: subscription)
		}
	}
	
}


extension Publishers.Aggregate {
	
	private final class AggregateSubscription<S: Subscriber>: Subscription where S.Input == AnyBar, S.Failure == Upstream.Failure {
		
		private var subscriber: S?
		private var upstreamSubscription: AnyCancellable?
		private var currentBar: MutableTimeBar?
		private let sampleSize: TimeInterval
		private let quoteType: TickQuote.Side

		init(subscriber: S, upstream: Upstream, sampleSize: TimeInterval, quoteType: TickQuote.Side) {
			self.subscriber = subscriber
			self.sampleSize = sampleSize
			self.quoteType = quoteType
			self.upstreamSubscription = upstream.sink(
				receiveCompletion: { [weak self] completion in
					guard let self = self else { return }
					if let bar = self.currentBar {
						_ = self.subscriber?.receive(bar)
					}
					subscriber.receive(completion: completion)
				},
				receiveValue: { [weak self] quote in
					guard let self = self else { return }
					self.processQuote(quote)
				}
			)
		}

		func request(_ demand: Subscribers.Demand) {}

		func cancel() {
			subscriber = nil
			upstreamSubscription?.cancel()
			upstreamSubscription = nil
		}

		private func processQuote(_ quote: TickQuote) {
			guard quote.type.side == quoteType else { return }
			
			guard let bar = currentBar else {
				currentBar = MutableTimeBar(date: quote.date, duration: sampleSize, price: quote.price, size: quote.size)
				return
			}

			if !quote.date.inRange(bar.interval) {
				_ = subscriber?.receive(bar.convert())
				currentBar = MutableTimeBar(date: quote.date, duration: sampleSize, price: quote.price, size: quote.size)
			} else {
				currentBar?.update(date: quote.date, price: quote.price, size: quote.size)
			}
		}
	}
}
