//
//  IBNewsRequest.swift
//  IBKit
//
//  Created by Mike Holman on 07/12/2024.
//

import Foundation

public struct IBHistoricalNewsRequest: IBIndexedRequest, Hashable {
    
    public var requestID: Int
    public var type: IBRequestType = .historicalNews
    public var contract: IBContract
    public var providerCodes: String
    public var startDateTime: String
    public var endDateTime: String
    public var totalResults: Int
    public var historicalNewsOptions: [String]
    
    public init(
        requestID: Int,
        contract: IBContract,
        providerCodes: String,
        startDateTime: String,
        endDateTime: String,
        totalResults: Int
    ) {
        type = .historicalNews
        self.requestID = requestID
        self.contract = contract
        self.providerCodes = providerCodes
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.totalResults = totalResults
        self.historicalNewsOptions = []
    }
    
    public func encode(to encoder: IBEncoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(type)
        try container.encode(requestID)
        try container.encode(contract.id)
        try container.encode(providerCodes)
        try container.encode(startDateTime)
        try container.encode(endDateTime)
        try container.encode(totalResults)
		encoder.wrapNil()
    }
}
