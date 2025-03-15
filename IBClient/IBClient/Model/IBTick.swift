//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBTick: IBMarketData{
	
	public typealias ResultType = Double
	
	public var type: IBTickType
	public var value: ResultType
	public var date: Date

}
