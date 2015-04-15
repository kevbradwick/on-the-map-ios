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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (CLLocationManager.locationServicesEnabled()) {
            println("Location Services enabled")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
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
