//
//  QuoteSummary.swift
//  IBKit
//
//  Created by Sten Soosaar on 11.03.2025.
//



import Foundation
import IBClient
import DuckDB

public struct QuoteSummary {
	var bid_price: Double?
	var bid_size: Double?
	var ask_price: Double?
	var ask_size: Double?
	var last_price: Double?
	var last_size: Double?
	var last_timestamp: Foundation.Date?
	var current_open: Double?
	var current_high: Double?
	var current_low: Double?
	var current_close: Double?
	var current_volume: Double?
	var previous_open: Double?
	var previous_high: Double?
	var previous_low: Double?
	var previous_close: Double?
	var previous_volume: Double?
	var updated_at: Foundation.Date?
	let contract_id: Int32
}
