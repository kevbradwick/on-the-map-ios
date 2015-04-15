//
//  MapViewController.swift
//  On The Map
//
//  See http://nevan.net/2014/09/core-location-manager-changes-in-ios-8/ for info on CLLocationManager
//
//  Created by Kevin Bradwick on 14/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. See if we already have the user's location
        
        // 2. If we do, centre the map
        
        // 3. If not, ask the user for permission
        
        // 4. If granted, center the map
        
        // 5. If denied, set default to UK
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (CLLocationManager.locationServicesEnabled()) {
            println("Location Services enabled")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func getUsersCurrentLocation() {
        
    }
    
    /*!
        Update the Map View with the current users location
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if let location = locations.last as? CLLocation {
            self.mapView.setCenterCoordinate(location.coordinate, animated: true)
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
}
