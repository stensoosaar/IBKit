//: [Previous](@previous)



import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
import Foundation
import Combine
import IBKit


// MARK: - CUSTOM MODEL

extension IBPriceBar{
	
	func convertToProperBar(with duration: TimeInterval) -> PriceBar {
		return PriceBar(
			date: self.date,
			duration: duration,
			open: self.open,
			high: self.high,
			low: self.low,
			close: self.close,
			volume: self.volume,
			wap: self.wap,
			count: self.count)
	}
	
	
}

struct PriceBar{
	var date: Date
	var duration: TimeInterval
	var open: Double
	var high: Double
	var low: Double
	var close: Double
	var volume: Double?
	var wap: Double?
	var count: Int?
	
	init(date: Date, duration: TimeInterval, open: Double, high: Double, low: Double, close: Double, volume: Double? = nil, wap: Double? = nil, count: Int? = nil) {
		self.date = date
		self.duration = duration
		self.open = open
		self.high = high
		self.low = low
		self.close = close
		self.volume = volume
		self.wap = wap
		self.count = count
	}
}

protocol AnyPriceUpdate{
	associatedtype PriceValue
	var contract: IBContract 		{ get }
	var resolution: TimeInterval	{ get }
	var prices: PriceValue			{ get }
}

struct PriceHistory: AnyPriceUpdate{
	typealias PriceValue = [PriceBar]
	var contract: IBContract
	var resolution: TimeInterval
	var prices: PriceValue
	
	init(contract: IBContract, resolution: TimeInterval, prices: PriceValue) {
		self.contract = contract
		self.resolution = resolution
		self.prices = prices
	}
}

struct PriceUpdate: AnyPriceUpdate{
	typealias PriceValue = PriceBar
	var contract: IBContract
	var resolution: TimeInterval
	var prices: PriceValue
	
	init(contract: IBContract, resolution: TimeInterval, prices: PriceValue) {
		self.contract = contract
		self.resolution = resolution
		self.prices = prices
	}
	
}

public class IBAccount: Equatable, Identifiable, Hashable{
	
	public let id: String
	
	// parameters here
	
	public init(id: String) {
		self.id = id
	}
	
	public func update(_ event: IBAccountUpdate){
		print(event)
	}
	
	public static func == (lhd: IBAccount, rhd: IBAccount) -> Bool {
		return lhd.id == rhd.id
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
}

public enum BrokerError: LocalizedError{
	case requestError(_ details: String)
	case somethingWentWrong(_ details: String)
}

struct QuoteEvent{
	
	var contract: IBContract
	var date: Date
	var type: IBTickType
	var value: Double
	
	public init(date: Date, contract: IBContract, type: IBTickType, value: Double) {
		self.date = date
		self.contract = contract
		self.type = type
		self.value = value
	}
	
}

public protocol IBAnyOrderEvent{}

extension IBOpenOrder: IBAnyOrderEvent{}
extension IBOrderStatus: IBAnyOrderEvent{}
extension IBOrderExecution: IBAnyOrderEvent{}


@available(macOS 14, *)
class SimulatedBroker {
	
	let api: IBClient
	
	var managedAccounts: Set<IBAccount> = []
	
	private var subscriptions: [AnyCancellable] = []
	
	init(id: Int){
		api = IBClient.paper(id: id)
		api.debugMode = false
	}
	
	func connect(){
		do {
			try api.connect()
			//subscribeAccountUpdates()
		} catch {
			print(error.localizedDescription)
		}
	}
	
	deinit{
		api.disconnect()
	}
	
	// TODO: - collect messages until IBAccountValueEnd message arrives and update then
	
	func subscribeAccountUpdates(){
		
		api.eventFeed.sink { completion in
			print(completion)
		} receiveValue: { accountEvent in
			switch accountEvent{
			case let event as IBManagedAccounts:
				let activeAccounts = event.identifiers.map{IBAccount(id: $0)}
				self.managedAccounts = Set(activeAccounts)
				event.identifiers.forEach({
					let request = IBAccountUpdateRequest(accountName: $0, subscribe: true)
					try? self.api.send(request: request)
				})
			case let event as IBAccountUpdate:
				self.managedAccounts.first(where: {$0.id == event.accountName})?.update(event)
			case let event as IBAccountUpdateEnd:
				break
			default:
				break
			}
		}
		.store(in: &subscriptions)
		
		
		
	}
	
	
	// publishes one time event
	// fails at noncritical ib error as it arrives before content
	func priceHistoryPublisher(_ interval: DateInterval, size: IBBarSize, contract: IBContract, extendedSession: Bool = false) throws -> Future<PriceHistory, BrokerError>{
		
		let requestID = api.nextRequestID
		let source: IBBarSource = [.cfd, .forex, .crypto].contains{$0 == contract.securitiesType} ? .midpoint : .trades
		let request = IBPriceHistoryRequest(requestID: requestID, contract: contract, size: size, source: source, lookback: interval, extendedTrading: extendedSession)
		try api.send(request: request)
		
		return Future { promise in
			self.subscriptions.append(
				self.api.eventFeed
					.setFailureType(to: BrokerError.self)
					.compactMap { $0 as? IBIndexedEvent }
					.filter { $0.requestID == requestID }
					.tryMap{ response -> PriceHistory in
						switch response {
						case let event as IBPriceHistory:
							let resolution = size.timeInterval
							let series:[PriceBar] = event.prices.map({$0.convertToProperBar(with: resolution)})
							return PriceHistory(contract: contract, resolution: resolution, prices: series)
						case let event as IBServerError:
							throw BrokerError.requestError(event.message)
						default:
							let message = "this should never happen but received anyway \(response)"
							throw BrokerError.somethingWentWrong(message)
						}
					}
					.mapError { $0 as! BrokerError }
					.sink { completion in
						switch completion {
						case .failure(let error):
							promise(.failure(error))
						case .finished:
							break
						}
					} receiveValue: { value in
						promise(.success(value))
					})
			
			}
		
	}
	
	
		
	/// publishes 5 sec bars
	/// - Parameters:
	/// - contract: security definition
	/// - extendedSession: include data from extended trading hours
	/// - Returns PriceHistory, PriceUpdate or BrokerError publisher
	func priceBarPublisher(for contract: IBContract, extendedSession: Bool = false) throws -> AnyPublisher<any AnyPriceUpdate, BrokerError>{
		
		let requestID = api.nextRequestID
		let source: IBBarSource = [.cfd, .forex, .crypto].contains{$0 == contract.securitiesType} ? .midpoint : .trades
		let request = IBRealTimeBarRequest(requestID: requestID, contract: contract, source: source, extendedTrading: extendedSession)
		try api.send(request: request)
			
		return AnyPublisher( api.eventFeed
			.setFailureType(to: BrokerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap { response -> (any AnyPriceUpdate) in
					
				switch response {
				case let event as IBPriceBarUpdate:
					let result: PriceBar = event.bar.convertToProperBar(with: 5)
					return PriceUpdate(contract: contract, resolution: 5, prices: result)
				case let event as IBServerError:
					throw BrokerError.requestError(event.message)
				default:
					let message = "thsi should never happen but received anyway \(response)"
					throw BrokerError.somethingWentWrong(message)
				}
					
			}
			.mapError { $0 as! BrokerError }
			.eraseToAnyPublisher()
		)
					
	}
	
	
	/// publishes live bid, ask, last snapshorts taken every 250ms of requested contract
	/// - Parameters:
	/// - contract: security description
	/// - extendedSession: include data from extended trading hours
	func quotePublisher(for contract: IBContract, extendedSession: Bool = true) throws -> AnyPublisher<QuoteEvent, BrokerError> {
		
		let requestID = api.nextRequestID
		let request = IBMarketDataRequest(requestID: requestID, contract: contract)
		try api.send(request: request)
		
		return AnyPublisher( api.eventFeed
			.setFailureType(to: BrokerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap { response -> QuoteEvent in
						
				switch response {
				case let event as IBTick:
					return QuoteEvent(date: event.date, contract: contract, type: event.type, value: event.value)
				case let event as IBServerError:
					throw BrokerError.requestError(event.message)
				default:
					let message = "thsi should never happen but received anyway \(response)"
					throw BrokerError.somethingWentWrong(message)
				}
						
			}
			.mapError { $0 as! BrokerError }
			.eraseToAnyPublisher()
		)
		
	}
	
	/// Returns detailed description of contract
	/// - Parameter contract: security description
	func validateContract(_ contract: IBContract) throws -> Future<IBContractDetails, BrokerError>{
		
		let requestID = api.nextRequestID
		let request = IBContractDetailsRequest(requestID: requestID, contract: contract)
		try api.send(request: request)
		
		return Future { promise in
			self.subscriptions.append(
				self.api.eventFeed
					.setFailureType(to: BrokerError.self)
					.compactMap { $0 as? IBIndexedEvent }
					.filter { $0.requestID == requestID }
					.tryMap{ response -> IBContractDetails in
						switch response {
						case let event as IBContractDetails:
							return event
						case let event as IBServerError:
							throw BrokerError.requestError(event.message)
						default:
							let message = "this should never happen but received anyway \(response)"
							throw BrokerError.somethingWentWrong(message)
						}
					}
					.mapError { $0 as! BrokerError }
					.sink { completion in
						switch completion {
						case .failure(let error):
							promise(.failure(error))
						case .finished:
							break
						}
					} receiveValue: { value in
						promise(.success(value))
					}
			)
			
		}
	}
	
	
	/// sends order to broker
	func placeOrder(_ order: IBOrder) throws -> AnyPublisher<IBAnyOrderEvent, BrokerError> {
		let requestID = broker.api.nextRequestID
		try api.placeOrder(requestID, order: order)
		
		return AnyPublisher( api.eventFeed
			.setFailureType(to: BrokerError.self)
			.compactMap { $0 as? IBIndexedEvent }
			.filter { $0.requestID == requestID }
			.tryMap { response -> IBAnyOrderEvent in
						
				switch response {
				case let event as IBAnyOrderEvent:
					return event
				case let event as IBServerError:
					throw BrokerError.requestError(event.message)
				default:
					let message = "thsi should never happen but received anyway \(response)"
					throw BrokerError.somethingWentWrong(message)
				}
				
			}
			.mapError { $0 as! BrokerError }
			.eraseToAnyPublisher()
		)
				
	}
	
	
}





let broker = SimulatedBroker(id: 999)
var subscriptions: [AnyCancellable] = []
broker.connect()
usleep(1_000_000)

let contract = IBContract.equity("AAPL", currency: "USD")

try broker.validateContract(contract)
   .sink { completion in
	   print(completion)
   } receiveValue: { response in
	   print(response)
   }
   .store(in: &subscriptions)


do {
	try broker.quotePublisher(for: contract)
		.sink { completion in
			print(completion)
		} receiveValue: { response in
			print(response.contract.symbol, response.date, response.type, response.value)
		}
		.store(in: &subscriptions)

} catch {
	print(error)
}


let interval = DateInterval.lookback(1, unit: .day, until: Date.distantFuture)
try broker.priceHistoryPublisher(interval, size: IBBarSize.hour, contract: contract)
	.sink { completion in
		print(completion)
	} receiveValue: { response in
		print(response)
	}
	.store(in: &subscriptions)


try broker.priceBarPublisher(for: contract)
	.sink { completion in
		print(completion)
	} receiveValue: { response in
		print(response.contract.symbol, response.prices)
	}
	.store(in: &subscriptions)





//: [Next](@next)
