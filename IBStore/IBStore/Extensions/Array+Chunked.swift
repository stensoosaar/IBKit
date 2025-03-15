//
//  Array=Chinked.swift
//  IBKit
//
//  Created by Sten Soosaar on 11.03.2025.
//


import Foundation

extension Array {
	func chunked(into size: Int) -> [[Element]] {
		return stride(from: 0, to: count, by: size).map {
			Array(self[$0 ..< Swift.min($0 + size, count)])
		}
	}
}
