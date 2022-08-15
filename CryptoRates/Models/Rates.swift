//
//  Rates.swift
//  CryptoRates
//
//  Created by Ilya Kozhevnikov on 09.08.2022.
//

struct RatesData: Decodable {
    let rates: [String: CurrencyData]
    
    static func getRates(from value: Any) -> [String: CurrencyData] {
        guard let ratesData = value as? [String: Any] else { return [:] }
        guard let rates = ratesData["rates"] as? [String: Any] else { return [:] }
        
        var ratesOut = [String: CurrencyData]()
        
        for currency in rates {
            guard let currencyData = currency.value as? [String: Any] else { return [:] }
            guard let name = currencyData["name"] as? String else { return [:] }
            guard let unit = currencyData["unit"] as? String else { return [:] }
            guard let value = currencyData["value"] as? Double else { return [:] }
            guard let type = currencyData["type"] as? String else { return [:] }
            ratesOut[currency.key] = CurrencyData(name: name, unit: unit, value: value, type: type)
        }

        return ratesOut
    }
}

struct CurrencyData: Decodable {
    let name: String
    let unit: String
    let value: Double
    let type: String
}
