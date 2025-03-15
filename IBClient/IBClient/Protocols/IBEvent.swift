//
//  IBEvent.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.03.2025.
//

import Foundation

public protocol IBEvent: Sendable {}

@available(*, deprecated, message: "")
public protocol IBIndexedEvent: IBEvent, Identifiable {
	var requestID: Int				{ get }
}
