//
//  ViewController.swift
//  WeatherApp
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

// MARK: - WeatherViewController: UIViewController

class WeatherViewController: UIViewController {
    
    // MARK: Outlets
    // **********************************************************************
    
    /// The weather icon image.
    @IBOutlet private weak var weatherIcon: UIImageView!
    
    /// The label to display a city name.
    @IBOutlet private weak var cityLabel: UILabel!
    
    /// The label to display a temperature.
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    /// The switch to toggle between Fahrenheit and Celcius.
    @IBOutlet private weak var temperatureSwitch: UISwitch!
    
    // MARK: Properties
    // **********************************************************************
    
    /// The constant wrapper to access constants.
    private enum Constant {
         /// The weather URL to get weather data.
        static let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
        
        /// The application id registed with the API.
        static let APP_ID = "448d82201a0317285f944480e60b2ff6"
        
        /// The kelvin constant.
        static let KELVIN = 273.16
    }
    
    /// The location manager.
    private let locationManager = CLLocationManager()
    
    /// The weather data model.
    private var weatherDataModel = WeatherDataModel()
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: Networking
    // **********************************************************************
    
    /// Get weather data from the network.
    ///
    /// - Parameters:
    ///     - url: The url string to send the request.
    ///     - paramters: The parameters to send with the request.
    private func getWeatherData(url: String, parameters:[String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    // MARK: JSON Parsing
    // **********************************************************************
    
    /// Update weather data using the response data from the network.
    ///
    /// - Parameters:
    ///     - json: The JSON data got from the network.
    private func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - Constant.KELVIN)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    // MARK: UI Updates
    // **********************************************************************
    
    /// Update the UI with the weather data.
    private func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        _switchTemperature()
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    // MARK: Actions
    // **********************************************************************
    
    /// Switch temperature Fahrenheit <-> Celcius.
    @IBAction private func switchTemperature() {
        _switchTemperature()
    }
    
    // MARK: Others
    // **********************************************************************
    
    /// Main function to switch temperature Fahrenheit <-> Celcius.
    private func _switchTemperature() {
        // if switch is on, temperature is in Fahrenheit
        if temperatureSwitch.isOn {
            let fah = Int(Double(weatherDataModel.temperature) * 1.8 + 32.0)
            temperatureLabel.text = "\(fah)°"
            
            // otherwise, temperature is in Celcius
        } else {
            temperatureLabel.text = "\(weatherDataModel.temperature)°"
        }
    }
    
}

// MARK: - WeatherViewController: ClLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            manager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params = ["lat": latitude, "lon": longitude, "appid": Constant.APP_ID]
            SVProgressHUD.show()
            getWeatherData(url: Constant.WEATHER_URL, parameters: params)
            SVProgressHUD.dismiss()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unvailable"
    }
}

// MARK: - WeatherViewController: ChangeCityDelegate

extension WeatherViewController: ChangeCityDelegate {
    
    func userEnteredANewCityName(_ city: String) {
        let params = ["q": city, "appid": Constant.APP_ID]
        getWeatherData(url: Constant.WEATHER_URL, parameters: params)
    }
    
}

// MARK: - WeatherViewController (Transition)

extension WeatherViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
}
