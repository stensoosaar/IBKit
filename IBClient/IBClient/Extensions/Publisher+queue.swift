//
//  QueueSubject.swift
//  
//
//  Created by Sten Soosaar on 06.04.2025.
//

import Foundation
import Combine


public extension Publisher {
	func queue<Context: Scheduler>(
		for interval: Context.SchedulerTimeType.Stride,
		scheduler: Context
	) -> Publishers.Queue<Self, Context> {
		Publishers.Queue(upstream: self, interval: interval, scheduler: scheduler)
	}
}


extension Publishers {
	public struct Queue<Upstream: Publisher, Context: Scheduler>: Publisher {
		public typealias Output = Upstream.Output
		public typealias Failure = Upstream.Failure

		private let upstream: Upstream
		private let interval: Context.SchedulerTimeType.Stride
		private let scheduler: Context

		public init(upstream: Upstream,
					interval: Context.SchedulerTimeType.Stride,
					scheduler: Context) {
			self.upstream = upstream
			self.interval = interval
			self.scheduler = scheduler
		}

		public func receive<S: Subscriber>(subscriber: S)
		where S.Input == Output, S.Failure == Failure {
			let inner = Inner(downstream: subscriber,
							interval: interval,
							scheduler: scheduler)
			upstream.subscribe(inner)
		}

		private final class Inner<Downstream: Subscriber>: Subscriber, Subscription
		where Downstream.Input == Upstream.Output, Downstream.Failure == Upstream.Failure {
			typealias Input = Upstream.Output
			typealias Failure = Upstream.Failure

			private let lock = NSLock()
			private var downstream: Downstream?
			private var upstreamSubscription: Subscription?
			private var buffer: [Input] = []
			private var downstreamDemand: Subscribers.Demand = .none
			private var completed: Bool = false
			private let interval: Context.SchedulerTimeType.Stride
			private let scheduler: Context
			private var isScheduled = false

			init(downstream: Downstream,
				 interval: Context.SchedulerTimeType.Stride,
				 scheduler: Context) {
				self.downstream = downstream
				self.interval = interval
				self.scheduler = scheduler
			}

			func request(_ demand: Subscribers.Demand) {
				guard demand > .none else { return }
				
				lock.lock()
				downstreamDemand += demand
				let shouldSchedule = !buffer.isEmpty && !isScheduled
				lock.unlock()

				if shouldSchedule {
					scheduleNext()
				}
			}

			func cancel() {
				lock.lock()
				upstreamSubscription?.cancel()
				upstreamSubscription = nil
				downstream = nil
				buffer.removeAll()
				isScheduled = false
				lock.unlock()
			}

			func receive(subscription: Subscription) {
				lock.lock()
				upstreamSubscription = subscription
				lock.unlock()
				downstream?.receive(subscription: self)
				subscription.request(.unlimited)
			}

			func receive(_ input: Input) -> Subscribers.Demand {
				lock.lock()
				buffer.append(input)
				let shouldSchedule = downstreamDemand > .none && !isScheduled
				lock.unlock()

				if shouldSchedule {
					scheduleNext()
				}
				return .none
			}

			func receive(completion: Subscribers.Completion<Failure>) {
				lock.lock()
				completed = true
				let shouldComplete = buffer.isEmpty && !isScheduled
				lock.unlock()

				if shouldComplete {
					downstream?.receive(completion: completion)
					downstream = nil
				}
			}

			private func scheduleNext() {
				lock.lock()
				guard !isScheduled, downstreamDemand > .none, !buffer.isEmpty else {
					lock.unlock()
					return
				}
				isScheduled = true
				lock.unlock()

				scheduler.schedule(after: scheduler.now.advanced(by: interval)) { [weak self] in
					self?.scheduledFlush()
				}
			}

			private func scheduledFlush() {
				lock.lock()
				guard downstreamDemand > .none, !buffer.isEmpty else {
					isScheduled = false
					let shouldComplete = completed && buffer.isEmpty
					lock.unlock()
					if shouldComplete {
						downstream?.receive(completion: .finished)
						downstream = nil
					}
					return
				}

				let next = buffer.removeFirst()
				downstreamDemand -= 1
				lock.unlock()

				let additionalDemand = downstream?.receive(next) ?? .none

				lock.lock()
				downstreamDemand += additionalDemand
				isScheduled = false
				let shouldContinue = downstreamDemand > .none && !buffer.isEmpty
				lock.unlock()

				if shouldContinue {
					scheduleNext()
				} else if completed && buffer.isEmpty {
					downstream?.receive(completion: .finished)
					downstream = nil
				}
			}
		}
	}
}
