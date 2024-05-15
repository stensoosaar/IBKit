//
//  File.swift
//  
//
//  Created by Sten Soosaar on 29.10.2023.
//

import Foundation



public struct IBPortfolioValue: IBResponse, IBEvent {
	
	public let contract: IBContract
	public let position: Double
	public let marketPrice: Double
	public let marketValue: Double
	public let averageCost: Double
	public let unrealizedPNL: Double
	public let realizedPNL: Double
	public let accountName: String

	public init(from decoder: IBDecoder) throws {
		
		var container = try decoder.unkeyedContainer()
		let version = try container.decode(Int.self)
		
		contract = try container.decode(IBContract.self)
		position = try container.decode(Double.self)
		marketPrice = try container.decode(Double.self)
		marketValue = try container.decode(Double.self)
		
		averageCost = try container.decode(Double.self)
		unrealizedPNL = try container.decode(Double.self)
		realizedPNL = try container.decode(Double.self)

		accountName = try container.decode(String.self)
		
	}
	
}
