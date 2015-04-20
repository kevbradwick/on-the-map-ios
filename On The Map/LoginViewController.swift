//
//  LoginViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 13/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

let GRADIENT_COLOUR_BOTTOM = UIColor(red: 255/255, green: 114/255, blue: 0/255, alpha: 1.0)
let GRADIENT_COLOUR_TOP = UIColor(red: 255/255, green: 156/255, blue: 0, alpha: 1.0)


class LoginViewController: UIViewController, UdacityServiceDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var loginButton: LoginButton!
    @IBOutlet var backgroundView: GradientView!
    @IBOutlet var usernameField: LoginTextField!
    @IBOutlet var passwordField: LoginTextField!
    @IBOutlet var activityIndicatorView: UIView!
    
    var udacityService = UdacityService()
    
    override func viewDidLoad() {
        udacityService.delegate = self
        
        activityIndicatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        activityIndicatorView.hidden = true
    }
    
    override func viewWillLayoutSubviews() {
        
        backgroundView.gradientWithColours(GRADIENT_COLOUR_TOP, bottomColour: GRADIENT_COLOUR_BOTTOM)
        passwordField.secureTextEntry = true
    }
    
    // MARK: - Udacity Service
    
    func udacityService(service: UdacityService, didCreateSession sessionId: String, userId: String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // get user info and enter main application
        udacityService.getStudent(userId, completionHandler: { (student: Student) -> Void in
            appDelegate.student = student
            self.activityIndicatorView.hidden = false
            self.performSegueWithIdentifier("enterMainApplication", sender: student)
        })
    }
    
    /*!
        Display a UIAlertController for an error.
    */
    func udacityService(service: UdacityService, didError error: NSError) {
        
        println("Error: \(error.debugDescription)")
        
        let alertController = UIAlertController(title: "Error", message: "An unknown error occured", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
        
        // set the message to be specific to failed authentication
        if error.code == 403 {
            alertController.message = "Authentication failure"
        }
        
        activityIndicatorView.hidden = true
        
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    /*!
        Attempt to authenticate with the Udacity API
    */
    @IBAction func loginToUdacity(sender: AnyObject) {
        activityIndicatorView.hidden = false
        udacityService.authenticate(usernameField.text, password: passwordField.text)
    }
    
    /*
        Launches www.udacity.com in Safari so that they can sign up.
    */
    @IBAction func launchUdacityInSafari(sender: AnyObject) {
        
        let urlString = "https://www.udacity.com/account/auth#!/signup"
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
}

