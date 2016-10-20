//
//  GooglePlacesConstants.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/18/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import UIKit

struct GooglePlaces {
    static let APIScheme = "https"
    static let APIHost = "maps.googleapis.com"
    static let APIPath = "/maps/api/place/nearbysearch/json"
}

// MARK: GooglePlaces Parameter Keys
struct GooglePlacesParameterKeys {
    static let Location = "location"
    static let Radius = "radius"
    static let Api = "key"
    static let OpenNow = "opennow"
}
// MARK: GooglePlaces Value Keys
struct GooglePlacesValueKeys {
    static let Radius = "500"
    static let Api = "AIzaSyDQOxt9ixiYxwkaIIkblh47JFAidO_l8JM"
    static let OpenNow = "1"
}
