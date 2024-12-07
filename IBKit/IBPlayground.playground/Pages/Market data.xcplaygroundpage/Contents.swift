//: [Previous](@previous)

/*:
 # Market data
 IB provides near real time (usually updates every 0.25 seconds) and historical market data.
 While some free datafeeds exists, most of data needs to be subscribed for a fee. Market data subscriptions are done at a TWS user name level,
 not per account. The only exception to this rule are paper trading users, where client portal Manage Account -> Settings -> Paper Trading allows
 you to share market data between your live and papaer trading accounts.
 */
	import PlaygroundSupport
	PlaygroundPage.current.needsIndefiniteExecution = true
	import Foundation
	import Combine
	import IBKit

/*:
 ### Create a client and subscribe events

 If you run IB gateway in your local machine, the easiest way is to call ```IBClient.paper(id:)``` for paper trading or ```IBClient.live(id:)``` for live trading.
 Otherwise use standard initializer ```IBClient(id:address:port)```
 IBClient has three dedicated event feeds for market data, account data and system events.
 These data feeds are combine passthrough publishers, so they dont hold any values. Instead
 you create subscription and assign received events to event handlers...
*/
	let client = IBClient.paper(id: 999)
	client.debugMode = true
	
	var subscriptions: [AnyCancellable] = []

	client.eventFeed.sink (
		receiveCompletion: { completion in
			PlaygroundPage.current.finishExecution()
		}, receiveValue: { response in
			switch response{
			case let event as IBPriceHistory:
				event.prices.forEach({print($0)})
				print(String(repeating: "-", count: 30))
			case let event as IBPriceBarUpdate:
				print(event.bar)
			case let event as (any IBAnyMarketData):
				print(event)
			default:
				print(response)
			}
		}
	).store(in: &subscriptions)

/*:
 ### Connect the client.
 At the moment you should allow the client to establish the connection before sending api calls.
*/
	do {
		try client.connect()
		usleep(1_000_000)
	} catch {
		print(error.localizedDescription)
	}

/*:
 ### Request data
 - obtain next valid request identifier first
 - if using multiple securities / timeframes, you should store your request parameters with requestID
*/
	do {
		let requestID = client.nextRequestID
		let contract = IBContract.crypto("BTC", currency: "USD")
		let interval = try DateInterval.lookback(1, unit: .hour, until: .distantFuture)
		let size = IBBarSize.minute
		let request = IBPriceHistoryRequest(requestID: requestID, contract: contract, size: size, source: .trades, lookback: interval, extendedTrading: true, includeExpired: false)
		try client.send(request: request)
	} catch {
		print(error.localizedDescription)
	}

sleep(15)
client.disconnect()


//: [Next](@next)

