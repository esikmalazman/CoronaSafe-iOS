//
//  VirusManager.swift
//  Covid-19 App
//
//  Created by Ikmal Azman on 28/02/2021.
//


import Foundation

//create protocol to parse data to view controller
protocol VirusManagerDelegate
{
    func didUpdateInfo(_ virusManager : VirusManager,virus : VirusModel)
    func didFailWithError(error: Error)
}

struct  VirusManager
{
    var delegate : VirusManagerDelegate?
    
    //api url
    let virusURL = "https://disease.sh/v3/covid-19/countries/"
    
    func fetchCountry(countryName : String)
    {
        let urlString = "\(virusURL)\(countryName)?strict=true"
        print(urlString)
        //send url to perform request
        performRequest(with: urlString)
    }
    
    //extend capabilites of fetch country , fetch with country code , swift allow same fucntion name but need different parameters name
    func fetchCountry(countryCode :  String)
    {
        let urlString = "\(virusURL)\(countryCode)?strict=true"
        performRequest(with: urlString)
    }
    
    //function that will do networking
    func performRequest(with urlString : String)
    {
        //1.create url object
        if let url = URL(string: urlString)
        {
            //2. create url session , object do networking
            let session = URLSession(configuration: .default)
            
            //3. give url session a task , like put url in browser and give it task to do
            
            
            // Method 1 , withhout closures
            
            //            let task = session.dataTask(with: url, completionHandler: handler(data:response:error:))
            
            //Method 2 , with closures
            let task = session.dataTask(with: url, completionHandler :
                                            {
                                                (data : Data?, response : URLResponse?, error : Error?) -> Void
                                                
                                                in
                                                
                                                if error != nil
                                                {
                                                    print(error)
                                                    self.delegate?.didFailWithError(error: error!)
                                
                                                }
                                                else
                                                
                                                if let safeData = data
                                                {
                                                    //convert data to text
                                                    let dataString = String(data: safeData, encoding: .utf8)
                                                    print(dataString)
                                                    
                                                    //pass data form safe data to parseJSON
                                                    //assing function with model output to variable
                                                    if let virus = self.parseJSON(safeData)
                                                    {
                                                        //send data to view controller via delegate
                                                        self.delegate?.didUpdateInfo(self, virus: virus)
                                                    }
                                                }
                                                
                                                
                                            }
            )
            
            //start the task
            task.resume()
        }
    }
    
    // translate json to swift objects
    //make function to be output to make it can assign in variable
    func parseJSON(_ virusData : Data) -> VirusModel?
    {
        //create a translater (decoder)
        //object that decode JSON
        let decoder = JSONDecoder()
        do{
            
            //ues try , if something wrong it can throws error
            
        let decodedData = try decoder.decode(VirusData.self, from: virusData)
            print(decodedData.active)
            print(decodedData.country)
            
            //capture the output
            let country = decodedData.country
            let continent = decodedData.continent
            let active = decodedData.active
            let cases = decodedData.cases
            let deaths = decodedData.deaths
            let recover = decodedData.recovered
            
            //assign data to virus model
            let virusModel = VirusModel(countryName: country, totalCases: cases, totalDeaths: deaths, totalRecovered: recover, totalActive: active, countryContinent: continent)
            
            return virusModel
        }
        catch
        {
            self.delegate?.didFailWithError(error: error)
            //catch error
            print(error)
            return nil
        }
    }
    
    //return data from data task
//    func handler(data : Data?, response : URLResponse?, error : Error?) -> Void
//    {
//        if error != nil
//        {
//            print(error)
//        }
//        else
//
//        if let safeData = data
//        {
//            //convert data to text
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(safeData)
//        }
//    }
}
