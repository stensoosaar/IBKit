//
//  File.swift
//  
//
//  Created by Sten Soosaar on 15.05.2024.
//

import Foundation


public protocol IBAnyMarketData: IBIndexedEvent {
	
	associatedtype ResultType: Any
	
	var requestID: Int 				{get}
	var type: IBTickType 			{get}
	var value: ResultType			{get}
	
}
