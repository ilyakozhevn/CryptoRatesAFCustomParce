//
//  Rates.swift
//  CryptoRates
//
//  Created by Ilya Kozhevnikov on 09.08.2022.
//

struct RatesData: Decodable {
    let rates: [String: CurrencyData]
}

struct CurrencyData: Decodable {
    let name: String
    let unit: String
    let value: Double
    let type: String
}
