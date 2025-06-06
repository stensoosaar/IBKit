import Foundation
import IBClient
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

var client = IBClient.init(id: 99, port:4002)
client.connect()

let c = client.nextIdPublisher()
	.receive(on: DispatchQueue.main)
	.sink{ print("next id is \($0)") }






client.disconnect()
