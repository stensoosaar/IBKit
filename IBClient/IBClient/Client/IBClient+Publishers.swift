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

	public func dataTaskPublisher(for request: IBRequest) -> AnyPublisher<IBEvent, Error> {
		Deferred {
			self.sendResultPublisher(request)
		}
		.flatMap { _ in
			self.eventFeed
				.filter { request.id == $0.id }
				.tryMap { response in
					switch response.result {
					case .success(let object):
						return object
					case .failure(let error):
						throw error
					}
				}
		}
		.eraseToAnyPublisher()
	}
	
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
		.eraseToAnyPublisher()

	}
	
	public func nextIDPublisher() -> AnyPublisher<IBNextRequestID, Error> {
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
						return typedObject
					case .failure(let error):
						throw error
					}
				}
		}
		.eraseToAnyPublisher()

	}
	
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
	
	
	
	
}
