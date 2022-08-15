//
//  Fetcher.swift
//  CompanyInfo
//
//  Created by Ilya Kozhevnikov on 09.08.2022.
//
import Foundation
import Alamofire

enum Link: String {
    case rates = "https://api.coingecko.com/api/v3/exchange_rates"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getRatesInfo(from link: String, completion: @escaping(Result<[String: CurrencyData], AFError>) -> Void) {
        AF.request(link)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let info = RatesData.getRates(from: value)
                    completion(.success(info))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
