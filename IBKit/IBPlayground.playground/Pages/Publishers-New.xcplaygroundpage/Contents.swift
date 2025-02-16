//: [Previous](@previous)

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
import Foundation
import Combine
import IBKit


var cancelables: [AnyCancellable] = []

class Datasource: IBClient, IBRequestPublisher{}

let client = Datasource(id:999, address:"https://127.0.0.1", port: 7496)
client.debugMode = true

do{
	try client.connect()
	usleep(10000)
} catch{
	print(error)
}

for ticker in ["BTC","ETH"]{
	
	let requestID: Int = client.nextRequestID
	let contract = IBContract.crypto(ticker, currency: "USD")
	
	try? client.subscribeRealTimeBar(requestID, contract: contract, barSource: .trades, extendedTrading: true)
		.sink { completion in
			print(completion)
		} receiveValue: { marketdata in
			print(marketdata)
		}
		.store(in: &cancelables)
	
	usleep(10000)
	
}



//: [Next](@next)
