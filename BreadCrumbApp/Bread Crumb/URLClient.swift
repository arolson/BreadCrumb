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

}
