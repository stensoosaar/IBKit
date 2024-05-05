//
//  File.swift
//
//
//  Created by Mike Holman on 05/05/2024.
//

import Foundation

//public virtual void updateMktDepthL2(int tickerId, int position, string marketMaker, int operation, int side, double price, decimal size, bool isSmartDepth)

public struct IBMarketDepthL2: Decodable, IBEvent {
    
    public enum IBMarketDepthOperation: Int, Decodable {
        /**
         insert this new order into the row identified by ‘position’
         */
        case insert = 0
        
        /**
         update the existing order in the row identified by ‘position’
         */
        case update = 1
        
        /**
         delete the existing order at the row identified by ‘position’
         */
        case delete = 2
    }
    
    public enum IBMarketDepthSide: Int, Decodable {
        case ask = 0
        case bid = 1
    }

    /**
     Request identifier used to track data.
     */
    public var tickerID: Int
    
    /**
     The order book’s row being updated.
     */
    public var position: Int
    
    /**
     The exchange holding the order if isSmartDepth is True, otherwise the MPID of the market maker.
     */
    public var marketMaker: String
    
    /**
     Indicates a change in the row’s value.
     */
    public var operation: IBMarketDepthOperation

    /**
     Ask/bid bid.
     */
    public var side: IBMarketDepthSide
    
    /**
     The order’s price.
     */
    public var price: Double

    /**
     The order’s size.
     */
    public var size: Decimal
    
    /**
     Flag indicating if this is smart depth response.
     */
    public var isSmartDepth: Bool
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.tickerID = try container.decode(Int.self)
        self.position = try container.decode(Int.self)
        self.marketMaker = try container.decode(String.self)
        self.operation = try container.decode(IBMarketDepthOperation.self)
        self.side = try container.decode(IBMarketDepthSide.self)
        self.price = try container.decode(Double.self)
        self.size = try container.decode(Decimal.self)
        self.isSmartDepth = try container.decode(Bool.self)
    }
    
}

