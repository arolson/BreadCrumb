//
//  URLClient.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/14/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import UIKit


class URLClient
{
    static let sharedInstance = URLClient()
    class func getShareInstance()->URLClient
    {
        return sharedInstance
    }
    enum URLStatus: String
    {
        case Success = "Success: "
        
        case Error = "Error: "
    }

    func openURL(urlString: String)
    {
        let app = UIApplication.shared
        guard app.openURL(URL(string: urlString)!)
        else
        {
            print("Not A URL!")
            return
        }
    }
    func findPlaces(view: UIViewController,latitude: Double , longitude: Double, handler: @escaping (_ places: [NSDictionary])->Void)
    {
        let parameters: [String: String] = [
            GooglePlacesParameterKeys.Api : GooglePlacesValueKeys.Api,
            GooglePlacesParameterKeys.Radius : GooglePlacesValueKeys.Radius,
            GooglePlacesParameterKeys.Location : "\(latitude),\(longitude)",
            GooglePlacesParameterKeys.OpenNow: GooglePlacesValueKeys.OpenNow
        ]
        let url = GooglePlacesURLFromParameters(parameters: parameters)
        print(url)
        let request = URLRequest(url: url)
        taskFromRequest(request: request)
        {
            data, error, message in
            if error == .Success
            {
                let parsedData = self.parseData(data: data)
                {
                    message in
                    print("Error: \(message)")
                }
               if let results = parsedData as? NSDictionary
               {
                
                if let places = results["results"] as? [NSDictionary]
                {
                   handler(places)
                }
               }
            }
            else
            {
                view.displayErrorAlert(message: error.rawValue + message)
               print(error.rawValue + message)
            }
        }
    }
    private func GooglePlacesURLFromParameters(parameters: [String:Any]) -> URL {
        
        var components = URLComponents()
        components.scheme = GooglePlaces.APIScheme
        components.host = GooglePlaces.APIHost
        components.path = GooglePlaces.APIPath
        components.queryItems = [URLQueryItem]()
        for (key , value) in parameters
        {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url!
    }
    func checkForErrors(data: Data?,response: URLResponse?,error: Error?)->String?
    {
        let displayError =
            {
                (s:String)->String in
                print(s)
                return s
        }
        /* GUARD: Was there an error? */
        guard (error == nil)
            else
        {
            return displayError("Error: \(error!.localizedDescription)")
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
            statusCode >= 200 && statusCode <= 299
        else
        {
            return displayError("Error: Your request returned a status code other than 2xx.")
        }
        
        /* GUARD: Was there any data returned? */
        guard data != nil
            else
        {
            return displayError("No data was returned by the request!")
        }
        return nil
    }
    func taskFromRequest(request: URLRequest?,completionHandler:@escaping (_ data:Data?,_ error: URLStatus,_ result: String)->Void)
    {
        let session = URLSession.shared
        if let request = request
        {
            let task = session.dataTask(with: request)
            {
                data, response, error in
                
                if let er = self.checkForErrors(data: data, response: response, error: error)
                {
                    
                    completionHandler(data,.Error,er)
                }
                else
                {
                    completionHandler(data,.Success,"Retrived Data")
                }
            }
            task.resume()
        }
    }
    //MARK: Parse Data
    func parseData(data: Data?,errorHandeler: (_ message: String)->Void)->Any
    {
        var parsedResult: Any!
        do
        {
            if let data = data
            {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }
            else
            {
                let message = "Data Retruned Empty!"
                errorHandeler(message)
                return message
            }
        }
        catch
        {
            print("Could not retrieve Data from parse:\n \(data)")
        }
        
        return parsedResult
        
    }
}
