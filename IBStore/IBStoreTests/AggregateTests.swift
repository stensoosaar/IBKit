//
//  AggregateTests.swift
//  IBKit
//
//  Created by Sten Soosaar on 21.03.2025.
//

import XCTest
@testable import IBStore
@testable import IBClient
import Combine

class QupteToBarAggregationTests: XCTestCase {
	
    func testAggregation() {
		let quotes: [IBQuote] = [
			IBQuote(type: .trade, price: 100, size: 10, date: Date(timeIntervalSince1970: 0)),
			IBQuote(type: .trade, price: 99, size: 10, date: Date(timeIntervalSince1970: 20)),
			IBQuote(type: .trade, price: 101, size: 5, date: Date(timeIntervalSince1970: 40)),
			IBQuote(type: .trade, price: 103.50, size: 5, date: Date(timeIntervalSince1970: 55)),
            IBQuote(type: .trade, price: 104, size: 20, date: Date(timeIntervalSince1970: 60)),
			IBQuote(type: .trade, price: 102, size: 15, date: Date(timeIntervalSince1970: 80)),
			IBQuote(type: .trade, price: 102, size: 15, date: Date(timeIntervalSince1970: 100)),
			IBQuote(type: .trade, price: 102.5, size: 15, date: Date(timeIntervalSince1970: 110)),
			IBQuote(type: .trade, price: 102, size: 15, date: Date(timeIntervalSince1970: 120)),
			IBQuote(type: .trade, price: 101, size: 15, date: Date(timeIntervalSince1970: 130)),
			IBQuote(type: .trade, price: 100, size: 15, date: Date(timeIntervalSince1970: 140)),
			IBQuote(type: .trade, price: 101, size: 15, date: Date(timeIntervalSince1970: 150)),
			IBQuote(type: .trade, price: 102, size: 15, date: Date(timeIntervalSince1970: 160)),
			IBQuote(type: .trade, price: 103.90, size: 15, date: Date(timeIntervalSince1970: 170))
        ]
        
        let expectation = XCTestExpectation(description: "Receive aggregated price bars")
        
		var receivedBars: [AnyBar] = []
		
		quotes.publisher
			.aggregate(into: 60, quoteType: .trade)
            .sink { bar in
				print(bar)
				receivedBars.append(bar)
				if receivedBars.count == 2 {
                    expectation.fulfill()
                }
            }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedBars.count, 3)
		XCTAssertEqual(receivedBars[0].open, 100)
		XCTAssertEqual(receivedBars[0].high, 103.50)
		XCTAssertEqual(receivedBars[0].low, 99)
        XCTAssertEqual(receivedBars[0].close, 103.50)
        XCTAssertEqual(receivedBars[0].volume, 30)
    }
	
}
