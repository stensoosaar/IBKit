//
//  AnyClient.swift
//  IBKit
//
//  Created by Sten Soosaar on 10.04.2025.
//

import Foundation
import Combine


public protocol AnyClient {
	
	var id: Int {get}
	var eventFeed: AnyPublisher<IBResponse, Error> {get}
	var nextRequestID: Int {get}
	var connection: AnyConnection {get}

	func connect() throws
	func disconnect()
	
	func send(_ request: IBRequest) throws
	
}

extension AnyClient {
	
	func startAPI() throws {
		let version: Int = 2
		let encoder = IBEncoder()
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.startAPI)
		try container.encode(version)
		try container.encode(id)
		try container.encode("")
		let dataWithLength = encoder.data.count.toBytes(size: 4) + encoder.data
		connection.send(data: dataWithLength)
	}
	
}
