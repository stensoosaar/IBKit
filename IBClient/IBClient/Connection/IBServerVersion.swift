//
//  IBServerVersion.swift
//	IBKit
//
//	Copyright (c) 2016-2023 Sten Soosaar
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


struct IBServerVersion {
	public static var PTA_ORDERS: Int = 39
	public static var FUNDAMENTAL_DATA: Int = 40
	public static var DELTA_NEUTRAL: Int = 40
	public static var CONTRACT_DATA_CHAIN: Int = 40
	public static var SCALE_ORDERS2: Int = 40
	public static var ALGO_ORDERS: Int = 41
	public static var EXECUTION_DATA_CHAIN: Int = 42
	public static var NOT_HELD: Int = 44
	public static var SEC_ID_TYPE: Int = 45
	public static var PLACE_ORDER_CONID: Int = 46
	public static var REQ_MKT_DATA_CONID: Int = 47
	public static var REQ_CALC_IMPLIED_VOLAT: Int = 49
	public static var REQ_CALC_OPTION_PRICE: Int = 50
	public static var SSHORTX_OLD: Int = 51
	public static var SSHORTX: Int = 52
	public static var REQ_GLOBAL_CANCEL: Int = 53
	public static var HEDGE_ORDERS: Int = 54
	public static var REQ_MARKET_DATA_TYPE: Int = 55
	public static var OPT_OUT_SMART_ROUTING: Int = 56
	public static var SMART_COMBO_ROUTING_PARAMS: Int = 57
	public static var DELTA_NEUTRAL_CONID: Int = 58
	public static var SCALE_ORDERS3: Int = 60
	public static var ORDER_COMBO_LEGS_PRICE: Int = 61
	public static var TRAILING_PERCENT: Int = 62
	public static var DELTA_NEUTRAL_OPEN_CLOSE: Int = 66
	public static var POSITIONS: Int = 67
	public static var ACCOUNT_SUMMARY: Int = 67
	public static var TRADING_CLASS: Int = 68
	public static var SCALE_TABLE: Int = 69
	public static var LINKING: Int = 70
	public static var ALGO_ID: Int = 71
	public static var OPTIONAL_CAPABILITIES: Int = 72
	public static var ORDER_SOLICITED: Int = 73
	public static var LINKING_AUTH: Int = 74
	public static var PRIMARYEXCH: Int = 75
	public static var RANDOMIZE_SIZE_AND_PRICE: Int = 76
	public static var FRACTIONAL_POSITIONS: Int = 101
	public static var PEGGED_TO_BENCHMARK: Int = 102
	public static var MODELS_SUPPORT: Int = 103
	public static var SEC_DEF_OPT_PARAMS_REQ: Int 	 	= 104
	public static var EXT_OPERATOR: Int = 105
	public static var SOFT_DOLLAR_TIER: Int = 106
	public static var REQ_FAMILY_CODES: Int = 107
	public static var REQ_MATCHING_SYMBOLS: Int = 108
	public static var PAST_LIMIT: Int = 109
	public static var MD_SIZE_MULTIPLIER: Int = 110
	public static var CASH_QTY: Int = 111
	public static var REQ_MKT_DEPTH_EXCHANGES: Int = 112
	public static var TICK_NEWS: Int = 113
	public static var REQ_SMART_COMPONENTS: Int = 114
	public static var REQ_NEWS_PROVIDERS: Int = 115
	public static var REQ_NEWS_ARTICLE: Int = 116
	public static var REQ_HISTORICAL_NEWS: Int = 117
	public static var REQ_HEAD_TIMESTAMP: Int = 118
	public static var REQ_HISTOGRAM: Int = 119
	public static var SERVICE_DATA_TYPE: Int = 120
	public static var AGG_GROUP: Int = 121
	public static var UNDERLYING_INFO: Int = 122
	public static var CANCEL_HEADTIMESTAMP: Int = 123
	public static var SYNT_REALTIME_BARS: Int = 124
	public static var CFD_REROUTE: Int = 125
	public static var MARKET_RULES: Int = 126
	public static var PNL: Int = 127
	public static var NEWS_QUERY_ORIGINS: Int = 128
	public static var UNREALIZED_PNL: Int = 129
	public static var HISTORICAL_TICKS: Int = 130
	public static var MARKET_CAP_PRICE: Int = 131
	public static var PRE_OPEN_BID_ASK: Int = 132
	public static var REAL_EXPIRATION_DATE: Int = 134
	public static var REALIZED_PNL: Int = 135
	public static var LAST_LIQUIDITY: Int = 136
	public static var TICK_BY_TICK: Int = 137
	public static var DECISION_MAKER: Int = 138
	public static var MIFID_EXECUTION: Int = 139
	public static var TICK_BY_TICK_IGNORE_SIZE: Int = 140
	public static var AUTO_PRICE_FOR_HEDGE: Int = 141
	public static var WHAT_IF_EXT_FIELDS: Int = 142
	public static var SCANNER_GENERIC_OPTS: Int = 143
	public static var API_BIND_ORDER: Int = 144
	public static var ORDER_CONTAINER: Int = 145
	public static var SMART_DEPTH: Int = 146
	public static var REMOVE_NULL_ALL_CASTING: Int = 147
	public static var PEG_ORDERS: Int = 148
	public static var MKT_DEPTH_PRIM_EXCHANGE: Int = 149
	public static var COMPLETED_ORDERS: Int = 150
	public static var PRICE_MGMT_ALGO: Int = 151
	public static var STOCK_TYPE: Int = 152
	public static var ENCODE_MSG_ASCII7: Int = 153
	public static var SEND_ALL_FAMILY_CODES: Int = 154
	public static var NO_DEFAULT_OPEN_CLOSE: Int = 155
	public static var PRICE_BASED_VOLATILITY: Int = 156
	public static var REPLACE_FA_END: Int = 157
	public static var DURATION: Int = 158
	public static var MARKET_DATA_IN_SHARES: Int = 159
	public static var POST_TO_ATS: Int = 160
	public static var WSHE_CALENDAR: Int = 161
	public static var AUTO_CANCEL_PARENT: Int = 162
	public static var FRACTIONAL_SIZE_SUPPORT: Int = 163
	public static var SIZE_RULES: Int = 164
	public static var HISTORICAL_SCHEDULE: Int = 165
	public static var ADVANCED_ORDER_REJECT: Int = 166
	public static var USER_INFO: Int = 167
	public static var CRYPTO_AGGREGATED_TRADES: Int = 168
	public static var MANUAL_ORDER_TIME: Int = 169
	public static var PEGBEST_PEGMID_OFFSETS: Int = 170
	public static var WSH_EVENT_DATA_FILTERS: Int = 171
	public static var IPO_PRICES: Int = 172
	public static var WSH_EVENT_DATA_FILTERS_DATE: Int = 173
	public static var INSTRUMENT_TIMEZONE: Int = 174
	public static var HMDS_MARKET_DATA_IN_SHARES: Int = 175
	public static var BOND_ISSUERID: Int = 176
	public static var FA_PROFILE_DESUPPORT: Int = 177
	public static var PENDING_PRICE_REVISION: Int = 178
	public static var FUND_DATA_FIELDS: Int = 179
	public static var MANUAL_ORDER_TIME_EXERCISE_OPTIONS: Int = 180
	public static var OPEN_ORDER_AD_STRATEGY: Int = 181
	public static var LAST_TRADE_DATE: Int = 182
	public static var CUSTOMER_ACCOUNT: Int = 183
	public static var PROFESSIONAL_CUSTOMER: Int = 184
	public static var BOND_ACCRUED_INTEREST: Int = 185
	public static var INELIGIBILITY_REASONS: Int = 186
	public static var RFQ_FIELDS: Int = 187
	public static var BOND_TRADING_HOURS: Int = 188
	public static var INCLUDE_OVERNIGHT: Int = 189
	public static var UNDO_RFQ_FIELDS: Int = 190
	public static var PERM_ID_AS_LONG: Int = 191
	public static var CME_TAGGING_FIELDS: Int = 192
	public static var CME_TAGGING_FIELDS_IN_OPEN_ORDER: Int = 193
	public static var ERROR_TIME: Int = 194
	public static var FULL_ORDER_PREVIEW_FIELDS: Int = 195
}


extension IBServerVersion{
	
	static var range: ClosedRange<Int> {
		return WHAT_IF_EXT_FIELDS...FA_PROFILE_DESUPPORT
	}

}
