//: [Previous](@previous)



import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
import Foundation
import Combine
import IBKit






@available(macOS 12, *)
public class SimulatedBroker{
	
	let client: IBClient
	
	public init(id: Int){
		client = IBClient.paper(id: id)
	}
	
	public func connect(){
		do {
			try client.connect()
		} catch {
			print(error.localizedDescription)
		}
	}
	
	public func marketDataPublisher(for contract: IBContract) throws -> AnyPublisher<IBTick,Never>{
		
		let index = client.nextRequestID
		try client.subscribeMarketData(index, contract: contract)
		
		return AnyPublisher(client.eventFeed
			.compactMap{$0 as? IBTick}
			.filter {$0.requestID == index}
			.eraseToAnyPublisher()
		)
		
	}

}



let broker = SimulatedBroker(id: 999)
broker.connect()

var subscriptions: [AnyCancellable] = []

try? broker.marketDataPublisher(for: IBContract.forex("EUR", currency: "USD"))
	.sink{ print($0) }
	.store(in: &subscriptions)

sleep(5)



//: [Next](@next)
