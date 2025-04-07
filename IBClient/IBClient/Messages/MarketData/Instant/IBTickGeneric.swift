//
//  IBTickGeneric.swift
//  IBKit
//
//  Created by Sten Soosaar on 01.04.2025.
//


struct TickGeneric: AnyTickEvent{
	public var type: IBTickType
	public var value: Double
}


extension TickGeneric: Decodable{
		
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		type = try container.decode(IBTickType.self)
		value = try container.decode(Double.self)
	}

}
