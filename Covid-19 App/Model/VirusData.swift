//
//  VirusData.swift
//  Covid-19 App
//
//  Created by Ikmal Azman on 01/03/2021.
//


//inform compiler how data is structure from networking when it reads JSON
import Foundation
//translate to swift object from JSON
struct VirusData : Codable
{
    let country : String
    let cases : Int
    let deaths : Int
    let recovered : Int
    let active : Int
    let continent : String
    
    
}
