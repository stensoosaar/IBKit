//
//  IBRequestManager.swift
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


public protocol IBRequestItem {
	var requestID: Int 			{ get set }
	var localID: String			{ get set }
	var refereceID: String		{ get set }
}


public struct IBContractRequestItem: IBRequestItem{
	public var requestID: Int
	public var localID: String
	public var refereceID: String
	
	public init(requestID: Int, localID: String, refereceID: String) {
		self.requestID = requestID
		self.localID = localID
		self.refereceID = refereceID
	}
	
}


public struct IBMarketDataRequestItem: IBRequestItem{
	public var requestID: Int
	public var localID: String
	public var refereceID: String
	public var duration: TimeInterval
	public var source: IBBarSource?
	
	public init(requestID: Int, localID: String, refereceID: String, duration: TimeInterval, source: IBBarSource? = nil) {
		self.requestID = requestID
		self.localID = localID
		self.refereceID = refereceID
		self.duration = duration
		self.source = source
	}
	
}


public struct IBOrderRequestItem: IBRequestItem{
	public var requestID: Int
	public var localID: String
	public var refereceID: String
	
	public init(requestID: Int, localID: String, refereceID: String) {
		self.requestID = requestID
		self.localID = localID
		self.refereceID = refereceID
	}
	
}


public struct IBAccountRequestItem: IBRequestItem{
	public var requestID: Int
	public var localID: String
	public var refereceID: String
	
	public init(requestID: Int, localID: String, refereceID: String) {
		self.requestID = requestID
		self.localID = localID
		self.refereceID = refereceID
	}
	
}


public class IBRequestManager{

	private var activeRequestID:[Int] = []
	
	private var buffer: [IBRequestItem] = []
	
	public init(){}
	
	public func append(_ request: IBRequestItem){
		if activeRequestID.contains(request.requestID) == false {
			activeRequestID.append(request.requestID)
			buffer.append(request)
		}
	}
	
	public func getBy(id: Int) -> IBRequestItem? {
		if activeRequestID.contains(id) {
			return buffer.first(where: {$0.requestID == id })
		}
		return nil
	}
	
	
	public func remove(_ index: Int){
		if activeRequestID.contains(index){
			if let objectIndex = buffer.firstIndex(where: {$0.requestID == index }){
				buffer.remove(at: objectIndex)
			}
			if let objectIndex = activeRequestID.firstIndex(where: {$0 == index }){
				activeRequestID.remove(at: objectIndex)
			}

		}
	}
	
}
