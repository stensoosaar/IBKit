//
//  Publishers.swift
//  IBKit
//
//  https://stackoverflow.com/questions/72792881/swift-combine-mergemany-publishers#75804544
//

import Foundation
import Combine


extension Publishers {
	
	static func concatenateMany<Output, Failure>(_ publishers: [AnyPublisher<Output, Failure>]) -> AnyPublisher<Output, Failure> {
		return publishers.reduce(Empty().eraseToAnyPublisher()) { acc, elem in
			Publishers.Concatenate(prefix: acc, suffix: elem).eraseToAnyPublisher()
		}
	}

	public static func mergeMany<Output, Failure>(_ publishers: [AnyPublisher<Output, Failure>], maxConcurrent: Int) -> AnyPublisher<Output, Failure> {
		return Publishers.concatenateMany(
			publishers.chunked(into: maxConcurrent)
				.map { Publishers.MergeMany($0).eraseToAnyPublisher() }
		)
	}

	
}
