//
//  IBExchange.swift
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


public enum IBExchange: String, Codable {	
	
	/// Interactive Brokers Smart Routing seeks the best firm price and to immediately execute an order electronically
	case SMART 					= "SMART"
	
	/// Bolsa de Valores de San Paulo
	case BOVESPA 				= "BOVESP"
	
	/// Bolsa de Mercadorias and Futuros
	case BMF 					= "BMF"
	
	/// TSX Venture Exchange
	case VENTURE 				= "VENTUR"
	
	/// TriAct Canada
	case TRIACT 				= "TRIACT"
	
	/// TradeWeb - Municipal Bonds
	case TRADEWEBM 				= "TRADEWEBM"
	
	/// TradeWeb - Government Bonds
	case TRADEWEBG				= "TRADEWEBG"
	
	/// TradeWeb - Corporate Bonds
	case TRADEWEB 				= "TRADEWEB"
	
	/// TrackECN
	case TRACKECN 				= "TRACKE"
	
	/// Toronto Stock Exchange
	case TSE 					= "TSE"
	
	/// Surge Trading
	case SURGE 					= "SURGE"
	
	/// SunTrading
	case SUNTRADE 				= "SUNTRA"
	
	/// Quadriserv
	case AQS 					= "AQS"
	
	/// Pure Trading
	case PURE 					= "PURE"
	
	/// Pink Sheets
	case PINK 					= "PINK"
	
	/// Philadelphia Stock Exchange
	case PHLX 					= "PHLX"
	
	/// Philadelphia Board of Trade
	case PBOT 					= "PBOT"
	
	/// Pacific Exchange
	case PSE 					= "PSE"
	
	/// OTC Bulletin Board
	case OTCBB 					= "OTCBB"
	
	/// OneChicago EFP
	case ONEEFP 				= "ONEEFP"
	
	/// OneChicago
	case ONE 					= "ONE"
	
	/// OMEGA ATS
	case OMEGA 					= "OMEGA"
	
	/// NYSE Liffe US
	case NYSELIFFE 				= "NYSELI"
	
	/// NYSE Arca
	case ARCA 					= "ARCA"
	
	/// New York Stock Exchange
	case NYSE 					= "NYSE"
	
	/// New York Mercantile Exchange - Floor
	case NYMEXF 				= "NYMEXF"
	
	/// New York Mercantile Exchange
	case NYMEX 					= "NYMEX"
	
	/// National Stock Exchange
	case NSX 					= "NSX"
	
	/// Nasdaq Stock Exchange
	case NASDAQ 				= "NASDAQ"
	
	/// Nasdaq Options Market
	case NASDAQOM 				= "NASDAQM"
	
	/// Mutual Fund Holding Venue
	case FUNDSERV 				= "FUNDSE"
	
	/// MuniCenter Municipal Bonds
	case MUNICENTM 				= "MUNICENTM"
	
	/// MuniCenter
	case MUNICENTR 				= "MUNICENTR"
	
	/// Montreal Stock Exchange
	case MNTRL 					= "MNTRL"
	
	/// Montreal Exchange
	case CDE 					= "CDE"
	
	/// Mexican Stock Exchange
	case MEXI 					= "MEXI"
	
	/// Mexican Derivatives Exchange
	case MEXDER 				= "MEXDER"
	
	/// Liquidnet
	case DARK1 					= "DARK1"
	
	/// Lava Trading
	case LAVA 					= "LAVA"
	
	/// Knight ValueBond - Government Bonds
	case VALUBONDG 				= "VALUBO"
	
	/// Knight Trading OTCBB and Pink Sheets
	case NITE 					= "NITE"
	
	/// Knight Trading ECN
	case NITEECN 				= "NITEEC"
	
	/// Knight BondPoint - Municipal Bonds
	case VALUBONDM 				= "VALUBONDM"
	
	/// Knight BondPoint - Corporate Bonds
	case VALUBOND 				= "VALUBOND"
	
	/// Island ECN
	@available(*, deprecated, message: "Please use NASDAQ instead")
	case ISLAND 				= "ISLAND"
	
	/// International Securities Exchange
	case ISE 					= "ISE"
	
	/// Internal Basket Stocks
	case BASKET 				= "BASKET"
	
	/// IntercontinentalExchange - NYFE Division
	case NYFE 					= "NYFE"
	
	/// IntercontinentalExchange - NYBOT Division
	case NYBOT 					= "NYBOT"
	
	/// IntercontinentalExchange - IPE Division
	case IPE 					= "IPE"
	
	/// IntercontinentalExchange
	case ICEUS 					= "ICEUS"
	
	/// Interactive Brokers Bond
	case IBBOND 				= "IBBOND"
	
	/// IDEAL for Canadian Stocks
	case IDEALCAD 				= "IDEALC"
	
	/// IDEAL Currency Dealing
	case IDEALFX 				= "IDEALF"
	
	/// IB Value Exchange
	case VALUE 					= "VALUE"
	
	/// IB Forex PRO
	case IDEALPRO 				= "IDEALPRO"
	
	/// IB Forex
	case IDEAL 					= "IDEAL"
	
	/// ELX Futures
	case ELX 					= "ELX"
	
	/// Electronic Chicago Mercantile Exchange
	case GLOBEX 				= "GLOBEX"
	
	/// Electronic Chicago Board of Trade
	case ECBOT 					= "ECBOT"
	
	/// Direct Edge Indication Of Interest
	case DRCTIOI 				= "DRCTIO"
	
	/// Direct Edge ECN LLC
	case DRCTEDGE 				= "DRCTED"
	
	/// Direct Edge ECN
	case EDGEA 					= "EDGEA"
	
	/// CSFB CrossFinder
	case CSFBCROSS 				= "CSFBCR"
	
	/// CME Advanced Option System
	case CMEEOS 				= "CMEEOS"
	
	/// Cincinnati Stock Exchange
	case CSE 					= "CSE"
	
	/// Chicago Stock Exchange
	case CHX 					= "CHX"
	
	/// Chicago Mercantile Exchange
	case CME 					= "CME"
	
	/// Chicago Board Options Exchange - Binary Options
	case CBOEB 					= "CBOEB"
	
	/// Chicago Board Options Exchange
	case CBOE 					= "CBOE"
	
	/// Chicago Board of Trade
	case CBOT 					= "CBOT"
	
	/// CHI-X Canada ATS Limited
	case CHIX_CA 				= "CHIX_CA"
	
	/// CBOE Stock Exchange
	case CBSX 					= "CBSX"
	
	/// CBOE Futures Exchange
	case CFE 					= "CFE"
	
	/// bTrade ECN
	case BTRADE 				= "BTRADE"
	
	/// Boston Stock Exchange
	case BSE 					= "BSE"
	
	/// Boston Options Exchange
	case BOX 					= "BOX"
	
	/// Boston Equities Exchange
	case BEX 					= "BEX"
	
	/// BATS Trading
	case BATS 					= "BATS"
	
	/// Automated Trade Desk
	case ATD 					= "ATD"
	
	/// ArcaEdge Alternative Trading
	case ARCAEDGE 				= "ARCAED"
	
	/// American Stock Exchange - Binary Options
	case AMEXB 					= "AMEXB"
	
	/// American Stock Exchange
	case AMEX 					= "AMEX"
	
	/// Zagreb Stock Exchange
	case ZSE_HRV 				= "ZSE.HR"
	
	/// Xetra International Market - Spanish Segment
	case XETIES 				= "XETIES"
	
	/// Xetra International Market - Italy Segment
	case XETIIT 				= "XETIIT"
	
	/// Xetra International Market - Finland Segment
	case XETIFI 				= "XETIFI"
	
	/// Xetra International Market - Euronext Segment
	case XETIEN 				= "XETIEN"
	
	/// Xetra
	case IBIS 					= "IBIS"
	
	/// Winterfloods Securities Limited
	case WINNER 				= "WINNER"
	
	/// Warsaw Stock Exchange
	case WSE 					= "WSE"
	
	/// VIRT-X UK
	case VIRTXUK 				= "VIRTXU"
	
	/// VIRT-X
	case VIRTX 					= "VIRTX"
	
	/// Vienna Exchange - Warrants
	case VSEW 					= "VSEW"
	
	/// Vienna Exchange - Stocks
	case VSE	 				= "VSE"
	
	/// Vienna Exchange - Futures & Options
	case OTOB 					= "OTOB"
	
	/// Turquoise Europe - United Kingdom
	case TRQXUK 				= "TRQXUK"
	
	/// Turquoise Europe - Switzerland
	case TRQXCH 				= "TRQXCH"
	
	/// Turquoise Europe - Sweden 2
	case TRQXSE 				= "TRQXSE"
	
	/// Turquoise Europe - Sweden
	case TRQXSK 				= "TRQXSK"
	
	/// Turquoise Europe - Spain
	case TRQXES 				= "TRQXES"
	
	/// Turquoise Europe - Norway
	case TRQXNO 				= "TRQXNO"
	
	/// Turquoise Europe - Italy
	case TRQXIT 				= "TRQXIT"
	
	/// Turquoise Europe - Ireland
	case TRQXIR 				= "TRQXIR"
	
	/// Turquoise Europe - Germany
	case TRQXDE 				= "TRQXDE"
	
	/// Turquoise Europe - Finland
	case TRQXFI 				= "TRQXFI"
	
	/// Turquoise Europe - EN
	case TRQXEN 				= "TRQXEN"
	
	/// Turquoise Europe - Denmark
	case TRQXDK 				= "TRQXDK"
	
	/// Turquoise Europe - Austria
	case TRQXAT 				= "TRQXAT"
	
	/// TIQS Stuttgart
	case TIQSSWB				= "TIQSSW"
	
	/// SWX Swiss Exchange
	case EBS 					= "EBS"
	
	/// Stuttgart Stock Exchange
	case SWB 					= "SWB"
	
	/// Stockholm Binary Options Exchange
	case OMSB 					= "OMSB"
	
	/// Spanish Futures &amp; Options Exchange
	case MEFFRV 				= "MEFFRV"
	
	/// Prague Stock Exchange
	case PRA 					= "PRA"
	
	/// Oslo Exchange - Stocks
	case OSE 					= "OSE"
	
	/// Oslo Exchange - Derivatives
	case OMLX 					= "OMLX"
	
	/// OMX Riga Stock Exchange
	case RFB 					= "RFB"
	
	/// OMX Nordic Exchange - Swedish Stocks
	case SFB 					= "SFB"
	
	/// OMX Nordic Exchange - Swedish Derivatives
	case OMS 					= "OMS"
	
	/// OMX Nordic Exchange - Lithuanian Stocks
	case VVPB 					= "VVPB"
	
	/// OMX Nordic Exchange - Iceland Stocks
	case ICEX 					= "ICEX"
	
	/// OMX Nordic Exchange - Helsinki Derivatives
	case OMH 					= "OMH"
	
	/// OMX Nordic Exchange - Finnish Stocks
	case HEX 					= "HEX"
	
	/// OMX Nordic Exchange - Danish Stocks
	case CPH 					= "CPH"
	
	/// OMX Nordic Exchange - Danish Derivatives
	case OMC 					= "OMC"
	
	/// NASDAQ OMX Europe UK
	case NUROUK 				= "NUROUK"
	
	/// NASDAQ OMX Europe Switzerland
	case NUROCH 				= "NUROCH"
	
	/// NASDAQ OMX Europe Sweden
	case NUROSW 				= "NUROSW"
	
	/// NASDAQ OMX Europe Norway
	case NURONO 				= "NURONO"
	
	/// NASDAQ OMX Europe Italy
	case NUROIT 				= "NUROIT"
	
	/// NASDAQ OMX Europe Germany
	case NURODE 				= "NURODE"
	
	/// NASDAQ OMX Europe Finland
	case NUROFI 				= "NUROFI"
	
	/// NASDAQ OMX Europe EN
	case NUROEN		 			= "NUROEN"
	
	/// NASDAQ OMX Europe Denmark
	case NURODK 				= "NURODK"
	
	/// NASDAQ OMX Europe Austria
	case NUROAT 				= "NUROAT"
	
	/// Moscow Stock Exchange
	case RTS 					= "RTS"
	
	/// Moscow Interbank Currency Exchange
	case MICEX 					= "MICEX"
	
	/// Mercado Espanol de Futuros Financieros Renta Variable
	case MEFF		 			= "MEFF"
	
	/// Mercado Espanol de Futuros Financieros Renta Fija
	case MEFF_RF 				= "MEFF_RF"
	
	/// Malta Stock Exchange
	case BTM 					= "BTM"
	
	/// Madrid Stock Exchange
	case BM 					= "BM"
	
	/// Luxembourg Stock Exchange
	case LUX 					= "LUX"
	
	/// London Stock Exchange
	case LSE 					= "LSE"
	
	/// London Stock Exchange ETF
	case LSEETF					= "LSEETF"
	
	/// London Metals Exchange
	case LME 					= "LME"
	
	/// London International Financial Futures Exchange
	case LIFFE 					= "LIFFE"
	
	/// Ljubljana Stock Exchange
	case LJSE 					= "LJSE"
	
	/// LIFFE Single Stock Futures Division
	case LSSF 					= "LSSF"
	
	/// LIFFE Commodities
	case LIFFE_NF 				= "LIFFE_NF"
	
	/// Italian Exchange - Stocks
	case BVME 					= "BVME"
	
	/// Italian Exchange - Derivatives
	case IDEM 					= "IDEM"
	
	/// Istanbul Stock Exchange
	case IST 					= "IST"
	
	/// Irish Stock Exchange
	case ISED 					= "ISED"
	
	/// ICAP Inter Dealer Broker
	case ICAP 					= "ICAP"
	
	/// Frankfurt Stock Exchange
	case FWB 					= "FWB"
	
	/// EUROSETS Dutch Trading Service
	case EUSETSNL 				= "EUSETS"
	
	/// Euronext Paris - Stocks
	case SBF 					= "SBF"
	
	/// Euronext Paris - Interest Rate/Commodity Derivatives
	case MATIF 					= "MATIF"
	
	/// Euronext Paris - Equity/Index Derivatives
	case MONEP 					= "MONEP"
	
	/// Euronext Lisbon - Stocks
	case BVL 					= "BVL"
	
	/// Euronext Brussels - Stocks
	case ENEXT_BE 				= "ENEXT.BE"
	
	/// Euronext Brussels - Derivatives
	case BELFOX 				= "BELFOX"
	
	/// Euronext Amsterdam - Stocks
	case AEB 					= "AEB"
	
	/// Euronext Amsterdam - Derivatives
	case FTA 					= "FTA"
	
	/// Eurex Switzerland
	case SOFFEX 				= "SOFFEX"
	
	/// Eurex Germany
	case DTB 					= "DTB"
	
	/// EDX Norway
	case EDXNO 					= "EDXNO"
	
	/// Cyprus Stock Exchange
	case CYSE 					= "CYSE"
	
	/// CHI-X Europe Ltd Sweden
	case CHIXSW 				= "CHIXSW"
	
	/// CHI-X Europe Ltd Norway
	case CHIXNO 				= "CHIXNO"
	
	/// CHI-X Europe Ltd Italy
	case CHIXIT 				= "CHIXIT"
	
	/// CHI-X Europe Ltd Finland
	case CHIXFI 				= "CHIXFI"
	
	/// CHI-X Europe Ltd Denmark
	case CHIXDK 				= "CHIXDK"
	
	/// CHI-X Europe Ltd Crest
	case CHIXUK 				= "CHIXUK"
	
	/// CHI-X Europe Ltd Clearstream
	case CHIXDE 				= "CHIXDE"
	
	/// CHI-X Europe Ltd Clearnet
	case CHIXEN 				= "CHIXEN"
	
	/// CHI-X Europe Ltd Austria
	case CHIXAT 				= "CHIXAT"
	
	/// Budapest Stock Exchange
	case BUX	 				= "BUX"
	
	/// Bucharest Stock Exchange
	case BVB	 				= "BVB"
	
	/// Bratislava Stock Exchange
	case BRA 					= "BRA"
	
	/// Bolsa de derivados do Portugal
	case BDP 					= "BDP"
	
	/// BATS Trading Limited UK
	case BATEUK 				= "BATEUK"
	
	/// BATS Trading Limited Switzerland
	case BATECH 				= "BATECH"
	
	/// BATS Trading Limited Sweden
	case BATESW 				= "BATESW"
	
	/// BATS Trading Limited Norway
	case BATENO 				= "BATENO"
	
	/// BATS Trading Limited Italy
	case BATEIT 				= "BATEIT"
	
	/// BATS Trading Limited Germany
	case BATEDE 				= "BATEDE"
	
	/// BATS Trading Limited Finland
	case BATEFI 				= "BATEFI"
	
	/// BATS Trading Limited EN
	case BATEEN 				= "BATEEN"
	
	/// BATS Trading Limited Denmark
	case BATEDK 				= "BATEDK"
	
	/// Athens Stock Exchange
	case ATH 					= "ATH"
	
	/// Tokyo Stock Exchange 2
	case TSEJ 					= "TSEJ"
	
	/// Tokyo Stock Exchange
	case TSE_JPN 				= "TSE.JPN"
	
	/// Tokyo Financial Exchange
	case TIFFE 					= "TIFFE"
	
	/// Taiwan Stock Exchange
	case TAI 					= "TAI"
	
	/// Taiwan Futures Exchange
	case TAIFEX 				= "TAIFEX"
	
	/// Stock Exchange of Hong Kong
	case SEHK 					= "SEHK"
	
	/// Singapore Exchange - CME
	case SGXCME 				= "SGXCME"
	
	/// Singapore Exchange
	case SGX 					= "SGX"
	
	/// Shenzhen Stock Exchange
	case SZSE 					= "SZSE"
	
	/// Shanghai Stock Exchange
	case SHSE 					= "SHSE"
	
	/// Osaka Stock Exchange
	case OSEJPN 				= "OSEJPN"
	
	/// Osaka Securities Exchange 2
	case OSEJ 					= "OSEJ"
	
	/// Osaka Securities Exchange
	case OSE_JPN 				= "OSE.JPN"
	
	/// National Stock Exchange of India Limited
	case NSE 					= "NSE"
	
	/// Kosdaq Securities Exchange Inc
	case KOSDAQ 				= "KOSDAQ"
	
	/// Korea Stock Exchange
	case KSE 					= "KSE"
	
	/// JASDAQ Securities Exchange
	case JASDAQ			 		= "JASDAQ"
	
	/// Hong Kong Stock Exchange - Derivatives
	case HKFE 					= "HKFE"
	
	/// Hong Kong Mercantile Exchange
	case HKMEX 					= "HKMEX"
	
	/// Bombay Stock Exchange
	case BSEI 					= "BSEI"
	
	/// Australian Securities Exchange
	case ASX 					= "ASX"
	
	/// Australian Derivatives Exchange
	case ADX 					= "ADX"
	
	/// Johannesburg Securities Exchange
	case JSE 					= "JSE"
	
	/// Paxos -regulated blockchain infrastructure platform
	case PAXOS					= "PAXOS"
	
	/// Eurex
	case EUREX					= "EUREX"
	
	case IBKRATS				= "IBKRATS"
	
	case BEST					= "BEST"


}


extension IBExchange: CustomStringConvertible {
	
	public var description:String {
		switch self {
			case .SMART:		return  "IB SMART Routing"
			case .BOVESPA:	 	return  "Bolsa de Valores de San Paulo"
			case .BMF: 			return  "Bolsa de Mercadorias and Futuros"
			case .VENTURE: 		return  "TSX Venture Exchange"
			case .TRIACT: 		return  "TriAct Canada"
			case .TRADEWEBM: 	return  "TradeWeb - Municipal Bonds"
			case .TRADEWEBG: 	return  "TradeWeb - Government Bonds"
			case .TRADEWEB: 	return  "TradeWeb - Corporate Bonds"
			case .TRACKECN: 	return  "TrackECN"
			case .TSE: 			return  "Toronto Stock Exchange"
			case .SURGE: 		return  "Surge Trading"
			case .SUNTRADE: 	return  "SunTrading"
			case .AQS: 			return  "Quadriserv"
			case .PURE: 		return  "Pure Trading"
			case .PINK: 		return  "Pink Sheets"
			case .PHLX: 		return  "Philadelphia Stock Exchange"
			case .PBOT: 		return  "Philadelphia Board of Trade"
			case .PSE: 			return  "Pacific Exchange"
			case .OTCBB: 		return  "OTC Bulletin Board"
			case .ONEEFP: 		return  "OneChicago EFP"
			case .ONE: 			return  "OneChicago"
			case .OMEGA: 		return  "OMEGA ATS"
			case .NYSELIFFE: 	return  "NYSE Liffe US"
			case .ARCA: 		return  "NYSE Arca"
			case .NYSE: 		return  "New York Stock Exchange"
			case .NYMEXF: 		return  "New York Mercantile Exchange - Floor"
			case .NYMEX: 		return  "New York Mercantile Exchange"
			case .NSX: 			return  "National Stock Exchange"
			case .NASDAQ: 		return  "Nasdaq Stock Exchange"
			case .NASDAQOM: 	return  "Nasdaq Options Market"
			case .FUNDSERV: 	return  "Mutual Fund Holding Venue"
			case .MUNICENTM: 	return  "MuniCenter Municipal Bonds"
			case .MUNICENTR: 	return  "MuniCenter"
			case .MNTRL:		return  "Montreal Stock Exchange"
			case .CDE:			return  "Montreal Exchange"
			case .MEXI:			return  "Mexican Stock Exchange"
			case .MEXDER:		return  "Mexican Derivatives Exchange"
			case .DARK1:		return  "Liquidnet"
			case .LAVA:			return  "Lava Trading"
			case .VALUBONDG:	return  "Knight ValueBond - Government Bonds"
			case .NITE:			return  "Knight Trading OTCBB and Pink Sheets"
			case .NITEECN:		return  "Knight Trading ECN"
			case .VALUBONDM:	return  "Knight BondPoint - Municipal Bonds"
			case .VALUBOND:		return  "Knight BondPoint - Corporate Bonds"
			case .ISLAND:		return  "Island ECN"
			case .ISE:			return  "International Securities Exchange"
			case .BASKET:		return  "Internal Basket Stocks"
			case .NYFE:			return  "IntercontinentalExchange - NYFE Division"
			case .NYBOT:		return  "IntercontinentalExchange - NYBOT Division"
			case .IPE:			return  "IntercontinentalExchange - IPE Division"
			case .ICEUS:		return  "IntercontinentalExchange"
			case .IBBOND:		return  "Interactive Brokers Bond"
			case .IDEALCAD:		return  "IDEAL for Canadian Stocks"
			case .IDEALFX:		return  "IDEAL Currency Dealing"
			case .VALUE:		return  "IB Value Exchange"
			case .IDEALPRO:		return  "IB Forex PRO"
			case .IDEAL:		return  "IB Forex"
			case .ELX:			return  "ELX Futures"
			case .GLOBEX:		return  "Electronic Chicago Mercantile Exchange"
			case .ECBOT:		return  "Electronic Chicago Board of Trade"
			case .DRCTIOI:		return  "Direct Edge Indication Of Interest"
			case .DRCTEDGE:		return  "Direct Edge ECN LLC"
			case .EDGEA:		return  "Direct Edge ECN"
			case .CSFBCROSS:	return  "CSFB CrossFinder"
			case .CMEEOS:		return  "CME Advanced Option System"
			case .CSE:			return  "Cincinnati Stock Exchange"
			case .CHX:			return  "Chicago Stock Exchange"
			case .CME:			return  "Chicago Mercantile Exchange"
			case .CBOEB:		return  "Chicago Board Options Exchange - Binary Options"
			case .CBOE:			return  "Chicago Board Options Exchange"
			case .CBOT:			return  "Chicago Board of Trade"
			case .CHIX_CA:		return  "CHI-X Canada ATS Limited"
			case .CBSX:			return  "CBOE Stock Exchange"
			case .CFE:			return  "CBOE Futures Exchange"
			case .BTRADE:		return  "bTrade ECN"
			case .BSE:			return  "Boston Stock Exchange"
			case .BOX:			return  "Boston Options Exchange"
			case .BEX:			return  "Boston Equities Exchange"
			case .BATS:			return  "BATS Trading"
			case .ATD:			return  "Automated Trade Desk"
			case .ARCAEDGE:		return  "ArcaEdge Alternative Trading"
			case .AMEXB:		return  "American Stock Exchange - Binary Options"
			case .AMEX:			return  "American Stock Exchange"
			case .ZSE_HRV:		return  "Zagreb Stock Exchange"
			case .XETIES:		return  "Xetra International Market - Spanish Segment"
			case .XETIIT:		return  "Xetra International Market - Italy Segment"
			case .XETIFI:		return  "Xetra International Market - Finland Segment"
			case .XETIEN:		return  "Xetra International Market - Euronext Segment"
			case .IBIS:			return  "Xetra"
			case .WINNER:		return  "Winterfloods Securities Limited"
			case .WSE:			return  "Warsaw Stock Exchange"
			case .VIRTXUK:		return  "VIRT-X UK"
			case .VIRTX:		return  "VIRT-X"
			case .VSEW:			return  "Vienna Exchange - Warrants"
			case .VSE:			return  "Vienna Exchange - Stocks"
			case .OTOB:			return  "Vienna Exchange - Futures &amp; Options"
			case .TRQXUK:		return  "Turquoise Europe - United Kingdom"
			case .TRQXCH:		return  "Turquoise Europe - Switzerland"
			case .TRQXSE:		return  "Turquoise Europe - Sweden 2"
			case .TRQXSK:		return  "Turquoise Europe - Sweden"
			case .TRQXES:		return  "Turquoise Europe - Spain"
			case .TRQXNO:		return  "Turquoise Europe - Norway"
			case .TRQXIT:		return  "Turquoise Europe - Italy"
			case .TRQXIR:		return  "Turquoise Europe - Ireland"
			case .TRQXDE:		return  "Turquoise Europe - Germany"
			case .TRQXFI:		return  "Turquoise Europe - Finland"
			case .TRQXEN:		return  "Turquoise Europe - EN"
			case .TRQXDK:		return  "Turquoise Europe - Denmark"
			case .TRQXAT:		return  "Turquoise Europe - Austria"
			case .TIQSSWB: 		return  "TIQS Stuttgart"
			case .EBS:			return  "SWX Swiss Exchange"
			case .SWB:			return  "Stuttgart Stock Exchange"
			case .OMSB:			return  "Stockholm Binary Options Exchange"
			case .MEFFRV:		return  "Spanish Futures &amp; Options Exchange"
			case .PRA:			return  "Prague Stock Exchange"
			case .OSE:			return  "Oslo Exchange - Stocks"
			case .OMLX:			return  "Oslo Exchange - Derivatives"
			case .RFB:			return  "OMX Riga Stock Exchange"
			case .SFB:			return  "OMX Nordic Exchange - Swedish Stocks"
			case .OMS:			return  "OMX Nordic Exchange - Swedish Derivatives"
			case .VVPB:			return  "OMX Nordic Exchange - Lithuanian Stocks"
			case .ICEX:			return  "OMX Nordic Exchange - Iceland Stocks"
			case .OMH:			return  "OMX Nordic Exchange - Helsinki Derivatives"
			case .HEX:			return  "OMX Nordic Exchange - Finnish Stocks"
			case .CPH:			return  "OMX Nordic Exchange - Danish Stocks"
			case .OMC:			return  "OMX Nordic Exchange - Danish Derivatives"
			case .NUROUK:		return  "NASDAQ OMX Europe UK"
			case .NUROCH:		return  "NASDAQ OMX Europe Switzerland"
			case .NUROSW:		return  "NASDAQ OMX Europe Sweden"
			case .NURONO:		return  "NASDAQ OMX Europe Norway"
			case .NUROIT:		return  "NASDAQ OMX Europe Italy"
			case .NURODE:		return  "NASDAQ OMX Europe Germany"
			case .NUROFI:		return  "NASDAQ OMX Europe Finland"
			case .NUROEN:		return  "NASDAQ OMX Europe EN"
			case .NURODK:		return  "NASDAQ OMX Europe Denmark"
			case .NUROAT:		return  "NASDAQ OMX Europe Austria"
			case .RTS:			return  "Moscow Stock Exchange"
			case .MICEX:		return  "Moscow Interbank Currency Exchange"
			case .MEFF:			return  "Mercado Espanol de Futuros Financieros Renta Variable"
			case .MEFF_RF:		return  "Mercado Espanol de Futuros Financieros Renta Fija"
			case .BTM:			return  "Malta Stock Exchange"
			case .BM:			return  "Madrid Stock Exchange"
			case .LUX:			return  "Luxembourg Stock Exchange"
			case .LSE:			return  "London Stock Exchange"
			case .LSEETF:		return 	"LSE ETF"
			case .LME:			return  "London Metals Exchange"
			case .LIFFE:		return  "London International Financial Futures Exchange"
			case .LJSE:			return  "Ljubljana Stock Exchange"
			case .LSSF:			return  "LIFFE Single Stock Futures Division"
			case .LIFFE_NF:		return  "LIFFE Commodities"
			case .BVME:			return  "Italian Exchange - Stocks"
			case .IDEM:			return  "Italian Exchange - Derivatives"
			case .IST:			return  "Istanbul Stock Exchange"
			case .ISED:			return  "Irish Stock Exchange"
			case .ICAP:			return  "ICAP Inter Dealer Broker"
			case .FWB:			return  "Frankfurt Stock Exchange"
			case .EUSETSNL:		return  "EUROSETS Dutch Trading Service"
			case .SBF:			return  "Euronext Paris - Stocks"
			case .MATIF:		return  "Euronext Paris - Interest Rate/Commodity Derivatives"
			case .MONEP:		return  "Euronext Paris - Equity/Index Derivatives"
			case .BVL:			return  "Euronext Lisbon - Stocks"
			case .ENEXT_BE:		return  "Euronext Brussels - Stocks"
			case .BELFOX:		return  "Euronext Brussels - Derivatives"
			case .AEB:			return  "Euronext Amsterdam - Stocks"
			case .FTA:			return  "Euronext Amsterdam - Derivatives"
			case .SOFFEX:		return  "Eurex Switzerland"
			case .DTB:			return  "Eurex Germany"
			case .EDXNO:		return  "EDX Norway"
			case .CYSE:			return  "Cyprus Stock Exchange"
			case .CHIXSW:		return  "CHI-X Europe Ltd Sweden"
			case .CHIXNO:		return  "CHI-X Europe Ltd Norway"
			case .CHIXIT:		return  "CHI-X Europe Ltd Italy"
			case .CHIXFI:		return  "CHI-X Europe Ltd Finland"
			case .CHIXDK:		return  "CHI-X Europe Ltd Denmark"
			case .CHIXUK:		return  "CHI-X Europe Ltd Crest"
			case .CHIXDE:		return  "CHI-X Europe Ltd Clearstream"
			case .CHIXEN:		return  "CHI-X Europe Ltd Clearnet"
			case .CHIXAT:		return  "CHI-X Europe Ltd Austria"
			case .BUX:			return  "Budapest Stock Exchange"
			case .BVB:			return  "Bucharest Stock Exchange"
			case .BRA:			return  "Bratislava Stock Exchange"
			case .BDP:			return  "Bolsa de derivados do Portugal"
			case .BATEUK:		return  "BATS Trading Limited UK"
			case .BATECH:		return  "BATS Trading Limited Switzerland"
			case .BATESW:		return  "BATS Trading Limited Sweden"
			case .BATENO:		return  "BATS Trading Limited Norway"
			case .BATEIT:		return  "BATS Trading Limited Italy"
			case .BATEDE:		return  "BATS Trading Limited Germany"
			case .BATEFI:		return  "BATS Trading Limited Finland"
			case .BATEEN:		return  "BATS Trading Limited EN"
			case .BATEDK:		return  "BATS Trading Limited Denmark"
			case .ATH:			return  "Athens Stock Exchange"
			case .TSEJ:			return  "Tokyo Stock Exchange 2"
			case .TSE_JPN:		return  "Tokyo Stock Exchange"
			case .TIFFE:		return  "Tokyo Financial Exchange"
			case .TAI:			return  "Taiwan Stock Exchange"
			case .TAIFEX:		return  "Taiwan Futures Exchange"
			case .SEHK:			return  "Stock Exchange of Hong Kong"
			case .SGXCME:		return  "Singapore Exchange - CME"
			case .SGX:			return  "Singapore Exchange"
			case .SZSE:			return  "Shenzhen Stock Exchange"
			case .SHSE:			return  "Shanghai Stock Exchange"
			case .OSEJPN:		return  "Osaka Stock Exchange"
			case .OSEJ:			return  "Osaka Securities Exchange 2"
			case .OSE_JPN:		return  "Osaka Securities Exchange"
			case .NSE:			return  "National Stock Exchange of India Limited"
			case .KOSDAQ:		return  "Kosdaq Securities Exchange Inc"
			case .KSE:			return  "Korea Stock Exchange"
			case .JASDAQ:		return  "JASDAQ Securities Exchange"
			case .HKFE:			return  "Hong Kong Stock Exchange - Derivatives"
			case .HKMEX:		return  "Hong Kong Mercantile Exchange"
			case .BSEI:			return  "Bombay Stock Exchange"
			case .ASX:			return  "Australian Securities Exchange"
			case .ADX:			return  "Australian Derivatives Exchange"
			case .JSE:			return  "Johannesburg Securities Exchange"
			case .PAXOS:		return	"Paxos"
			case .EUREX:		return  "EUREX"
			case .IBKRATS:		return "IBKRATS"
			case .BEST:			return "BEST"

		}
	}
	
	public var identifier: String? {
		switch self {
			case .SMART:		return  "IB SMART Routing"
			case .BOVESPA:	 	return  "Bolsa de Valores de San Paulo"
			case .BMF: 			return  "Bolsa de Mercadorias and Futuros"
			case .VENTURE: 		return  "TSX Venture Exchange"
			case .TRIACT: 		return  "TriAct Canada"
			case .TRADEWEBM: 	return  "TradeWeb - Municipal Bonds"
			case .TRADEWEBG: 	return  "TradeWeb - Government Bonds"
			case .TRADEWEB: 	return  "TradeWeb - Corporate Bonds"
			case .TRACKECN: 	return  "TrackECN"
			case .TSE: 			return  "Toronto Stock Exchange"
			case .SURGE: 		return  "Surge Trading"
			case .SUNTRADE: 	return  "SunTrading"
			case .AQS: 			return  "Quadriserv"
			case .PURE: 		return  "Pure Trading"
			case .PINK: 		return  "Pink Sheets"
			case .PHLX: 		return  "Philadelphia Stock Exchange"
			case .PBOT: 		return  "Philadelphia Board of Trade"
			case .PSE: 			return  "Pacific Exchange"
			case .OTCBB: 		return  "OTC Bulletin Board"
			case .ONEEFP: 		return  "OneChicago EFP"
			case .ONE: 			return  "OneChicago"
			case .OMEGA: 		return  "OMEGA ATS"
			case .NYSELIFFE: 	return  "NYSE Liffe US"
			case .ARCA: 		return  "NYSE Arca"
			case .NYSE: 		return  "New York Stock Exchange"
			case .NYMEXF: 		return  "New York Mercantile Exchange - Floor"
			case .NYMEX: 		return  "New York Mercantile Exchange"
			case .NSX: 			return  "National Stock Exchange"
			case .NASDAQ: 		return  "Nasdaq Stock Exchange"
			case .NASDAQOM: 	return  "Nasdaq Options Market"
			case .FUNDSERV: 	return  "Mutual Fund Holding Venue"
			case .MUNICENTM: 	return  "MuniCenter Municipal Bonds"
			case .MUNICENTR: 	return  "MuniCenter"
			case .MNTRL:		return  "Montreal Stock Exchange"
			case .CDE:			return  "Montreal Exchange"
			case .MEXI:			return  "Mexican Stock Exchange"
			case .MEXDER:		return  "Mexican Derivatives Exchange"
			case .DARK1:		return  "Liquidnet"
			case .LAVA:			return  "Lava Trading"
			case .VALUBONDG:	return  "Knight ValueBond - Government Bonds"
			case .NITE:			return  "Knight Trading OTCBB and Pink Sheets"
			case .NITEECN:		return  "Knight Trading ECN"
			case .VALUBONDM:	return  "Knight BondPoint - Municipal Bonds"
			case .VALUBOND:		return  "Knight BondPoint - Corporate Bonds"
			case .ISLAND:		return  "Island ECN"
			case .ISE:			return  "International Securities Exchange"
			case .BASKET:		return  "Internal Basket Stocks"
			case .NYFE:			return  "IntercontinentalExchange - NYFE Division"
			case .NYBOT:		return  "IntercontinentalExchange - NYBOT Division"
			case .IPE:			return  "IntercontinentalExchange - IPE Division"
			case .ICEUS:		return  "IntercontinentalExchange"
			case .IBBOND:		return  "Interactive Brokers Bond"
			case .IDEALCAD:		return  "IDEAL for Canadian Stocks"
			case .IDEALFX:		return  "IDEAL Currency Dealing"
			case .VALUE:		return  "IB Value Exchange"
			case .IDEALPRO:		return  "IB Forex PRO"
			case .IDEAL:		return  "IB Forex"
			case .ELX:			return  "ELX Futures"
			case .GLOBEX:		return  "Electronic Chicago Mercantile Exchange"
			case .ECBOT:		return  "Electronic Chicago Board of Trade"
			case .DRCTIOI:		return  "Direct Edge Indication Of Interest"
			case .DRCTEDGE:		return  "Direct Edge ECN LLC"
			case .EDGEA:		return  "Direct Edge ECN"
			case .CSFBCROSS:	return  "CSFB CrossFinder"
			case .CMEEOS:		return  "CME Advanced Option System"
			case .CSE:			return  "Cincinnati Stock Exchange"
			case .CHX:			return  "Chicago Stock Exchange"
			case .CME:			return  "Chicago Mercantile Exchange"
			case .CBOEB:		return  "Chicago Board Options Exchange - Binary Options"
			case .CBOE:			return  "Chicago Board Options Exchange"
			case .CBOT:			return  "Chicago Board of Trade"
			case .CHIX_CA:		return  "CHI-X Canada ATS Limited"
			case .CBSX:			return  "CBOE Stock Exchange"
			case .CFE:			return  "CBOE Futures Exchange"
			case .BTRADE:		return  "bTrade ECN"
			case .BSE:			return  "Boston Stock Exchange"
			case .BOX:			return  "Boston Options Exchange"
			case .BEX:			return  "Boston Equities Exchange"
			case .BATS:			return  "BATS Trading"
			case .ATD:			return  "Automated Trade Desk"
			case .ARCAEDGE:		return  "ArcaEdge Alternative Trading"
			case .AMEXB:		return  "American Stock Exchange - Binary Options"
			case .AMEX:			return  "American Stock Exchange"
			case .ZSE_HRV:		return  "Zagreb Stock Exchange"
			case .XETIES:		return  "Xetra International Market - Spanish Segment"
			case .XETIIT:		return  "Xetra International Market - Italy Segment"
			case .XETIFI:		return  "Xetra International Market - Finland Segment"
			case .XETIEN:		return  "Xetra International Market - Euronext Segment"
			case .IBIS:			return  "Xetra"
			case .WINNER:		return  "Winterfloods Securities Limited"
			case .WSE:			return  "Warsaw Stock Exchange"
			case .VIRTXUK:		return  "VIRT-X UK"
			case .VIRTX:		return  "VIRT-X"
			case .VSEW:			return  "Vienna Exchange - Warrants"
			case .VSE:			return  "Vienna Exchange - Stocks"
			case .OTOB:			return  "Vienna Exchange - Futures &amp; Options"
			case .TRQXUK:		return  "Turquoise Europe - United Kingdom"
			case .TRQXCH:		return  "Turquoise Europe - Switzerland"
			case .TRQXSE:		return  "Turquoise Europe - Sweden 2"
			case .TRQXSK:		return  "Turquoise Europe - Sweden"
			case .TRQXES:		return  "Turquoise Europe - Spain"
			case .TRQXNO:		return  "Turquoise Europe - Norway"
			case .TRQXIT:		return  "Turquoise Europe - Italy"
			case .TRQXIR:		return  "Turquoise Europe - Ireland"
			case .TRQXDE:		return  "Turquoise Europe - Germany"
			case .TRQXFI:		return  "Turquoise Europe - Finland"
			case .TRQXEN:		return  "Turquoise Europe - EN"
			case .TRQXDK:		return  "Turquoise Europe - Denmark"
			case .TRQXAT:		return  "Turquoise Europe - Austria"
			case .TIQSSWB: 		return  "TIQS Stuttgart"
			case .EBS:			return  "SWX Swiss Exchange"
			case .SWB:			return  "Stuttgart Stock Exchange"
			case .OMSB:			return  "Stockholm Binary Options Exchange"
			case .MEFFRV:		return  "Spanish Futures &amp; Options Exchange"
			case .PRA:			return  "Prague Stock Exchange"
			case .OSE:			return  "Oslo Exchange - Stocks"
			case .OMLX:			return  "Oslo Exchange - Derivatives"
			case .RFB:			return  "OMX Riga Stock Exchange"
			case .SFB:			return  "OMX Nordic Exchange - Swedish Stocks"
			case .OMS:			return  "OMX Nordic Exchange - Swedish Derivatives"
			case .VVPB:			return  "OMX Nordic Exchange - Lithuanian Stocks"
			case .ICEX:			return  "OMX Nordic Exchange - Iceland Stocks"
			case .OMH:			return  "OMX Nordic Exchange - Helsinki Derivatives"
			case .HEX:			return  "OMX Nordic Exchange - Finnish Stocks"
			case .CPH:			return  "OMX Nordic Exchange - Danish Stocks"
			case .OMC:			return  "OMX Nordic Exchange - Danish Derivatives"
			case .NUROUK:		return  "NASDAQ OMX Europe UK"
			case .NUROCH:		return  "NASDAQ OMX Europe Switzerland"
			case .NUROSW:		return  "NASDAQ OMX Europe Sweden"
			case .NURONO:		return  "NASDAQ OMX Europe Norway"
			case .NUROIT:		return  "NASDAQ OMX Europe Italy"
			case .NURODE:		return  "NASDAQ OMX Europe Germany"
			case .NUROFI:		return  "NASDAQ OMX Europe Finland"
			case .NUROEN:		return  "NASDAQ OMX Europe EN"
			case .NURODK:		return  "NASDAQ OMX Europe Denmark"
			case .NUROAT:		return  "NASDAQ OMX Europe Austria"
			case .RTS:			return  "Moscow Stock Exchange"
			case .MICEX:		return  "Moscow Interbank Currency Exchange"
			case .MEFF:			return  "Mercado Espanol de Futuros Financieros Renta Variable"
			case .MEFF_RF:		return  "Mercado Espanol de Futuros Financieros Renta Fija"
			case .BTM:			return  "Malta Stock Exchange"
			case .BM:			return  "Madrid Stock Exchange"
			case .LUX:			return  "Luxembourg Stock Exchange"
			case .LSE:			return  "London Stock Exchange"
			case .LSEETF:		return 	"LSE ETF"
			case .LME:			return  "London Metals Exchange"
			case .LIFFE:		return  "London International Financial Futures Exchange"
			case .LJSE:			return  "Ljubljana Stock Exchange"
			case .LSSF:			return  "LIFFE Single Stock Futures Division"
			case .LIFFE_NF:		return  "LIFFE Commodities"
			case .BVME:			return  "Italian Exchange - Stocks"
			case .IDEM:			return  "Italian Exchange - Derivatives"
			case .IST:			return  "Istanbul Stock Exchange"
			case .ISED:			return  "Irish Stock Exchange"
			case .ICAP:			return  "ICAP Inter Dealer Broker"
			case .FWB:			return  "Frankfurt Stock Exchange"
			case .EUSETSNL:		return  "EUROSETS Dutch Trading Service"
			case .SBF:			return  "Euronext Paris - Stocks"
			case .MATIF:		return  "Euronext Paris - Interest Rate/Commodity Derivatives"
			case .MONEP:		return  "Euronext Paris - Equity/Index Derivatives"
			case .BVL:			return  "Euronext Lisbon - Stocks"
			case .ENEXT_BE:		return  "Euronext Brussels - Stocks"
			case .BELFOX:		return  "Euronext Brussels - Derivatives"
			case .AEB:			return  "Euronext Amsterdam - Stocks"
			case .FTA:			return  "Euronext Amsterdam - Derivatives"
			case .SOFFEX:		return  "Eurex Switzerland"
			case .DTB:			return  "Eurex Germany"
			case .EDXNO:		return  "EDX Norway"
			case .CYSE:			return  "Cyprus Stock Exchange"
			case .CHIXSW:		return  "CHI-X Europe Ltd Sweden"
			case .CHIXNO:		return  "CHI-X Europe Ltd Norway"
			case .CHIXIT:		return  "CHI-X Europe Ltd Italy"
			case .CHIXFI:		return  "CHI-X Europe Ltd Finland"
			case .CHIXDK:		return  "CHI-X Europe Ltd Denmark"
			case .CHIXUK:		return  "CHI-X Europe Ltd Crest"
			case .CHIXDE:		return  "CHI-X Europe Ltd Clearstream"
			case .CHIXEN:		return  "CHI-X Europe Ltd Clearnet"
			case .CHIXAT:		return  "CHI-X Europe Ltd Austria"
			case .BUX:			return  "Budapest Stock Exchange"
			case .BVB:			return  "Bucharest Stock Exchange"
			case .BRA:			return  "Bratislava Stock Exchange"
			case .BDP:			return  "Bolsa de derivados do Portugal"
			case .BATEUK:		return  "BATS Trading Limited UK"
			case .BATECH:		return  "BATS Trading Limited Switzerland"
			case .BATESW:		return  "BATS Trading Limited Sweden"
			case .BATENO:		return  "BATS Trading Limited Norway"
			case .BATEIT:		return  "BATS Trading Limited Italy"
			case .BATEDE:		return  "BATS Trading Limited Germany"
			case .BATEFI:		return  "BATS Trading Limited Finland"
			case .BATEEN:		return  "BATS Trading Limited EN"
			case .BATEDK:		return  "BATS Trading Limited Denmark"
			case .ATH:			return  "Athens Stock Exchange"
			case .TSEJ:			return  "Tokyo Stock Exchange 2"
			case .TSE_JPN:		return  "Tokyo Stock Exchange"
			case .TIFFE:		return  "Tokyo Financial Exchange"
			case .TAI:			return  "Taiwan Stock Exchange"
			case .TAIFEX:		return  "Taiwan Futures Exchange"
			case .SEHK:			return  "Stock Exchange of Hong Kong"
			case .SGXCME:		return  "Singapore Exchange - CME"
			case .SGX:			return  "Singapore Exchange"
			case .SZSE:			return  "Shenzhen Stock Exchange"
			case .SHSE:			return  "Shanghai Stock Exchange"
			case .OSEJPN:		return  "Osaka Stock Exchange"
			case .OSEJ:			return  "Osaka Securities Exchange 2"
			case .OSE_JPN:		return  "Osaka Securities Exchange"
			case .NSE:			return  "National Stock Exchange of India Limited"
			case .KOSDAQ:		return  "Kosdaq Securities Exchange Inc"
			case .KSE:			return  "Korea Stock Exchange"
			case .JASDAQ:		return  "JASDAQ Securities Exchange"
			case .HKFE:			return  "Hong Kong Stock Exchange - Derivatives"
			case .HKMEX:		return  "Hong Kong Mercantile Exchange"
			case .BSEI:			return  "Bombay Stock Exchange"
			case .ASX:			return  "Australian Securities Exchange"
			case .ADX:			return  "Australian Derivatives Exchange"
			case .JSE:			return  "Johannesburg Securities Exchange"
			case .PAXOS:		return	"Paxos"
			case .EUREX:		return	"Eurex"
			case .IBKRATS:		return "IBKrats"
			case .BEST:			return "Best"
		}
	}
	
	public var micCode: String?{
		switch self{
		case .NASDAQ: 	return "XNAS"
		case .NYSE: 	return "XNYS"
		case .IBIS: 	return "XETR"
		case .AEB: 		return "XAMS"
		case .BM: 		return "XMAD"
		case .HEX: 		return "XHEL"
		case .LSE: 		return "XLON"
		case .SBF: 		return "XPAR"
		case .FTA: 		return "XFRA"
		case .CME: 		return "XCME"
		case .CBOE: 	return "XCBO"
		case .CBOT: 	return "XCBT"
		case .GLOBEX: 	return "GLBX"
		case .EUREX:	return "XEUR"
		case .BVME:		return "XMIL"
		case .SFB:		return "XSTO"
		case .CPH:		return "XCSE"
		case .OSE:		return "XOSL"
		case .BVL:		return "XLIS"
		case .ENEXT_BE:	return "XBRU"
		case .ISED:		return "XDUB"
		case .EBS:		return "XSWX"
		case .VSE:		return "XWBO"
		case .BATS:		return "BATS"
		default: 		return nil
		}
	}
	
	public init?(micCode: String){
		
		switch micCode{
		case "XNAS": 	self = .NASDAQ
		case "XNYS":	self = .NYSE
		case "XETR":	self = .IBIS
		case "XAMS":	self = .AEB
		case "XMAD":	self = .BM
		case "XHEL":	self = .HEX
		case "XLON":	self = .LSE
		case "XPAR":	self = .SBF
		case "XFRA":	self = .FTA
		case "XCME":	self = .CME
		case "XCBO":	self = .CBOE
		case "XCBT":	self = .CBOT
		case "GLBX":	self = .GLOBEX
		case "XEUR":	self = .EUREX
		case "XMIL":	self = .BVME
		case "XSTO":	self = .SFB
		case "XCSE":	self = .CPH
		case "XOSL":	self = .OSE
		case "XLIS":	self = .BVL
		case "XBRU":	self = .ENEXT_BE
		case "XDUB":	self = .ISED
		case "XSWX":	self = .EBS
		case "XWBO":	self = .VSE
		case "BATS":	self = .BATS
		default: 		return nil
		}
		
	}
	
}
