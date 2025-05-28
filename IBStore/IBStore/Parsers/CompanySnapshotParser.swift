//
//  CompanySnapshotParser.swift
//  
//
//  Created by Sten Soosaar on 23.03.2025.
//


import Foundation



class CompanySnapshotParser: NSObject, XMLParserDelegate {
	private var currentElement = ""
	private var currentAttributes: [String: String] = [:]
	private var currentValue: String = ""
	private var currentCurrency: String = ""

	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName: String?,
		attributes attributeDict: [String : String]
	) {
		currentElement = elementName
		currentAttributes = attributeDict

		if ["TotalRevenues", "DividendPerShares", "EPSs", "Dividends"].contains(elementName) {
			currentCurrency = attributeDict["currency"] ?? "USD"
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		currentValue += string.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName: String?
	) {
		guard !currentValue.isEmpty else { return }
	}
	
	
}

