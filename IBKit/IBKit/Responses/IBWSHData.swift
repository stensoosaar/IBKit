//
//  File.swift
//  
//
//  Created by Sten Soosaar on 28.10.2023.
//

import Foundation


public struct IBWSHData: IBResponse, IBEvent, Sendable{
	
	public let contractID: Int
	public let filter: String
	public let fillWatchlist: Bool
	public let fillPortfolio: Bool
	public let fillCompetitors: Bool
	public let startDate: Date
	public let endDate: Date
	public let totalLimit: Int
	
	
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

