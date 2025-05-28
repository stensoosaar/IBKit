//
//  Store.swift
//  IBKit
//
//  Created by Sten Soosaar on 24.05.2025.
//

import Foundation
import IBClient
import DuckDB

public final class Store {
	
	let database: Database
	let connection: Connection
	
	private init(database: Database, connection: Connection) {
		self.database = database
		self.connection = connection
	}
	
	public func validateUniverse() throws {
		let whitelist = try connection.query("SELECT * FROM universe;")
		print(whitelist)
	}
	
}


extension Store {
	
	public static func create(whitelist url: URL? = nil) throws -> Store {
		let database = try Database(store: .inMemory)
		let connection = try database.connect()
		
		#if SWIFT_PACKAGE
		guard let path = Bundle.module.url(forResource: "StoreSchema", withExtension: "sql"),
			  let schema = try? String(contentsOf: path) else {
			fatalError("no schama found")
		}
		#else
		fatalError("no schama found")
		#endif
		
		
		
		
		
		if let url = url {
			_ = try connection.execute("""
				CREATE TEMP TABLE IF NOT EXISTS imported_contracts AS 
				SELECT * FROM read_csv_auto('\(url.path())');
			""")
		}
		return Store(database: database, connection: connection)
	}
	
	public func addAccounts(identifiers: [String]){
		
		
	}
	
		
	
}
