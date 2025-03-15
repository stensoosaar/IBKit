//
//  File.swift
//  
//
//  Created by Sten Soosaar on 15.05.2024.
//

import Foundation


public protocol IBAnyMarketDepth: IBObject{
	
	var requestID: Int { get }
	var position: Int { get }
	var operation: IBOperation	{ get }
	var side: IBQuoteType	{ get }
	var price: Double { get }
	var size: Double { get }

}
