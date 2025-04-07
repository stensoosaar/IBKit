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
import IBClient



open class Watchlist {
	
	public typealias StoreBlock = (Store) throws -> [IBContract]

	private var cancellable: Cancellable?

	public enum WatchlistType {
		case manual, schedulled
	}
	
	public var dataNeed: DataItem?
		
	public var type: WatchlistType = .manual
	
	public var schedule: Schedule?
	
	public var nextDate: Date?
	
	private var storedBlock: StoreBlock?
	
	public var components = CurrentValueSubject<[IBContract],Never>([])
	
	public init(){}
	
	public func selectComponents(_ block: @escaping StoreBlock) {
		storedBlock = block
	}
	
	func makeWatchlist(store: Store) {
		if let block = storedBlock {
			do {
				let result = try block(store)
				components.send(result)
			} catch {
				print("Error executing the block: \(error)")
			}
		}
	}
	
	public struct Changes{
		public let added: [IBContract]
		public let removed: [IBContract]
	}
	
	func watchlistChangesPublisher() -> AnyPublisher<Watchlist.Changes,Never> {
		components.withPrevious()
			.compactMap { (oldList, newList) -> Watchlist.Changes? in
				guard let oldList = oldList else {
					return newList.isEmpty ? nil : Watchlist.Changes(added: newList, removed: [])
				}
				let oldSet = Set(oldList)
				let newSet = Set(newList)
				let addedContracts = Array(newSet.subtracting(oldSet))
				let removedContracts = Array(oldSet.subtracting(newSet))
				return Watchlist.Changes(added: addedContracts, removed: removedContracts)
			}
			.eraseToAnyPublisher()
	}
	

}
