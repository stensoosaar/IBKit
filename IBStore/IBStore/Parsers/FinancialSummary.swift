//
//  FinancialSummaryParser.swift
//  
//
//  Created by Sten Soosaar on 23.03.2025.
//

import Foundation


public class FinancialSummaryParser: NSObject, XMLParserDelegate {
	private var currentElement = ""
	private var currentAttributes: [String: String] = [:]
	private var currentValue: String = ""
	private var currentCurrency: String = ""

	private var totalRevenues: [FinancialFact] = []
	private var dividendPerShares: [FinancialFact] = []
	private var eps: [FinancialFact] = []
	private var dividends: [Dividend] = []

	public static func parse(from data: Data) -> FinancialSummary? {
		let parser = FinancialSummaryParser()
		let xmlParser = XMLParser(data: data)
		xmlParser.delegate = parser
		return xmlParser.parse() ? FinancialSummary(
			totalRevenues: parser.totalRevenues,
			dividendPerShares: parser.dividendPerShares,
			eps: parser.eps,
			dividends: parser.dividends
		) : nil
	}

	public func parser(
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

	public func parser(_ parser: XMLParser, foundCharacters string: String) {
		currentValue += string.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	public func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName: String?
	) {
		guard !currentValue.isEmpty else { return }

		if let date = DateFormatter.iso8601.date(from: currentAttributes["asofDate"] ?? ""),
		   let value = Double(currentValue) {
			let entry = FinancialFact(
				reportType: currentAttributes["reportType"] ?? "",
				currency: currentCurrency,
				value: value,
				date: date,
				period: currentAttributes["period"] ?? ""
			)

			switch elementName {
			case "TotalRevenue": totalRevenues.append(entry)
			case "DividendPerShare": dividendPerShares.append(entry)
			case "EPS": eps.append(entry)
			default: break
			}
			
		} else if elementName == "Dividend",
				  let exDate = DateFormatter.iso8601.date(from: currentAttributes["exDate"] ?? ""),
				  let recordDate = DateFormatter.iso8601.date(from: currentAttributes["recordDate"] ?? ""),
				  let payDate = DateFormatter.iso8601.date(from: currentAttributes["payDate"] ?? ""),
				  let declarationDate = DateFormatter.iso8601.date(from: currentAttributes["declarationDate"] ?? ""),
				  let value = Double(currentValue) {
			let dividend = Dividend(
				type: currentAttributes["type"] ?? "",
				currency: currentCurrency,
				value: value,
				exDate: exDate,
				recordDate: recordDate,
				payDate: payDate,
				declarationDate: declarationDate
			)
			dividends.append(dividend)
		}

		currentValue = ""
	}
}
