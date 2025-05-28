/*
 MIT License

 Copyright (c) 2016-2025 Sten Soosaar

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


import Foundation
import Combine
import TWS


public extension IBClient{
	
	/**
	Sends an `IBRequest` and returns a publisher that emits matching `IBEvent` responses.
	
	This method sends the given request on subscription and listens for matching events.
	Only events with matching the request’s ID will be processed. If the event contains a
	successful result, it is emitted to subscribers; otherwise, the error is thrown.
	 
	## Usage Example
	
	```swift
	let request = MatchingSymbolsRequest(id: 1, nameOrSymbol: "AAPL")
	let subscription = broker.dataTaskPublisher(for: request)
		.receive(on: DispatchQueue.main)
	    .sink(
	        receiveCompletion: { completion in
	            switch completion {
	            case .finished:
	                print("Request completed successfully")
	            case .failure(let error):
	                print("Request failed: \(error)")
	            }
	        },
	        receiveValue: { event in
				print("Received response: \(event)")
			}
		)
	```
	
	- note: Request cancellation (if supported) is triggered when the subscription is cancelled.
	
	- parameter request: A request conforming to `IBRequest` and `Identifiable`.
	- returns: A publisher that emits `IBEvent` objects matching the request ID or fails with an error.
	 */
	
	func dataTaskPublisher<T: IdentifiableRequest>(for request: T) -> AnyPublisher<IBEvent, Error> {
		
		return self.responses
			.filter {
				guard let responseID = $0.requestId else { return false }
				return request.id == responseID
			}
			.tryMap { response in
				switch response.result {
				case .success(let object):
					return object
				case .failure(let error):
					throw error
				}
			}
			.handleEvents(
				receiveSubscription: { _ in
					print("\(Date())\tREQUESTING \(request.type) \(request.id)")
					self.sendRequest(request)
				},
				receiveCancel: {
					if let cancellable = request as? AnyCancellableRequest {
						self.sendRequest(cancellable.cancel)
					}
					print("\(Date())\tCANCELLED \(request.id)")
				}
			)
			.eraseToAnyPublisher()
	}
	
	

	
	
	/**
	 PositionSize + PositionSizeEnd
	 Publishes position size's for all managed accounts
	 */
	func positionSizePublisher() -> AnyPublisher<PositionSize, Error>{
		let request = PositionSizeRequest()
		return self.responses
			.filter { $0.type == .positionSize }
			.tryMap { try $0.get() }
			.compactMap{ $0 as? PositionSize }
			.handleEvents(
				receiveSubscription: { _ in
					print("\(Date())\tREQUESTING \(request.type)")
					self.sendRequest(request)
				},
				receiveCancel: {
					self.sendRequest(request.cancel)
					print("\(Date())\tCANCELLED \(request)")
				}
			)
			.eraseToAnyPublisher()
	}
	
	
	/**
	 */
	func bulletinPublisher(includePast: Bool = true) -> AnyPublisher<NewsBulletin, Error> {
		let request = NewsBulletinsRequest(includePast: includePast)
		return self.responses
			.filter({$0.type == .newsBulletins})
			.tryMap { try $0.get() }
			.compactMap{ $0 as? NewsBulletin }
			.handleEvents(
				receiveSubscription: {_ in
					print("\(Date())\tREQUESTING \(request.type)")
					self.sendRequest(request)
				}, receiveCancel: {
					print("\(Date())\tCANCELLED \(request)")
					self.sendRequest(request.cancel)
				}
			)
			.eraseToAnyPublisher()
	}
	
	
	/**
	 Requests accounts available for current trading session
	 - returns: managed account or error
	 */
	func requestManagedAccounts() -> AnyPublisher<ManagedAccounts, Error> {
		let request = ManagedAccountsRequest()
		return self.responses
			.first(where: {$0.type == .managedAccounts} )
			.tryMap { try $0.get() }
			.compactMap{ $0 as? ManagedAccounts }
			.handleEvents(
				receiveSubscription: {_ in
					print("\(Date())\tREQUESTING \(request.type)")
					self.sendRequest(request)
				}
			)
			.eraseToAnyPublisher()
	}
	
	
	/**
	 Creates a continuous stream of server-synchronized time updates.
	
	 Fetches the current time from the server and then provides regular time updates
	 using a local timer synchronized to the server timestamp. This approach maintains
	 accuracy while minimizing server requests.
	
	 - Parameter interval: The time interval between updates in seconds
	 - Returns: A publisher that emits `Date` objects at the specified interval, synchronized with server time
	
	 ## Usage
	 ```swift
	 let timeStream = serverTimeStream(interval: 1.0)
	     .sink(receiveCompletion: { completion in
	         // Handle completion or errors
	     }, receiveValue: { date in
	         print("Current time: \(date)")
	     })
	 ```
	
	 ## Behavior
	 - Sends an initial server time request
	 - Emits the server timestamp immediately upon receipt
	 - Starts a local timer that calculates accurate time progression
	 - Automatically handles timer cleanup on cancellation or completion
	 - Maintains accuracy by calculating elapsed time rather than accumulating intervals
	 */
	func serverTimePublisher(interval: TimeInterval = 1.0) -> AnyPublisher<Date, Error> {

		let request = ServerTimeRequest()
		let timerSubject = PassthroughSubject<Date, Never>()
		
		let timerQueue = DispatchQueue(label: "timer.queue", qos: .userInitiated)
		var timerCancellable: Cancellable?
		
		let serverTimePublisher = self.responses
			.filter { $0.type == .currentTime }
			.tryMap { try $0.get() }
			.compactMap { $0 as? ServerTime }
			.map { $0.time }
			.handleEvents(receiveSubscription: { _ in
				print("\(Date())\tREQUESTING \(request.type)")
				self.sendRequest(request)
			})
			.share()

		return serverTimePublisher
			.handleEvents(
				receiveOutput: { serverDate in
					timerQueue.async {
						// Send the initial server time
						timerSubject.send(serverDate)
						
						// Cancel previous timer
						timerCancellable?.cancel()
						
						// Start a new timer with more accurate time calculation
						let serverTimestamp = serverDate
						let startTime = Date()
						
						timerCancellable = Timer
							.publish(every: interval, on: .main, in: .default)
							.autoconnect()
							.map { _ -> Date in
								let elapsed = Date().timeIntervalSince(startTime)
								let intervals = floor(elapsed / interval)
								return serverTimestamp.addingTimeInterval((intervals + 1) * interval)
							}
							.sink(receiveValue: { calculatedDate in
								timerSubject.send(calculatedDate)
							})
					}
				},
				receiveCompletion: { _ in
					// Clean up timer when stream completes
					timerQueue.async {
						timerCancellable?.cancel()
						timerCancellable = nil
					}
				},
				receiveCancel: {
					// Clean up timer when stream is cancelled
					timerQueue.async {
						timerCancellable?.cancel()
						timerCancellable = nil
					}
				}
			)
			.flatMap { _ in
				timerSubject.setFailureType(to: Error.self)
			}
			.eraseToAnyPublisher()
	}

	
	/**
	 Requests account and position updates.
	 
	 Initially all data is delivered, then only updated key-values every 3 minutes (fixed interval from IB).
	 Only one account can be subscribed at time, otherwise the previous subscription is cancelled.
		
	 - note: If there is  more than one managed account, use `AccountUpdatesMultiRequest` for balances,
	 `AccountPNLRequest` for real time account updates, `PositionSizeMultiRequest` and `PositionPNLRequest`
	 for finer control over account updates.
	 
	 - returns: `AccountUpdate` `AccountUpdateTime` and `PositionUpdate` messages or failure
	 - parameter accountName: account id to be subscribed
	 */
	func accountUpdatePublisher(accountName: String) -> AnyPublisher<AnyAccountUpdate, Error> {
		
		let request = AccountUpdatesRequest(accountName: accountName)
		let expectedTypes:[ResponseType] = [.accountValue, .positionUpdate, .accountUpdateTime]
		
		return self.responses
			.filter { expectedTypes.contains($0.type) }
			.tryMap { try $0.get() }
			.compactMap{$0 as? AnyAccountUpdate}
			.handleEvents(
				receiveSubscription: { _ in
					print("\(Date())\tREQUESTING \(request.type)")
					self.sendRequest(request)
				},
				receiveCancel: {
					self.sendRequest(request.cancel)
					print("\(Date())\tCANCELLED \(request)")
				}
			)
			.eraseToAnyPublisher()
	}
	
	
	
	// AccountUpdates + PositionUpdate + AccountUpdateTime + AccountUpdateEnd
	// NextRequestID

	// ReceiveFA
	// ScannerParameters
	
	// OpenOrder
	// OpenOrderEnd
	// CommissionReport
	// CompletedOrder + CompletedOrdersEnd
	
	// MarketDepthExchanges
	
}
