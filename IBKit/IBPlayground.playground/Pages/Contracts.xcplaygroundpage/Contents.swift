import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
import Foundation
import Combine
import IBKit



/*:
## Spot
 Most spot contracts can be specified by underlying asset, currency and designation exchange.
 For non US stocks, traded in multiple markets, you can use SMART as designated exchange and primary exchange.
*/
		let forex = IBContract.forex("EUR", currency: "USD", exchange: .IDEALPRO)

		let aapl = IBContract.equity("AAPL", currency: "USD")

		let dax = IBContract.index("DAX", currency: "EUR", exchange: .EUREX)
		
		let cfd = IBContract.cfd("IBUS500", currency: "USD", exchange: .SMART)

		let gold = IBContract.commodity("XAUUSD", currency: "USD", exchange: .SMART)

		let magellianFund = IBContract.fund("FMAGX", currency: "USD", exchange: .FUNDSERV)

		let crypto = IBContract.crypto("ETH", currency: "USD", exchange: .PAXOS)

		let porsche = IBContract.equity("P911", currency: "EUR", exchange: .IBIS)
/*:
 Bonds can be specified by CUSIP or ISIN.
*/
		let aaplBond = IBContract.bond(.cusip("037833AT7"), currency: "USD", exchange: .SMART)


/*:
## Futures
A regular futures contract is commonly defined using underlying asset symbol, currency and expiration date or expiration year and month.
*/
		let miniSPX = IBContract.future("ES", currency: "USD", expiration: try! Date.futureExpiration(year: 2023, month: 12), exchange: .CME)

/*:
Another possibility is to use initializer with local symbol which defines product's undelying asset and expiration. The future contract local symbol consists of
- Asset symbol
- Month code: F - January, G - February, H - March, J - April, K - May, M - June, N - July, Q - August, U - September, V - October, X - November, Z - December
- Last digit of the expiration year
*/
		let microSPX = IBContract.future(localSymbol: "MESZ3", currency: "USD", exchange: .CME)

/*:
Occasionally, you can expect to have more than a single future contract for the same underlying with the same expiry. To rule out the ambiguity, the contract's multiplier can be given as shown below:
*/
		let daxFutures = IBContract.future("DAX", currency: "EUR", expiration: try! Date.futureExpiration(year: 2023, month: 3), size: 1.0, exchange: .EUREX)

/*:
## Options
Options, like futures, also require an expiration date plus a strike and a multiplier. It is not unusual to find many option contracts with an almost identical description (i.e. underlying symbol, strike, last trading date, multiplier, etc.). Adding more details such as the trading class will help.
*/
		let callTSLA = IBContract.call("TSLA", currency: "USD", expiration: try! Date.optionExpiration(year: 2024, month: 1, day: 19), strike: 200.0, size: 100, exchange: IBExchange.BOX)
/*:
The OCC options symbol can be used to define an option contract in the API through the option's 'local symbol' field. Please note the extra spaces in local symbol string.
*/
		let callAAPL = IBContract.option(localSymbol: "AAPL  240119C00150000", currency: "USD", exchange: .SMART)



let watchlist: [IBContract] = [
	//forex,
	aapl,
	//dax,
	//cfd,
	//gold,
	//magellianFund,
	//crypto,
	//porsche,
	//aaplBond,
	//miniSPX,
	//microSPX,
	//daxFutures,
	//callAAPL,
	//callTSLA
]


let client = IBClient.paper(id: 999)
client.connect()
var cancellables: [AnyCancellable] = []

client.eventFeed
	.compactMap({$0 as? IBContractDetails})
	.sink{print($0)}
	.store(in: &cancellables)

for contract in watchlist{
	let index = client.nextRequestID
	client.contractDetails(index, contract: contract)
}

client.disconnect()

//: [Next](@next)
