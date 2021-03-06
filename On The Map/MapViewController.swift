//
//  MapViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 14/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: ViewController, CLLocationManagerDelegate, ParseServiceDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {        
        // parse service
        parseService.delegate = self
        parseService.loadStudentLocations()
        
        mapView.delegate = self
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
    
    // MARK: - MapView
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "location")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        
        return view
    }
    
    /*!
        Launch the students url in safari
    */
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        UIApplication.sharedApplication().openURL(NSURL(string: view.annotation.subtitle!)!)
    }
    
    /*!
        Reloads all the map data
    */
    @IBAction func reloadMapData() {
        parseService.loadStudentLocations()
    }
    
    // MARK: ParserService delegate methods
    
    func parseService(service: ParseService, didLoadLocations locations: [StudentInformation]) {
        
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
}
