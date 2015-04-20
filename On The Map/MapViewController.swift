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

class MapViewController: ViewController, CLLocationManagerDelegate, ParseServiceDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {        
        // parse service
        parseService.delegate = self
        parseService.loadStudentLocations()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // center the map on the current device location.
        if (CLLocationManager.locationServicesEnabled()) {
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
            
            // we only need this once on load, so stop updating now
            locationManager.stopUpdatingLocation()
        }
    }
    
    /*!
        Reloads all the map data
    */
    @IBAction func reloadMapData() {
        parseService.loadStudentLocations()
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        println("Unwind Map Controller")
    }
    
    // MARK: ParserService delegate methods
    
    func parseService(service: ParseService, didLoadLocations locations: [StudentLocation]) {
        
        dispatch_async(dispatch_get_main_queue(), {
            // 1. remove all the pins from the map
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            // 2. add pins to the map
            for location in locations {
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.location.coordinate
                annotation.title = location.fullName
                if let url = location.mediaUrl {
                    annotation.subtitle = url.absoluteString!
                } else {
                    annotation.subtitle = location.mapString
                }
                
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    func parseService(service: ParseService, didError error: NSError) {
        println("Error: \(error.debugDescription)")
    }
}
