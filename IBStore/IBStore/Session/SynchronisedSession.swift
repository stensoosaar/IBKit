//
//  SynchronisedSession.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.03.2025.
//

import Foundation
import IBClient


public class SynchronisedSession: Session {
	
	let store: IBStore

	init(store: IBStore, broker: Broker) {
		self.store = store
		super.init(broker: broker)
	}
	
	
	
}
