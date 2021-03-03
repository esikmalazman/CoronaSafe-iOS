//
//  VirusModel.swift
//  Covid-19 App
//
//  Created by Ikmal Azman on 01/03/2021.
//


//place to store decode JSON into new variable
import Foundation

struct VirusModel
{
    let countryName : String
    let totalCases : Int
    let totalDeaths : Int
    let totalRecovered : Int
    let totalActive : Int
    let countryContinent : String
    
    //convert to string, easy process to assign to UILabel
    var totalCasesString : String
    {
        return "\(totalCases)"
    }
    
    var totalDeathString : String
    {
        return "\(totalDeaths)"
    }
    
    var totalRecoveredString : String
    {
        return "\(totalRecovered)"
    }
    
    var totalActiveString : String
    {
        return "\(totalActive)"
    }
    
    
}
