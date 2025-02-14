//: [Previous](@previous)

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
import Foundation
import Combine
import IBKit


var cancelables: [AnyCancellable] = []

let client = IBClient.live(id: 999, type: .workstation)
client.debugMode = true

do{
	try client.connect()
} catch{
	print(error)
}

for ticker in ["AAPL","AMZN","MU","META","NVDA","NFLX","GOOGL","TSLA","ARM","BABA"]{
	
	let requestID: Int = client.nextRequestID
	let contract = IBContract.equity(ticker, currency: "USD")
	
	client.subscribePriceQuote(requestID, contract: contract, snapshot: false, regulatory: false)
		.sink { completion in
			print(completion)
		} receiveValue: { marketdata in
			print(marketdata)
		}
		.store(in: &cancelables)
	
	usleep(10000)
	
}



//: [Next](@next)
