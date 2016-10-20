//
//  GooglePlacesTabelViewController.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/19/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import UIKit

class GooglePlacesTabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var GooglePlacesTableView: UITableView!
    
    var latitude: Double?
    var longitude: Double?
   
    
    var places = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Places"
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    func loadData()
    {
        let shareInstance = URLClient.getShareInstance()
        if let latitude = latitude, let longitude = longitude
        {
            shareInstance.findPlaces(view: self,latitude: latitude, longitude: longitude)
            {
                places in
                self.places = places
                performUIUpdatesOnMain(){
                    self.activityIndicator.stopAnimating()
                    self.GooglePlacesTableView.reloadData()
                }
                if places.count == 0
                {
                    self.displayErrorAlert(message: "There are no places to display.")
                }
            }
        }
        else
        {
            print("No Latitude or Longitude.")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0 {
        return places.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let name = places[indexPath.row]["name"] as! String
        cell.textLabel?.text = name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Did Select row")
        if let geometry = places[indexPath.row]["geometry"] as? NSDictionary {
            
            if let location = geometry["location"] as? NSDictionary {
            
               if let latitude = location["lat"] as? Double,
                let longitude = location["lng"] as? Double
               {
                    //open navigation for Places
                    print("\(latitude) , \(longitude)")
                    let urlString = "https://maps.apple.com/?daddr=\(latitude),\(longitude)"
                    let client = URLClient.getShareInstance()
                    client.openURL(urlString: urlString)
                }
            }
        }
        
    }
}
