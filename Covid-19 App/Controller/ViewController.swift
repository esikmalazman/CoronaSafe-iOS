//
//  ViewController.swift
//  Covid-19 App
//
//  Created by Ikmal Azman on 27/02/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController
{

    let date = Date()
    
    //create object from core location manager class
    var locationManager = CLLocationManager()
    
    //vairus manager object
    var virusManager = VirusManager()
    
    @IBOutlet weak var searchCountryLabel: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    @IBOutlet weak var deathsCasesLabel: UILabel!
    @IBOutlet weak var recoveredCasesLabel: UILabel!
    @IBOutlet weak var activeCasesLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
   
//    //combine mulitple view with one ib outlet
    @IBOutlet var collection : [UIView]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchCountryLabel.delegate = self
        // Do any additional setup after loading the view.
        
        
        // set self as delegate
        virusManager.delegate = self
        
        // set self as delegate for CLL
        locationManager.delegate = self
        
        //request permission to get location
        locationManager.requestWhenInUseAuthorization()
        //request current user location , for one time only
        locationManager.requestLocation()
        
        //get current users date ,(days,month,year)
        print(date.string(format: "EEEE, d MMM, yyyy"))
        
        let currentDate = date.string(format: "EEEE, d MMM, yyyy")
        //set date label
        dateLabel.text = currentDate
        
    }

    @IBAction func appearanceButtonPressed(_ sender: UIButton)
    {
        //validate if user iphone is on ios 13
        if #available(iOS 13.0, *)
        {
            //changer user apperance
            if overrideUserInterfaceStyle == .dark
            {
                overrideUserInterfaceStyle = .light
            }
            else
            {
                overrideUserInterfaceStyle = .dark
            }
        }
        searchCountryLabel.endEditing(true)
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton)
    {
        print (searchCountryLabel.text!)
        //dismiss keyboard
        searchCountryLabel.endEditing(true)
    }
    
    
}

//MARK:- UITexFieldDelegate
extension ViewController : UITextFieldDelegate
{
    //UITextFieldDelegate method
    
    //validation , prevent null value in textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        
        if textField.text != ""
        {
            return true
        }
        else
        {
            textField.placeholder = "Country?"
            return false
        }
    }
    
    // what is should do after end edit textfield
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //check if textfield is not nil, if have value assign it to country
        if let country = textField.text
        {
            //fetch country if value in textfield exist
            print(country)
            virusManager.fetchCountry(countryName: country)
            
        }
        //reset text after end editing
        searchCountryLabel.text = ""
    }
    
    //return text in texfield after user done editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print(searchCountryLabel.text!)
        searchCountryLabel.endEditing(true)
        return true
        
    }
}
//MARK:- VirusManagerDelegate
extension ViewController : VirusManagerDelegate
{
    //receive data from manager
    func didUpdateInfo(_ virusManager: VirusManager, virus: VirusModel)
    {
        print(virus.countryContinent)
        
        //update ui
        DispatchQueue.main.async
        {
            self.countryLabel.text = virus.countryName
            self.continentLabel.text = virus.countryContinent
            self.totalCasesLabel.text = virus.totalCasesString
            self.activeCasesLabel.text = virus.totalActiveString
            self.deathsCasesLabel.text = virus.totalDeathString
            self.recoveredCasesLabel.text = virus.totalRecoveredString
        }
    }
    
    
    //error handling method
    func didFailWithError(error: Error)
    {
        print(error)
    }
    
}
//MARK:- CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate
{
    @IBAction func locationButtonPressed(_ sender: UIButton)
    {
        //request location once user click this button
        locationManager.requestLocation()
    }
 
    
    
    
    

    //implement required method for CLL Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        print("Got Location")
       
        //get current user country geocode
        if let countryLocale = Locale.current.regionCode
        {
            //after get location, stop gps, get new one if location got triggered
            locationManager.stopUpdatingLocation()
            print(countryLocale)
            virusManager.fetchCountry(countryCode: countryLocale)
        }
       
//        print(locations[0])
        
    }
    //error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
}

//MARK:- Date Extension

//extend date function, adding formatting capabilities

extension Date
{
    //return string of date formatted using receiver's current settings
    func string(format:String) -> String
    {
        //formatter , object to convert date to text
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
