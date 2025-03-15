//
//  Store.swift
//  IBKit
//
//  Created by Sten Soosaar on 11.03.2025.
//

import Foundation
import DuckDB
import IBClient
import TabularData


public class IBStore {
	
	let database: Database
	
	let connection: Connection
	
	private init(database: Database, connection: Connection) {
		self.database = database
		self.connection = connection
	}
	
	public static func create(_ url: URL? = nil) throws -> IBStore {
		let storeType: Database.Store = url == nil ? .inMemory : .file(at: url!)
		let database = try Database(store: .inMemory)
		let connection = try database.connect()
		_ = try connection.execute(self.schema)
		return IBStore(database: database, connection: connection)
	}
		
}
