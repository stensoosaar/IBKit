//
//  AnyConnection.swift
//  IBKit
//
//  Created by Sten Soosaar on 10.04.2025.
//

import Foundation
import Combine


public enum ConnectionState: Equatable {
	case initializing
	case connecting(String)
	case hostReached
	case connectedToAPI
	case disconnecting
	case disconnected
}


public protocol AnyConnection: AnyObject {
	
	var requestSubject: PassthroughSubject<Data, Never> {get}
	
	var responseSubject: PassthroughSubject<Data, Error> {get}

	var state: CurrentValueSubject<ConnectionState,Never> {get}

	var connectionTime: String? {get}
	
	var serverVersion: Int? {get}
	
	var debugMode: Bool {get set}
	
	func connect()
	
	func disconnect()
	
	func send(data: Data)

}


extension AnyConnection {
	
	func start() {
		var greeting = Data()
		let prefix="API\0"
		if let contentData = prefix.data(using: .ascii, allowLossyConversion: false) {
			greeting += contentData
		}
	
		let versions = "v\(IBServerVersion.range.lowerBound)..\(IBServerVersion.range.upperBound)"
		greeting += versions.count.toBytes(size: 4)
		if let contentData = versions.data(using: .ascii, allowLossyConversion: false) {
			greeting += contentData
		}
		
		send(data: greeting)
	}
		
}
