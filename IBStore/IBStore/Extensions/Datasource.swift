//
//  Datasource.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.03.2025.
//

import Foundation

public protocol AnyDatasource{}

public protocol AnyBroker{}

public protocol ConnectableBroker: AnyBroker{
	func connect() throws
	func disconnect()
}
