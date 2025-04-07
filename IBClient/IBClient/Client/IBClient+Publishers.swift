//
//  IBClient+Publishers.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.03.2025.
//

import Foundation
import Combine


extension IBClient {
	
	private func sendResultPublisher(_ request: IBRequest) -> AnyPublisher<Void, Error> {
		Result { try self.send(request) }
			.publisher
			.eraseToAnyPublisher()
	}
	
	/// creates new data task and returns publisher
	public func dataTaskPublisher<T: IBRequest & Identifiable>(
		for request: T
	) -> AnyPublisher<IBEvent, Error> {
		
		Deferred {
			self.sendResultPublisher(request)
		}
		.flatMap { _ in
			self.eventFeed
				.filter { $0.id != nil }
				.filter {
					guard let responseID = $0.id as? T.ID else { return false }
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
		}
		.handleEvents(receiveSubscription: {_ in
			print("\(Date())\tREQUESTING \(request.type) \(request.id)")
		}, receiveCancel: {
			if let cancellable = request as? IBCancellableRequest{
				_ = self.sendResultPublisher(cancellable.cancel)
			}
			print("\(Date())\tCANCELLED \(request.id)")
		})
		.eraseToAnyPublisher()
	}
	
}

extension IBClient {
	
	
	// subscribe tws bulletins
	public func bulletinPublisher() -> AnyPublisher<IBBulletin, Error> {
		Deferred {
			self.sendResultPublisher(IBBulletinBoardRequest())
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({$0.type == .NEWS_BULLETINS})
				.tryMap { response in
					switch response.result {
					case .success(let object):
						guard let typedObject = object as? IBBulletin else {
							throw IBError.invalidValue("")
						}
						return typedObject
					case .failure(let error):
						throw error
					}
				}
		}
		.handleEvents(receiveSubscription: {_ in 
			print("REQUESTING BULLETINS")
		}, receiveCancel: {
			print("CANCELLING BULLETINS")
			_ = self.sendResultPublisher(IBCancelBulletins())
		})
		.eraseToAnyPublisher()
	}
	
	
	public func nextIDPublisher() -> AnyPublisher<Int, Error> {
		Deferred {
			self.sendResultPublisher(IBNextIDRequest())
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({$0.type == .NEXT_VALID_ID})
				.first()
				.tryMap { response in
					switch response.result {
					case .success(let object):
						guard let typedObject = object as? IBNextRequestID else {
							throw IBError.invalidValue("")
						}
						return typedObject.value
					case .failure(let error):
						throw error
					}
				}
		}
		.eraseToAnyPublisher()

	}
	
	
	public func serverTimePublisher() -> AnyPublisher<Date, Error> {
		Deferred {
			self.sendResultPublisher(IBServerTimeRequest())
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({$0.type == .CURRENT_TIME})
				.first()
				.tryMap { response in
					switch response.result {
					case .success(let object):
						guard let typedObject = object as? IBServerTime else {
							throw IBError.invalidValue("")
						}
						return typedObject.date
					case .failure(let error):
						throw error
					}
				}
		}
		.eraseToAnyPublisher()

	}

	
	// Returns a list of scanner parameters
	public func scannerParameters() -> AnyPublisher<IBScannerParameters, Error> {
		Deferred {
			self.sendResultPublisher(IBScannerParametersRequest())
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({$0.type == .SCANNER_PARAMETERS})
				.first()
				.tryMap { response in
					switch response.result {
					case .success(let object):
						guard let typedObject = object as? IBScannerParameters else {
							throw IBError.invalidValue("")
						}
						return typedObject
					case .failure(let error):
						throw error
					}
				}
		}
		.eraseToAnyPublisher()

	}
	
	
	/// creates a subscription for position updates from multiple accounts
	/// returns position size or position end event
	public func positionsPublisher() -> AnyPublisher<IBEvent, Error> {
		Deferred {
			self.sendResultPublisher(IBPositionRequest())
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({[IBResponseType.POSITION_SIZE, IBResponseType.POSITION_SIZE_END].contains($0.type)})
				.tryMap { response in
					switch response.result {
					case .success(let object):
						if let object = object as? IBPositionSize {
							return object
						} else if let object = object as? IBPositionSizeEnd {
							return object
						} else {
							throw IBError.invalidValue("")
						}
					case .failure(let error):
						throw error
					}
				}
		}
		.handleEvents(receiveCancel: {
			print(IBPositionRequest().cancel)
		})
		.eraseToAnyPublisher()
	}
	
	
	/// Subscribes account's information.
	/// After the initial callback to IBAccountUpdate, callbacks only occur for values which have changed.
	/// This occurs at the time of a position change, or every (fixed) 3 minutes at most.
	/// Valid for one managed account. For multiple accounts use IBAccuntupdatesMulti
	/// - Parameter accountName: account name
	public func accountUpdatePublisher(_ accountName: String) -> AnyPublisher<IBEvent, Error> {
		
		//let request =
		
		Deferred {
			self.sendResultPublisher(IBAccountUpdateRequest(accountName: accountName))
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({[IBResponseType.PORTFOLIO_VALUE, IBResponseType.ACCT_VALUE, IBResponseType.ACCT_UPDATE_TIME].contains($0.type)})
				.tryMap { response -> IBEvent in
					switch response.result {
					case .success(let object):
						if let object = object as? IBAccountUpdate {
							return object
						} else if let object = object as? IBPositionUpdate {
							return object
						} else if let object = object as? IBAccountUpdateTime {
							return object
						} else {
							throw IBError.invalidValue("")
						}
					case .failure(let error):
						throw error
					}
				}
		}
		.handleEvents(receiveCancel: {
			let r = IBAccountUpdateRequest(accountName: accountName)
			_ = self.sendResultPublisher(r.cancel)
		})
		.eraseToAnyPublisher()
	}
	
	
	public func completedOrdersPublisher(apiOnly:Bool = true)->AnyPublisher<IBEvent, Error>{
		Deferred {
			self.sendResultPublisher(IBCompletedOrdersRequest(apiOnly: apiOnly))
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({[IBResponseType.COMPLETED_ORDER, IBResponseType.COMPLETED_ORDERS_END].contains($0.type)})
				.tryMap { response in
					switch response.result {
					case .success(let object):
						if let object = object as? IBOrderCompletion {
							return object
						} else if let object = object as? IBOrderCompletionEnd {
							return object
						} else {
							throw IBError.invalidValue("")
						}
					case .failure(let error):
						throw error
					}
				}
		}.eraseToAnyPublisher()
	}
	
	
	public func managedAccountsPublisher() -> AnyPublisher<[String], Error> {
		Deferred {
			self.sendResultPublisher(IBManagedAccountsRequest())
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({$0.type == .MANAGED_ACCTS})
				.first()
				.tryMap { response in
					switch response.result {
					case .success(let object):
						guard let typedObject = object as? IBManagedAccounts else {
							throw IBError.invalidValue("")
						}
						return typedObject.identifiers
					case .failure(let error):
						throw error
					}
				}
		}
		.eraseToAnyPublisher()

	}
	
	
	public func openOrdersPublisher() -> AnyPublisher<IBEvent, Error> {
		Deferred {
			self.sendResultPublisher(IBOpenOrderRequest.all())
		}
		.flatMap{ _ in
			self.eventFeed
				.filter({[IBResponseType.OPEN_ORDER, IBResponseType.OPEN_ORDER_END, IBResponseType.ORDER_STATUS].contains($0.type)})
				.tryMap { response in
					switch response.result {
					case .success(let object):
						if let object = object as? IBOpenOrder {
							return object
						} else if let object = object as? IBOrderStatus {
							return object
						} else if let object = object as? IBOpenOrderEnd {
							return object
						} else {
							throw IBError.invalidValue("")
						}
					case .failure(let error):
						throw error
					}
				}
		}
		.eraseToAnyPublisher()
		
	}
	
}


extension IBClient {
	
	public func setMarketDataType(_ type: IBMarketDataType) throws {
		try self.send(IBMarketDataTypeRequest(type))
	}
	
}
