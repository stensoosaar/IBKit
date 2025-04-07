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
import IBClient


public protocol AnyTickProtocol{
	var type: IBTickType {get}
	var date: Date {get}
}

extension TickPrice: AnyTickProtocol{}
extension TickSize: AnyTickProtocol{}
extension TickQuote: AnyTickProtocol{}



public struct QuoteSummary {
	public var bidPrice: Double?
	public var bidSize: Double?
	public var askPrice: Double?
	public var askSize: Double?
	public var lastPrice: Double?
	public var lastSize: Double?
	public var tradedAt: Date?
	public var currentOpen: Double?
	public var currentHigh: Double?
	public var currentLow: Double?
	public var currentClose: Double?
	public var currentVolume: Double?
	public var previousOpen: Double?
	public var previousHigh: Double?
	public var previousLow: Double?
	public var previousClose: Double?
	public var previousVolume: Double?
	public var updatedAt: Date?
	public var delayed: Bool = false
}

extension QuoteSummary{
	
	public var change: Double?{
		guard let previousClose = previousClose, let last = lastPrice else { return nil }
		return (last - previousClose)
	}
	
	public var changeInPerCent: Double?{
		guard let previousClose = previousClose, let last = lastPrice else { return nil }
		return (last - previousClose) / previousClose
	}
	
	public var midPrice: Double?{
		guard let bidPrice = bidPrice, let askPrice = askPrice else { return nil }
		return (bidPrice + askPrice) / 2
	}
	
}

extension QuoteSummary{
	
	private func needsReset(lastUpdate:Date?, eventDate:Date?)->Bool{
		if let lastUpdate = lastUpdate, let eventDate = eventDate {
			let test = Calendar.current.compare(lastUpdate, to: eventDate, toGranularity: .day)
			return test == .orderedAscending
		}
		return false
	}
	
	mutating func update(_ event: AnyTickProtocol){
		
		if needsReset(lastUpdate: self.updatedAt, eventDate: event.date) == true {
			reset()
		}
		
		switch (event, event.type) {
		case (let tick as TickQuote, .Bid), (let tick as TickQuote, .Delayed_Bid):
			bidPrice = tick.price
			bidSize = tick.size
			self.updatedAt = event.date
		case (let tick as TickQuote, .Ask), (let tick as TickQuote, .Delayed_Ask):
			askPrice = tick.price
			askSize = tick.size
			self.updatedAt = event.date
		case (let tick as TickQuote, .Last), (let tick as TickQuote, .Delayed_Last):
			lastPrice = tick.price
			lastSize = tick.size
			tradedAt = tick.date
			currentVolume = tick.size + currentVolume
			self.updatedAt = event.date
			updateBarStats(lastTrade: tick.price)
		case (let tick as TickSize, .Bid_Size), (let tick as TickSize, .Delayed_Bid_Size):
			bidSize = tick.size
			self.updatedAt = event.date
		case (let tick as TickSize, .Ask_Size), (let tick as TickSize, .Delayed_Ask_Size):
			askSize = tick.size
			self.updatedAt = event.date
		case (let tick as TickSize, .Last_Size), (let tick as TickSize, .Delayed_Last_Size):
			lastSize = tick.size
			currentVolume = tick.size + currentVolume
			self.updatedAt = event.date
		case (let tick as TickPrice, .Open_Price), (let tick as TickPrice, .Delayed_Open_Price):
			currentOpen = tick.price
		case (let tick as TickPrice, .High_Price), (let tick as TickPrice, .Delayed_High_Price):
			currentHigh = tick.price
		case (let tick as TickPrice, .Low_Price), (let tick as TickPrice, .Delayed_Low_Price):
			currentLow = tick.price
		case (let tick as TickPrice, .Close_Price), (let tick as TickPrice, .Delayed_Close_Price):
			currentClose = tick.price
		case (let tick as TickSize, .Volume), (let tick as TickSize, .Delayed_Volume):
			currentVolume = tick.size
			self.updatedAt = event.date
		default:
			break
		}
	}
	
	private mutating func updateBarStats(lastTrade: Double?){
		guard let lastPrice = lastTrade else { return }
		currentOpen = currentOpen == nil ? lastPrice : currentOpen
		currentHigh = lastPrice > (currentHigh ?? Double.leastNormalMagnitude) ? lastPrice : currentHigh
		currentLow = lastPrice < (currentLow ?? Double.greatestFiniteMagnitude) ? lastPrice : currentLow
		currentClose = lastPrice
	}
	
	private mutating func reset(){
		previousOpen = currentOpen
		previousHigh = currentHigh
		previousLow = currentLow
		previousClose = currentClose
		previousVolume = currentVolume
		bidPrice = nil
		bidSize = nil
		askPrice = nil
		askSize = nil
		lastPrice = nil
		lastSize = nil
		tradedAt = nil
		currentOpen = nil
		currentHigh = nil
		currentLow = nil
		currentClose = nil
		currentVolume = nil
	}
}
