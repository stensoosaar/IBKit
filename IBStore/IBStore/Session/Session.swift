//
//  Session.swift
//  IBKit
//
//  Created by Sten Soosaar on 24.05.2025.
//

import Foundation
import Combine
import IBClient
import TWS


public enum RunMode {
	case live(port: Int)
	case test(port: Int)
	case backtest(_ interval: DateInterval)
}


public protocol Session {}

public final class TradingSession: Session {
		
	var broker: Broker
	var store: Store
	
	public init(broker: Broker, store: Store) {
		self.broker = broker
		self.store = store
	}
	
	
	
	
	
}
