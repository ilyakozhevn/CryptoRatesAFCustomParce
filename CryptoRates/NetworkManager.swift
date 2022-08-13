//
//  Fetcher.swift
//  CompanyInfo
//
//  Created by Ilya Kozhevnikov on 09.08.2022.
//
import Foundation

enum Link: String {
    case rates = "https://api.coingecko.com/api/v3/exchange_rates"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getRatesInfo(from link: String, completion: @escaping(Result<RatesData, NetworkError>) -> Void) {
        guard let url = URL(string: link) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.global().async {
                do {
                    let info = try JSONDecoder().decode(RatesData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(info))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            
            
        }.resume()
    }
    
}
