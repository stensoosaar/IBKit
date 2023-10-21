//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation


/*
Optional("59\01\00000e1a7.634cfd14.01.01\00.57\0USD\01.7976931348623157E308\01.7976931348623157E308\0\0")
Optional("59\01\00000e0d5.63cefb1e.01.01\01.010177\0USD\01.7976931348623157E308\01.7976931348623157E308\0\0")
*/

public struct IBCommissionReport: IBEvent, Decodable  {
	
	public var executionID: String
	public var commission: Double
	public var currency: String
	public var realizedPNL: Double?
	public var yield: Double?
	public var yieldRedemptionDate: Date?

	public init(from decoder: Decoder) throws {
		(decoder as? IBDecoder)?.dateFormatter.dateFormat = "yyyyMMdd"
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

