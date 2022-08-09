//
//  ViewController.swift
//  CryptoRates
//
//  Created by Ilya Kozhevnikov on 09.08.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Fetcher.getRatesInfo(from: "https://api.coingecko.com/api/v3/exchange_rates")
    }


}

