//
//  File.swift
//  
//
//  Created by Sten Soosaar on 28.10.2023.
//

import Foundation


public struct IBWSHData: IBResponse, IBEvent {
	
	public var contractID: Int
	public var filter: String
	public var fillWatchlist: Bool
	public var fillPortfolio: Bool
	public var fillCompetitors: Bool
	public var startDate: Date
	public var endDate: Date
	public var totalLimit: Int
	
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		self.contractID = try container.decode(Int.self)
		self.filter = try container.decode(String.self)
		self.fillWatchlist = try container.decode(Bool.self)
		self.fillPortfolio = try container.decode(Bool.self)
		self.fillCompetitors = try container.decode(Bool.self)
		self.startDate = try container.decode(Date.self)
		self.endDate = try container.decode(Date.self)
		self.totalLimit = try container.decode(Int.self)
	}
	
}

