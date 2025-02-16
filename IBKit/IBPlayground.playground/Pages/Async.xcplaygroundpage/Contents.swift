//: [Previous](@previous)

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
import Foundation
import Combine
import IBKit


var cancelables: [AnyCancellable] = []

class Datasource: IBClient, IBRequestAsync{}

let client = Datasource(id:999, address:"https://127.0.0.1", port: 7496)
client.debugMode = false

do{
	try client.connect()
	usleep(10000)
} catch{
	print(error)
}

for ticker in ["BTC","ETH"]{
	
	Task {
		do {
			let requestID: Int = client.nextRequestID
			let contract = IBContract.crypto(ticker, currency: "USD")
			let source: IBBarSource = .midpoint
			
			for try await data in try client.subscribeRealTimeBar(requestID, contract: contract, barSource: source) {
				print("\(data)")
			}
		} catch{
			print(error)
		}
	}
	
	usleep(10000)
	
}



//: [Next](@next)
