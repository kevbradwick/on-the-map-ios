//
//  SelectLocationViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 16/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit
import CoreLocation

class SelectLocationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var topTextMessage: UILabel!
    @IBOutlet var middleTextMessage: UILabel!
    @IBOutlet var bottomTextMessage: UILabel!
    @IBOutlet var geolocateButton: UIButton!
    @IBOutlet var textField: UITextView!
    
    var defaultText = "Enter location"
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        let thinFont = UIFont(name: "Roboto-Thin", size: 28.0)
        let heavyFont = UIFont(name: "Roboto-Medium", size: 28.0)
        
        topTextMessage.font = thinFont
        middleTextMessage.font = heavyFont
        bottomTextMessage.font = thinFont
        
        let blue = UIColor(red: 88/255, green: 98/255, blue: 173/255, alpha: 1.0)
        textField.font = UIFont(name: "Roboto-Regular", size: 18.0)
        textField.backgroundColor = blue
        textField.textColor = UIColor.whiteColor()
        textField.textAlignment = .Center
        textField.textContainerInset = UIEdgeInsetsMake(20.0, 20.0, 0, 20.0)
        textField.delegate = self
        textField.text = defaultText
        
        geolocateButton.layer.cornerRadius = 0
        geolocateButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16.0)
        geolocateButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        geolocateButton.backgroundColor = blue
        geolocateButton.contentEdgeInsets = UIEdgeInsetsMake(7.0, 15.0, 7.0, 15.0)
        geolocateButton.enabled = false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textField.text == defaultText {
            textField.text = ""
        }
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        geolocateButton.enabled = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textField.text == "" {
            geolocateButton.enabled = false
            textField.text = defaultText
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func performGeocodeAction(sender: AnyObject) {
        
        let geocoder = CLGeocoder()
        
        func completionHandler(placemarks: [AnyObject]!, error: NSError!) {
            if let placemark = placemarks[0] as? CLPlacemark {
                let controller = storyboard?.instantiateViewControllerWithIdentifier("ConfirmLocation") as! ConfirmLocationViewController
                controller.location = placemark
                presentViewController(controller, animated: false, completion: nil)
            }
        }
        
        geocoder.geocodeAddressString(textField.text, completionHandler: completionHandler)
    }
}
