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
	
}
