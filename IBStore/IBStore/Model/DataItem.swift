public enum DataItem{
	case quotes
	case bars(size:TimeInterval)
	case fundamentals
	
	var type: Request.Type{
		switch self {
		case .quotes: return MarketDataRequest.self
		case .bars(_ ): return PriceHistoryRequest.self
		case .fundamentals: return FundamentalDataRequest.self
		}
	}
	
}


public struct ScheduledDataItem {
	public let item: DataItem
	public let schedule: Schedule
	
	public init(_ item: DataItem, schedule: Schedule = .hourly(minute: 0)) {
		self.item = item
		self.schedule = schedule
	}
	
}