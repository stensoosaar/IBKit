//
//  IBCancelHeadTimestampRequest.swift
//  IBKit
//
//  Created by Sten Soosaar on 06.10.2024.
//



import Foundation


public struct IBCancelHeadTimestampRequest: IBIndexedRequest {
	
	public var type: IBRequestType = .cancelHeadTimestamp
	public var requestID: Int
	
	public init(requestID: Int) {
		self.requestID = requestID
	}
	
	public func encode(to encoder: IBEncoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(IBRequestType.cancelFundamentalData)
		try container.encode(requestID)
	}
}
