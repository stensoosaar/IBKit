//
//  Feature.swift
//  IBKit
//
//  Created by Sten Soosaar on 07.04.2025.
//


import Foundation
import IBClient
import TabularData


public struct Feature {
	public var contract: IBContract
	public var resolution: TimeInterval
	public var dataframe: DataFrame
	
	public init(contract: IBContract, resolution: TimeInterval, dataframe: DataFrame) {
		self.contract = contract
		self.resolution = resolution
		self.dataframe = dataframe
	}
}

