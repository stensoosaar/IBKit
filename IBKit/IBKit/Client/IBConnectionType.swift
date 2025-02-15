//
//  IBConnectionType.swift
//  IBKit
//
//  Created by Sten Soosaar on 15.02.2025.
//


public enum IBConnectionType {
	case gateway
	case workstation
		
	public var host: String {
		"https://127.0.0.1"
	}
		
	public var liveTradingPort: Int {
		switch self {
			case .gateway:        return 4001
			case .workstation:    return 7496
		}
	}
		
	public var simulatedTradingPort: Int {
		switch self {
		case .gateway:        return 4002
		case .workstation:    return 7497
		}
	}
	
}
