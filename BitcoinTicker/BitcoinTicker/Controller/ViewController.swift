//
//  ViewController.swift
//  BitcoinTicker
//

import UIKit
import Alamofire
import SwiftyJSON

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    // **********************************************************************
    
    /// Bitcoin price label.
    @IBOutlet private weak var bitcoinPriceLabel: UILabel!
    
    /// The curency picker.
    @IBOutlet weak var currencyPicker: UIPickerView!

    
    // MARK: Properties
    // **********************************************************************
    
    /// Base URL.
    private let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    /// Array of currencies.
    private let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR",
                              "ILS","INR","JPY","MXN","NOK","NZD","PLN","RON",
                              "RUB","SEK","SGD","USD","ZAR"]
    
    /// Array of symbols of currencies.
    private let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp",
                                   "₪", "₹", "¥", "$", "kr", "$", "zł", "lei",
                                   "₽", "kr", "$", "$", "R"]
    
    /// Final URL.
    private var finalURL = ""
    
    /// Current index of selected currency.
    private var currentIdx = 0
    
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    //MARK: Networking
    // **********************************************************************
    
    /// Get bitcoin data from the final url.
    ///
    /// - Parameters:
    ///     - url: The final URL to fetch the bitcoin data.
    private func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let bitCoinPriceJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitCoinPriceJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
    
    //MARK: JSON Parsing
    // **********************************************************************
    
    /// Update bitcoint data.
    ///
    /// - Parameters:
    ///     - json: The JSON data fetched from the final URL.
    private func updateBitcoinData(json : JSON) {
        if let bitcoinPrice = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySymbols[currentIdx])\(bitcoinPrice)"
        } else {
            bitcoinPriceLabel.text = "Unavailable"
        }
    }
}

// MARK: - ViewController: UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
}

// MARK: - ViewController: UIPickerViewDelegate {

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIdx = row
        finalURL = baseURL + currencies[row]
        getBitcoinData(url: finalURL)
    }
}
