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
    
    private var ratesInfo: [String: CurrencyData]?
    private var currencies = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        targetCurrencyLabel.adjustsFontSizeToFitWidth = true
        
        getRates()
        
    }
    
    // MARK: UIPickerViewDelegate, UIPickerViewDataSource
    
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
        pickerWasUpdated()
    }
    
    // MARK: ConverterViewController private methods
    
    private func pickerWasUpdated() {
        let baseCurrencyIndex = currencyPickerView.selectedRow(inComponent: 0)
        let targetCurrencyIndex = currencyPickerView.selectedRow(inComponent: 1)
                
        let baseCurrency = currencies[baseCurrencyIndex].lowercased()
        let targetCurrency = currencies[targetCurrencyIndex].lowercased()
        
        updateBaseLabels(with: baseCurrency)
        updateTargetLabels(with: targetCurrency, from: baseCurrency)
        
    }
    
    private func updateBaseLabels(with baseCurrency: String) {
        baseCurrencyLabel.text = "1" + (
            ratesInfo?[baseCurrency]?.unit ?? ""
        )
        
        baseCurrencyName.text = ratesInfo?[baseCurrency]?.name
    }
    
    private func updateTargetLabels(with targetCurrency: String, from baseCurrency: String) {
        targetCurrencyName.text = ratesInfo?[targetCurrency]?.name
        
        let targetValue = getTargetRatio(for: targetCurrency, from: baseCurrency)
        
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
    
    private func getTargetRatio(for targetCurrency: String, from baseCurrency: String) -> Double {
        let baseCurrencyValue = ratesInfo?[baseCurrency]?.value ?? 1
        let targetCurrencyValue = ratesInfo?[targetCurrency]?.value ?? 1
        
        return targetCurrencyValue / baseCurrencyValue
    }
    
    // MARK: Networking
    
    private func getRates() {
        NetworkManager.shared.getRatesInfo(from: Link.rates.rawValue) { [weak self] result in
            switch result {
            case .success(let info):
                self?.ratesInfo = info
                self?.currencies = self?.ratesInfo?.map { $0.key }.sorted() ?? [""]
                
                self?.activityIndicator.stopAnimating()
                
                self?.currencyPickerView.reloadAllComponents()
                self?.pickerWasUpdated()
            case .failure(let error):
//                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.baseCurrencyName.text = error.localizedDescription
                    self?.targetCurrencyName.text = ""
//                }
                print(error)
            }
        }
    }

}

