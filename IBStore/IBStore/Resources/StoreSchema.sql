-- account
CREATE SCHEMA base;
CREATE TABLE IF NOT EXISTS base.accounts (
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

CREATE TABLE IF NOT EXISTS base.balances (
	account_name VARCHAR NOT NULL,
	currency VARCHAR NOT NULL,
	units DOUBLE NOT NULL,
	rateToBase DOUBLE NOT NULL DEFAULT 1.00
);

-- daily index to hold account balance history
CREATE TABLE IF NOT EXISTS base.equity_curve (
	account_name VARCHAR,
	timestamp TIMESTAMP,
	deposits DOUBLE DEFAULT 0.0,
	withdrawals DOUBLE DEFAULT 0.0,
	end_balance DOUBLE
);
		
-- orders
CREATE TABLE IF NOT EXISTS base.orders (
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
CREATE TABLE IF NOT EXISTS base.fills (
	contract_id INT32 NOT NULL,
	account_name VARCHAR NOT NULL,
	units DOUBLE,
	price DOUBLE,
	commission DOUBLE,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
			
-- positions. maybe need to be view instead
CREATE TABLE IF NOT EXISTS base.positions (
	contract_id INT32 NOT NULL,
	account_name VARCHAR NOT NULL,
	units DOUBLE,
	unit_price DOUBLE,
	cost_value DOUBLE,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
			
-- contract details
CREATE TABLE IF NOT EXISTS base.contracts (
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
	regular_session STRUCT(open TIMESTAMP, close TIMESTAMP)[],
	extended_session STRUCT(open TIMESTAMP, close TIMESTAMP)[],
	industry VARCHAR,
	category VARCHAR,
	subcategory VARCHAR,
	isin VARCHAR,
	subtype VARCHAR,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_contracts
ON base.contracts (id, type, base, quote);
			
-- quote summary
CREATE TABLE IF NOT EXISTS base.quotes (
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
CREATE TABLE IF NOT EXISTS base.price_history (
	contract_id INT32 NOT NULL,
	date TIMESTAMP,
	open DOUBLE,
	high DOUBLE,
	low DOUBLE,
	close DOUBLE,
	volume DOUBLE,
	count INT64,
	vwap DOUBLE
);
CREATE INDEX idx_price_history
ON base.price_history (contract_id, date);

			
-- Account performance using modified Dietz method
CREATE VIEW base.performance AS
	WITH strategy_data AS (
		SELECT
			account_name,
			timestamp,
			(deposits - withdrawals) AS cash_flow,
			LAG(end_balance) OVER (PARTITION BY account_name ORDER BY timestamp) AS previous_balance,
			end_balance,
			DATEDIFF('day',
				LAG(timestamp) OVER (PARTITION BY account_name ORDER BY timestamp),
				timestamp) AS date_diff
		FROM base.equity_curve
	),
	strategy_returns AS (
		SELECT
			timestamp,
			cash_flow,
			end_balance,
			CASE
				WHEN previous_balance IS NULL THEN NULL
				WHEN previous_balance + cash_flow = 0 THEN 0
				ELSE (end_balance - previous_balance - cash_flow) /
					(previous_balance + (cash_flow * date_diff / 365.0))
			END AS strategy_return
		FROM strategy_data
	),
	summary AS (
		SELECT
			timestamp,
			cash_flow::DOUBLE AS cash_flow,
			end_balance::DOUBLE AS end_balance,
			strategy_return::DOUBLE AS strategy_return,
			COALESCE(SUM(strategy_return) OVER (ORDER BY timestamp), 0) AS strategy_cumulative
		FROM strategy_returns
		ORDER BY timestamp
	)
SELECT
	timestamp,
	cash_flow,
	end_balance,
	strategy_return,
	strategy_cumulative,
	MAX(strategy_cumulative) OVER (ORDER BY timestamp) AS high_watermark,
	(strategy_cumulative - MAX(strategy_cumulative) OVER (ORDER BY timestamp)) AS drawdown
FROM summary;


-- CUSTOM STUFF
CREATE SCHEMA user;

-- return matrix accress all trackable assets on daily granularity
CREATE VIEW user.price_returns AS WITH
	daily_prices AS (
		SELECT
			contract_id,
			time_bucket(INTERVAL 1 day, date) AS bucket,
			LAST(close) AS close,
			LAST(volume) AS volume
		FROM base.price_history
		GROUP BY contract_id, bucket
	),
	rankedPrices AS (
		SELECT
			contract_id,
			close as c0,
			LAG(close, 1) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c1,
			LAG(close, 5) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c5,
			LAG(close, 10) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c10,
			LAG(close, 15) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c15,
			LAG(close, 21) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c21,
			LAG(close, 42) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c42,
			LAG(close, 63) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c63,
			LAG(close, 126) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c126,
			LAG(close, 189) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c189,
			LAG(close, 252) OVER (PARTITION BY contract_id ORDER BY dp.bucket) AS c252,
			ROW_NUMBER() OVER (PARTITION BY contract_id ORDER BY dp.bucket DESC) AS rownum
		FROM daily_prices AS dp
	)
SELECT
	contract_id,
	(c0-c1)/c1 as change1D,
	(c0-c5)/c5 as change1W,
	(c0-c10)/c10 as change2W,
	(c0-c15)/c15 as change3W,
	(c0-c21)/c21 as change1M,
	(c0-c42)/c42 as change2M,
	(c0-c63)/c63 as change3M,
	(c0-c126)/c126 as change6M,
	(c0-c189)/c189 as change9M,
	(c0-c252)/c252 as change12M
FROM RankedPrices
WHERE rownum = 1
ORDER BY contract_id ASC;
			
-- MARKET STATISTICS
-- return matrix accress all trackable assets on daily granularity
CREATE VIEW user.market_stats AS WITH
	filtered_contracts AS (
		SELECT
			id as contract_id,
			quote AS currency  -- Assuming 'quote' is the intended currency
		FROM base.contracts
		WHERE type = 'STK'
	),
	daily_prices AS (
		SELECT
			contract_id,
			currency,
			time_bucket(INTERVAL 1 day, date) AS bucket,
			LAST(close) AS close,
			LAST(volume) AS volume
		FROM base.price_history
		JOIN filtered_contracts USING (contract_id)
		GROUP BY contract_id, currency, bucket
	),
	price_changes AS (
		SELECT
			dp.contract_id AS contract_id,
			dp.currency AS currency,
			dp.bucket AS date,
			dp.close AS c0,
			LAG(dp.close) OVER (PARTITION BY dp.contract_id ORDER BY dp.bucket) AS c1,
			dp.volume AS v0,
			LAG(dp.volume) OVER (PARTITION BY dp.contract_id ORDER BY dp.bucket) AS v1
		FROM daily_prices AS dp
	)
SELECT
	currency,
	date,
	COUNT(CASE WHEN (c0 - c1) > 0 THEN 1 END) AS price_adv,
	COUNT(CASE WHEN (c0 - c1) < 0 THEN 1 END) AS price_decl,
	COUNT(CASE WHEN (c0 - c1) = 0 THEN 1 END) AS price_unch,
	COUNT(CASE WHEN (v0 - v1) > 0 THEN 1 END) AS volume_adv,
	COUNT(CASE WHEN (v0 - v1) < 0 THEN 1 END) AS volume_decl,
	COUNT(CASE WHEN (v0 - v1) = 0 THEN 1 END) AS volume_unch,
	COUNT(contract_id) AS total
FROM price_changes
GROUP BY currency, date
ORDER BY currency, date;
