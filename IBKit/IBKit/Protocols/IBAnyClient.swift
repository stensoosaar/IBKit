//
//  File.swift
//  
//
//  Created by Sten Soosaar on 11.05.2024.
//

import Foundation
import Combine


public protocol IBAnyClient{
	
	var serverVersion: Int? {get set}
	
	func connect() throws
	
	func disconnect()
	
	func send(request: IBRequest) throws
	
	var eventFeed: AnyPublisher<IBEvent, Never> {get}
		
}


