//
//  Store+Schema.swift
//  IBKit
//
//  Created by Sten Soosaar on 14.03.2025.
//

import Foundation

import Foundation


extension IBStore {
	
	static var schema: String {
		
		return """
			-- account
			CREATE TABLE IF NOT EXISTS accounts (
				name VARCHAR NOT NULL,
				type VARCHAR,
				currency VARCHAR,
				ne_liquidation DOUBLE,
				initial_margin DOUBLE,
				maintenance_margin DOUBLE,
				buying_power DOUBLE,
				available_funds DOUBLE,
				excess_liquidity DOUBLE,
				total_positions DOUBLE,
				unrealised_pnl DOUBLE,
				cushion DOUBLE,
				leverage DOUBLE,
				average_gain DOUBLE,
				average_loss DOUBLE,
				hit_rate DOUBLE,
				high_watermark DOUBLE,
				profit_factor DOUBLE,
				created_at TIMESTAMP,
				updated_at TIMESTAMP
			);
			-- performance index to hold net liquidation value history
			CREATE TABLE IF NOT EXISTS performace (
				timestamp TIMESTAMP,
				deposits DOUBLE,
				withdrawals DOUBLE,
				end_balance DOUBLE,
				account_name VARCHAR
			);
			-- orders
				CREATE TABLE IF NOT EXISTS orders (
				contract_id INT32 NOT NULL,
				account_name VARCHAR NOT NULL,
				units DOUBLE,
				price_limit DOUBLE,
				price_stop DOUBLE,
				order_id INT,
				parent_id INT,
				reference_id VARCHAR,
				created_at TIMESTAMP,
				updated_at TIMESTAMP
			);
			-- execution data eg fill
			CREATE TABLE IF NOT EXISTS fills (
				contract_id INT32 NOT NULL,
				account_name VARCHAR NOT NULL,
				units DOUBLE,
				price DOUBLE,
				commission DOUBLE,
				created_at TIMESTAMP,
				updated_at TIMESTAMP
			);
			-- positions. maybe need to be view instead
			CREATE TABLE IF NOT EXISTS positions (
				contract_id INT32 NOT NULL,
				account_name VARCHAR NOT NULL,
				units DOUBLE,
				unit_price DOUBLE,
				cost_value DOUBLE,
				created_at TIMESTAMP,
				updated_at TIMESTAMP
			);
			-- contract details
			CREATE TABLE IF NOT EXISTS contracts (
				id INT32 NOT NULL UNIQUE,
				type VARCHAR NOT NULL,
				base VARCHAR NOT NULL,
				quote VARCHAR NOT NULL,
				symbol VARCHAR NOT NULL,
				local_symbol VARCHAR NOT NULL,
				expiration DATE,
				strike DOUBLE,
				execution_right VARCHAR,
				multiplier VARCHAR,
				destination_exchange VARCHAR,
				primary_exchange VARCHAR,
				time_zone_id VARCHAR,
				minimum_tick_size DOUBLE,
				size_increment DOUBLE,
				underlaying_contract_id INT32,
				name VARCHAR,
				regular_session_open DATE,
				regular_session_duration DOUBLE,
				extened_session_open DATE,
				extended_session_duration DOUBLE,
				industry VARCHAR,
				category VARCHAR,
				subcategory VARCHAR,
				isin VARCHAR,
				subtype VARCHAR,
				created_at TIMESTAMP,
				updated_at TIMESTAMP
			);
			-- quote summary
			CREATE TABLE IF NOT EXISTS quotes (
				bid_price DOUBLE,
				bid_size DOUBLE,
				ask_price DOUBLE,
				ask_size DOUBLE,
				last_price DOUBLE,
				last_size DOUBLE,
				last_timestamp TIMESTAMP,
				current_open DOUBLE,
				current_high DOUBLE,
				current_low DOUBLE,
				current_close DOUBLE,
				current_volume DOUBLE,
				previous_open DOUBLE,
				previous_high DOUBLE,
				previous_low DOUBLE,
				previous_close DOUBLE,
				previous_volume DOUBLE,
				contract_id INT32 NOT NULL UNIQUE,
				updated_at TIMESTAMP
			);
			-- price history
			CREATE TABLE IF NOT EXISTS price_history (
				date TIMESTAMP,
				open DOUBLE,
				high DOUBLE,
				low DOUBLE,
				close DOUBLE,
				volume DOUBLE,
				count INT64,
				vwap DOUBLE,
				contract_id INT32 NOT NULL
			);
		"""
	}
	
}
