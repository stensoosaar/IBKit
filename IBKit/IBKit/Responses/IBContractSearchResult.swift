//
//  File.swift
//  
//
//  Created by Sten Soosaar on 21.10.2023.
//

import Foundation



public struct IBContractSearchResult: IBResponse, IBEvent {
	
	public struct Contract: IBDecodable {
		
        public let contractID: Int
        public let symbol: String
        public let type: IBSecuritiesType
        public let primaryExchange: String
        public let currency: String
        public var availableTypes: [IBSecuritiesType]
        public var description: String?
        public var issuerID: String?
		
		public init(from decoder: IBDecoder) throws {
			
			guard let serverVersion = decoder.serverVersion else {
				throw IBClientError.decodingError("Server value expected")
			}
			
			var container = try decoder.unkeyedContainer()
			self.contractID = try container.decode(Int.self)
			self.symbol = try container.decode(String.self)
			self.type = try container.decode(IBSecuritiesType.self)
			self.primaryExchange = try container.decode(String.self)
			self.currency = try container.decode(String.self)
			let derivateCount = try container.decode(Int.self)
			availableTypes = []
			for _ in 0..<derivateCount{
				let obj = try container.decode(IBSecuritiesType.self)
				availableTypes.append(obj)
			}
			
			if serverVersion > IBServerVersion.BOND_ISSUERID {
				self.description = try container.decode(String.self)
				self.issuerID = try container.decode(String.self)
			}
		}
	}
	
    public let requestId: Int
    public var values: [Contract] = []
	
	public init(from decoder: IBDecoder) throws {
		var container = try decoder.unkeyedContainer()
		requestId = try container.decode(Int.self)
		let resultCount = try container.decode(Int.self)
		for _ in 0..<resultCount {
			let object = try container.decode(Contract.self)
			values.append(object)
		}
	}
}
