//
//  ChangeCityViewController.swift
//  WeatherApp
//

import UIKit

// MARK: - Protocol

protocol ChangeCityDelegate {
    /// The delegate will call this function when a user entered a new city
    /// name.
    ///
    /// - Parameters:
    ///     - city: The new city name.
    func userEnteredANewCityName(_ city: String)
}

// MARK: - ChangeCityViewController: UIViewController

class ChangeCityViewController: UIViewController {
    
    // MARK: Outlets
    // **********************************************************************
    
    /// The city text field.
    @IBOutlet private weak var changeCityTextField: UITextField!

    // MARK: Properties
    // **********************************************************************
    
    /// The delage of ChangeCityViewController.
    weak var delegate: (UIViewController & ChangeCityDelegate)?
    
    // MARK: Actions
    // **********************************************************************
    
    /// Press get weather button.
    ///
    /// - Parameters:
    ///     - sender: The get weather button.
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        let cityName = changeCityTextField.text!
        delegate?.userEnteredANewCityName(cityName)
        dismiss(animated: true, completion: nil)
    }
    
    /// Press back button.
    ///
    /// - Parameters:
    ///     - sender: The back button.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
