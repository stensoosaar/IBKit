//
//  File.swift
//  
//
//  Created by Sten on 08.11.2022.
//

import Foundation



extension Optional where Wrapped: AdditiveArithmetic {
	
	static func + (lhs: Wrapped?, rhs: Wrapped?) -> Optional {
		guard let leftValue = lhs, let righValue = rhs else {return nil}
		return leftValue + righValue
	}

	
	static func - (lhs: Wrapped?, rhs: Wrapped?) -> Optional {
		guard let leftValue = lhs, let righValue = rhs else {return nil}
		return leftValue - righValue
	}
	
}


extension Optional where Wrapped: Numeric {
	
	static func * (lhs: Wrapped?, rhs: Wrapped?) -> Optional {
		guard let leftValue = lhs, let righValue = rhs else {return nil}
		return leftValue * righValue
	}
	
}


extension Optional where Wrapped: BinaryInteger {
	
	static func / (lhs: Wrapped?, rhs: Wrapped?) -> Optional {
		guard let leftValue = lhs, let righValue = rhs else {return nil}
		return leftValue / righValue
	}

}


extension Optional where Wrapped: FloatingPoint {
	
	static func / (lhs: Wrapped?, rhs: Wrapped?) -> Optional {
		guard let leftValue = lhs, let righValue = rhs else {return nil}
		return leftValue / righValue
	}

}
