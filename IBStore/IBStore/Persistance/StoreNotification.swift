//
//  StoreNotification.swift
//  IBKit
//
//  Created by Sten Soosaar on 05.04.2025.
//


import Foundation

public protocol StoreNotification{}

public enum ContractEvent {
	case quoteUpdated
	case barUpdated
	case fundamentalsUpdated
}

public enum AccountEvent {
	case balancesUpdated
	case positionUpdated
	case orderUpdated
}
