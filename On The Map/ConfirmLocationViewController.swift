//
//  ConfirmLocationViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 17/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ConfirmLocationViewController: UIViewController, UITextViewDelegate, ParseServiceDelegate {

    @IBOutlet var textArea: UITextView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var defaultText = "Enter a link to share..."
    var location: CLPlacemark!
    
    let parseService = ParseService.sharedInstance()
    
    override func viewDidLoad() {
        
        let blue = UIColor(red: 88/255, green: 98/255, blue: 173/255, alpha: 1.0)
        
        self.view.backgroundColor = blue
        
        textArea.backgroundColor = blue
        textArea.font = UIFont(name: "Roboto-Regular", size: 20.0)
        textArea.textAlignment = NSTextAlignment.Center
        textArea.textColor = UIColor.whiteColor()
        textArea.text = defaultText
        textArea.delegate = self
        
        submitButton.layer.cornerRadius = 0
        submitButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16.0)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.backgroundColor = blue
        submitButton.contentEdgeInsets = UIEdgeInsetsMake(7.0, 15.0, 7.0, 15.0)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        mapView.centerCoordinate = location.location.coordinate
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        
        parseService.delegate = self
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textArea.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == defaultText {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = defaultText
        }
    }
    
    // MARK: - Parse Service
    
    func parseService(service: ParseService, didPostStudentLocation location: StudentInformation) {
        
        let alertController = UIAlertController(title: "Success", message: "Information posted!", preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TabController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
        
        alertController.addAction(okayAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    /*!
        If the posting of a service fails, present an alert controller and
    */
    func parseService(service: ParseService, didError error: NSError) {
        
        let alertController = UIAlertController(title: "Error", message: "An error occured posting your location. Retry sending location?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.saveMyLocation(alertController)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func parseService(service: ParseService, didLoadLocations locations: [StudentInformation]) {
        // do nothing
    }
    
    @IBAction func saveMyLocation(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // create the new StudentLocation
        let studentLocation = StudentInformation(student: appDelegate.student!, placemark: location,
            mapString: location.name, mediaUrl: textArea.text)
        
        parseService.postStudentLocation(studentLocation)
    }
}
