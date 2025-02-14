//
//  IBResponse.swift
//  IBKit
//
//  Created by Sten Soosaar on 14.12.2024.
//


//
//  IBEvent.swift
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


public protocol IBResponse: IBDecodable{}


public protocol IBEvent { }


public protocol IBIndexedEvent: IBEvent {
	var requestID: Int				{ get }
}





public protocol IBAnyMarketData: IBEvent {
	
}

public protocol IBAnyTickData: IBAnyMarketData{
	
	associatedtype ResultType: Any
	
	var type: IBTickType 			{get}
	var value: ResultType			{get}
	
}





public protocol IBAnyPriceObservation {
	
}


public protocol AnyOrderUpdate{}


public protocol AnyAccountSummary{}


public protocol AnyAccountUpdate{
	var accountName: String {get}
}


public protocol AnyContractDetails{
	var requestID: Int {get}
}


public protocol IBAnyMarketDepth: IBResponse{
	
	var requestID: Int 	{ get }
	var position: Int	{ get }
	var operation: Int	{ get }
	var side: Int		{ get }
	var price: Double	{ get }
	var size: Double	{ get }

}
