//
//  DataTaskResponse.swift
//  IBKit
//
//  Created by Sten Soosaar on 27.05.2025.
//


import Foundation
import TWS

/**
 delivers datatask response for bulk requests where the
 the response do not contain any request context.
 */

public struct DataTaskResponse<T: IdentifiableRequest> {
	public let request: T
	public let result: Result<IBEvent,Error>
}
