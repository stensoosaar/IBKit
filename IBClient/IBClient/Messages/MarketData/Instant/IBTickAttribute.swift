//
//  IBClient.swift
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



public enum IBTickAttribute: String, Decodable, Sendable {
	
	/// The Bid price is lower than the day's lowest value or the ask price is higher than the highest ask.
	case pastLimit 			= "pastLimit"
	
	/// The Bid is lower than day's lowest low.
	case bidPastLow			= "bidPastLow"
	
	/// The Ask is higher than day's highest ask.
	case askPastHigh 		= "askPastHigh"
	
	/// Whether the price tick is available for automatic execution or not
	case canAutoExecute 	= "canAutoExecute"
	
	/// The bid/ask price tick is from pre-open session.
	case preOpen 			= "preOpen"
	
	/// Trade is classified as 'unreportable' (e.g. odd lots, combos, derivative trades, etc)
	case unreported 		= "unreported"
	
}




