//
//  IBAccountStore.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.03.2025.
//

import Foundation
import DuckDB
import IBClient
import TabularData

//MARK: - Account Store
extension IBStore{

	@discardableResult
	public func upsertAccount(_ account: Account) throws {
		
		
	}
	
	public func fetchAccounts() throws -> [AccountSummary]{
		return []
	}
		
}
