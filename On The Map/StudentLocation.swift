//
//  StudentLocation.swift
//  On The Map
//
//  Created by Kevin Bradwick on 15/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation
import CoreLocation

class StudentLocation : NSObject {
    
    var objectId: String!
    var uniqueKey: String!
    var latitude: Double!
    var longitude: Double!
    var firstName: String!
    var lastName: String!
    var mediaUrl: NSURL?
    var mapString: String!
    var location: CLLocation!
    var fullName: String!
    
    init(locationDict: [String: AnyObject]) {
        
        objectId = locationDict["objectId"] as! String
        uniqueKey = locationDict["uniqueKey"] as! String
        latitude = locationDict["latitude"] as! Double
        longitude = locationDict["longitude"] as! Double
        firstName = locationDict["firstName"] as! String
        lastName = locationDict["lastName"] as! String
        mapString = locationDict["mapString"] as! String
        
        fullName = "\(firstName) \(lastName)"
        
        // media url is optional incase the creation of NSURL fails
        if let url = locationDict["mediaURL"] as? String {
            mediaUrl = NSURL(string: url)
        }
        
        // create the CLLocation so that it can be placed on the map
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
}