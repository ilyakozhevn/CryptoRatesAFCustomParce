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
        
        var currencies = [String: CurrencyData]()
        
        for currency in rates {
            guard let currencyData = currency.value as? [String: Any] else { return [:] }
            
            currencies[currency.key] = CurrencyData(
                name: currencyData["name"] as? String ?? "",
                unit: currencyData["unit"] as? String ?? "",
                value: currencyData["value"] as? Double ?? 0,
                type: currencyData["type"] as? String ?? ""
            )
        }

        return currencies
    }
}

struct CurrencyData: Decodable {
    let name: String
    let unit: String
    let value: Double
    let type: String
}
