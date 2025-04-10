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
	public static let PTA_ORDERS: Int = 39
	public static let FUNDAMENTAL_DATA: Int = 40
	public static let DELTA_NEUTRAL: Int = 40
	public static let CONTRACT_DATA_CHAIN: Int = 40
	public static let SCALE_ORDERS2: Int = 40
	public static let ALGO_ORDERS: Int = 41
	public static let EXECUTION_DATA_CHAIN: Int = 42
	public static let NOT_HELD: Int = 44
	public static let SEC_ID_TYPE: Int = 45
	public static let PLACE_ORDER_CONID: Int = 46
	public static let REQ_MKT_DATA_CONID: Int = 47
	public static let REQ_CALC_IMPLIED_VOLAT: Int = 49
	public static let REQ_CALC_OPTION_PRICE: Int = 50
	public static let SSHORTX_OLD: Int = 51
	public static let SSHORTX: Int = 52
	public static let REQ_GLOBAL_CANCEL: Int = 53
	public static let HEDGE_ORDERS: Int = 54
	public static let REQ_MARKET_DATA_TYPE: Int = 55
	public static let OPT_OUT_SMART_ROUTING: Int = 56
	public static let SMART_COMBO_ROUTING_PARAMS: Int = 57
	public static let DELTA_NEUTRAL_CONID: Int = 58
	public static let SCALE_ORDERS3: Int = 60
	public static let ORDER_COMBO_LEGS_PRICE: Int = 61
	public static let TRAILING_PERCENT: Int = 62
	public static let DELTA_NEUTRAL_OPEN_CLOSE: Int = 66
	public static let POSITIONS: Int = 67
	public static let ACCOUNT_SUMMARY: Int = 67
	public static let TRADING_CLASS: Int = 68
	public static let SCALE_TABLE: Int = 69
	public static let LINKING: Int = 70
	public static let ALGO_ID: Int = 71
	public static let OPTIONAL_CAPABILITIES: Int = 72
	public static let ORDER_SOLICITED: Int = 73
	public static let LINKING_AUTH: Int = 74
	public static let PRIMARYEXCH: Int = 75
	public static let RANDOMIZE_SIZE_AND_PRICE: Int = 76
	public static let FRACTIONAL_POSITIONS: Int = 101
	public static let PEGGED_TO_BENCHMARK: Int = 102
	public static let MODELS_SUPPORT: Int = 103
	public static let SEC_DEF_OPT_PARAMS_REQ: Int 	 	= 104
	public static let EXT_OPERATOR: Int = 105
	public static let SOFT_DOLLAR_TIER: Int = 106
	public static let REQ_FAMILY_CODES: Int = 107
	public static let REQ_MATCHING_SYMBOLS: Int = 108
	public static let PAST_LIMIT: Int = 109
	public static let MD_SIZE_MULTIPLIER: Int = 110
	public static let CASH_QTY: Int = 111
	public static let REQ_MKT_DEPTH_EXCHANGES: Int = 112
	public static let TICK_NEWS: Int = 113
	public static let REQ_SMART_COMPONENTS: Int = 114
	public static let REQ_NEWS_PROVIDERS: Int = 115
	public static let REQ_NEWS_ARTICLE: Int = 116
	public static let REQ_HISTORICAL_NEWS: Int = 117
	public static let REQ_HEAD_TIMESTAMP: Int = 118
	public static let REQ_HISTOGRAM: Int = 119
	public static let SERVICE_DATA_TYPE: Int = 120
	public static let AGG_GROUP: Int = 121
	public static let UNDERLYING_INFO: Int = 122
	public static let CANCEL_HEADTIMESTAMP: Int = 123
	public static let SYNT_REALTIME_BARS: Int = 124
	public static let CFD_REROUTE: Int = 125
	public static let MARKET_RULES: Int = 126
	public static let PNL: Int = 127
	public static let NEWS_QUERY_ORIGINS: Int = 128
	public static let UNREALIZED_PNL: Int = 129
	public static let HISTORICAL_TICKS: Int = 130
	public static let MARKET_CAP_PRICE: Int = 131
	public static let PRE_OPEN_BID_ASK: Int = 132
	public static let REAL_EXPIRATION_DATE: Int = 134
	public static let REALIZED_PNL: Int = 135
	public static let LAST_LIQUIDITY: Int = 136
	public static let TICK_BY_TICK: Int = 137
	public static let DECISION_MAKER: Int = 138
	public static let MIFID_EXECUTION: Int = 139
	public static let TICK_BY_TICK_IGNORE_SIZE: Int = 140
	public static let AUTO_PRICE_FOR_HEDGE: Int = 141
	public static let WHAT_IF_EXT_FIELDS: Int = 142
	public static let SCANNER_GENERIC_OPTS: Int = 143
	public static let API_BIND_ORDER: Int = 144
	public static let ORDER_CONTAINER: Int = 145
	public static let SMART_DEPTH: Int = 146
	public static let REMOVE_NULL_ALL_CASTING: Int = 147
	public static let PEG_ORDERS: Int = 148
	public static let MKT_DEPTH_PRIM_EXCHANGE: Int = 149
	public static let COMPLETED_ORDERS: Int = 150
	public static let PRICE_MGMT_ALGO: Int = 151
	public static let STOCK_TYPE: Int = 152
	public static let ENCODE_MSG_ASCII7: Int = 153
	public static let SEND_ALL_FAMILY_CODES: Int = 154
	public static let NO_DEFAULT_OPEN_CLOSE: Int = 155
	public static let PRICE_BASED_VOLATILITY: Int = 156
	public static let REPLACE_FA_END: Int = 157
	public static let DURATION: Int = 158
	public static let MARKET_DATA_IN_SHARES: Int = 159
	public static let POST_TO_ATS: Int = 160
	public static let WSHE_CALENDAR: Int = 161
	public static let AUTO_CANCEL_PARENT: Int = 162
	public static let FRACTIONAL_SIZE_SUPPORT: Int = 163
	public static let SIZE_RULES: Int = 164
	public static let HISTORICAL_SCHEDULE: Int = 165
	public static let ADVANCED_ORDER_REJECT: Int = 166
	public static let USER_INFO: Int = 167
	public static let CRYPTO_AGGREGATED_TRADES: Int = 168
	public static let MANUAL_ORDER_TIME: Int = 169
	public static let PEGBEST_PEGMID_OFFSETS: Int = 170
	public static let WSH_EVENT_DATA_FILTERS: Int = 171
	public static let IPO_PRICES: Int = 172
	public static let WSH_EVENT_DATA_FILTERS_DATE: Int = 173
	public static let INSTRUMENT_TIMEZONE: Int = 174
	public static let HMDS_MARKET_DATA_IN_SHARES: Int = 175
	public static let BOND_ISSUERID: Int = 176
	public static let FA_PROFILE_DESUPPORT: Int = 177
	public static let PENDING_PRICE_REVISION: Int = 178
	public static let FUND_DATA_FIELDS: Int = 179
	public static let MANUAL_ORDER_TIME_EXERCISE_OPTIONS: Int = 180
	public static let OPEN_ORDER_AD_STRATEGY: Int = 181
	public static let LAST_TRADE_DATE: Int = 182
	public static let CUSTOMER_ACCOUNT: Int = 183
	public static let PROFESSIONAL_CUSTOMER: Int = 184
	public static let BOND_ACCRUED_INTEREST: Int = 185
	public static let INELIGIBILITY_REASONS: Int = 186
	public static let RFQ_FIELDS: Int = 187
	public static let BOND_TRADING_HOURS: Int = 188
	public static let INCLUDE_OVERNIGHT: Int = 189
	public static let UNDO_RFQ_FIELDS: Int = 190
	public static let PERM_ID_AS_LONG: Int = 191
	public static let CME_TAGGING_FIELDS: Int = 192
	public static let CME_TAGGING_FIELDS_IN_OPEN_ORDER: Int = 193
	public static let ERROR_TIME: Int = 194
	public static let FULL_ORDER_PREVIEW_FIELDS: Int = 195
}


extension IBServerVersion{
	
	static var range: ClosedRange<Int> {
		return WHAT_IF_EXT_FIELDS...FA_PROFILE_DESUPPORT
	}

}
