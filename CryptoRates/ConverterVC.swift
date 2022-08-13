//
//  ViewController.swift
//  CryptoRates
//
//  Created by Ilya Kozhevnikov on 09.08.2022.
//
import UIKit

class ConverterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    @IBOutlet weak var baseCurrencyName: UILabel!
    @IBOutlet weak var targetCurrencyName: UILabel!
    
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    
    var ratesInfo: [String: CurrencyData]?
    var currencies = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        targetCurrencyLabel.adjustsFontSizeToFitWidth = true
        
        getRates()
        
    }
    
    private func getRates() {
        NetworkManager.shared.getRatesInfo(from: Link.rates.rawValue) { [weak self] result in
            switch result {
            case .success(let info):
                self?.ratesInfo = info.rates
                self?.currencies = self?.ratesInfo?.map { $0.key }.sorted() ?? [""]
                self?.activityIndicator.stopAnimating()
                self?.currencyPickerView.reloadAllComponents()
                self?.updateTargetValue()
            case .failure(let error):
                print(error)
                self?.ratesInfo = nil
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTargetValue()
    }
    
    func updateTargetValue() {
        let baseCurrencyIndex = currencyPickerView.selectedRow(inComponent: 0)
        let targetCurrencyIndex = currencyPickerView.selectedRow(inComponent: 1)
                
        let baseCurrency = currencies[baseCurrencyIndex].lowercased()
        let targetCurrency = currencies[targetCurrencyIndex].lowercased()
        
        baseCurrencyLabel.text = "1" + (
            ratesInfo?[baseCurrency]?.unit ?? ""
        )
        
        baseCurrencyName.text = ratesInfo?[baseCurrency]?.name
        targetCurrencyName.text = ratesInfo?[targetCurrency]?.name
        
        
        let baseCurrencyValue = ratesInfo?[baseCurrency]?.value ?? 1
        let targetCurrencyValue = ratesInfo?[targetCurrency]?.value ?? 1
        
        let targetValue = targetCurrencyValue / baseCurrencyValue
        
        var targetCurrencyAmountText = String(format: "%.2f", targetValue)
        
        if targetValue < 0.000001 {
            targetCurrencyAmountText = String(format: "%.9f", targetValue)
        }
        else if targetValue < 0.0001 {
            targetCurrencyAmountText = String(format: "%.6f", targetValue)
        }
        else if targetValue < 1 {
            targetCurrencyAmountText = String(format: "%.4f", targetValue)
        } else if targetValue >= 1000 || baseCurrency == targetCurrency {
            targetCurrencyAmountText = String(format: "%.0f", targetValue)
        }
        
        targetCurrencyLabel.text = targetCurrencyAmountText + (ratesInfo?[targetCurrency]?.unit ?? "")
        
        
    }

}

