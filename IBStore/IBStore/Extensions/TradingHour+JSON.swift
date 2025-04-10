//
//  TradingHour+JSON.swift
//  IBKit
//
//  Created by Sten Soosaar on 08.04.2025.
//

import Foundation
import IBClient




public extension Array where Element == IBTradingHour {
	
	func blaah() throws -> String? {
		
		let map = self.map({["open":$0.open.ISO8601Format(), "close":$0.close.ISO8601Format()]})
		
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted]
		let data = try encoder.encode(map)
		return String(data: data, encoding: .utf8)
	}
	
}

