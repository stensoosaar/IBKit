//
//  IBStore.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//


import Foundation
import Combine


extension Publisher {
	
	func withPrevious() -> AnyPublisher<(previous: Output?, current: Output), Failure> {
		   scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
			   .compactMap { $0 }
			   .eraseToAnyPublisher()
	}
	

	func asyncMap<T>(_ transform: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T?, Never>, Self> {
		flatMap { value in
			Future { promise in
				Task {
					let output = try? await transform(value)
					promise(.success(output))
				}
			}
		}
	}
	
	
	func tryAwaitMap<T>(_ transform: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Self> {
		flatMap { value in
			Future { promise in
				Task {
					do {
						let output = try await transform(value)
						promise(.success(output))
					} catch {
						promise(.failure(error))
					}
				}
			}
		}
	}
	
}

