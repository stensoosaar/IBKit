//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


public struct IBCommissionReport: IBResponse, IBEvent  {
	
	public var executionID: String
	public var commission: Double
	public var currency: String
	public var realizedPNL: Double?
	public var yield: Double?
	public var yieldRedemptionDate: Date?

	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		_ = try container.decode(Int.self)
		executionID = try container.decode(String.self)
		commission = try container.decode(Double.self)
		currency = try container.decode(String.self)
		realizedPNL = try container.decodeOptional(Double.self)
		yield = try container.decodeOptional(Double.self)
		yieldRedemptionDate = try container.decodeOptional(Date.self)
	}
	
}

