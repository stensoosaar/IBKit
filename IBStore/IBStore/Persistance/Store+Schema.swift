//
//  IBStore.swift
//	IBKit
//
//	Copyright (c) 2016-2025 Sten Soosaar
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//


import Foundation

import Foundation


extension Store {
	
	static var schema: String {
		
		return """
			-- account
			CREATE TABLE IF NOT EXISTS accounts (
				name VARCHAR NOT NULL,
				type VARCHAR,
				currency VARCHAR,
				net_liquidation DOUBLE,
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
				updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
				created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
			);
			CREATE TABLE IF NOT EXISTS balances (
				account_name VARCHAR NOT NULL,
				currency VARCHAR NOT NULL,
				units DOUBLE NOT NULL,
				rateToBase DOUBLE NOT NULL DEFAULT 1.00
			);
			-- performance index to hold net liquidation value history
			CREATE TABLE IF NOT EXISTS performance (
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
				updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
				created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
			);
			-- execution data eg fill
			CREATE TABLE IF NOT EXISTS fills (
				contract_id INT32 NOT NULL,
				account_name VARCHAR NOT NULL,
				units DOUBLE,
				price DOUBLE,
				commission DOUBLE,
				updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
				created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
			);
			-- positions. maybe need to be view instead
			CREATE TABLE IF NOT EXISTS positions (
				contract_id INT32 NOT NULL,
				account_name VARCHAR NOT NULL,
				units DOUBLE,
				unit_price DOUBLE,
				cost_value DOUBLE,
				updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
				created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
				underlying_contract_id INT32,
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
				updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
				created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
				updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
