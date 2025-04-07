public protocol StoreNotification{}

public enum StoreNotificationCategory {
	case add
	case update
	case delete
}

public struct QuoteUpdate: StoreNotification{}
public struct BarUpdate: StoreNotification{}
public struct FundamentalsUpdate: StoreNotification{}
public struct WatchlistUpdate: StoreNotification{}
public struct AccountUpdate: StoreNotification{}
public struct ModelUpdate: StoreNotification{}

