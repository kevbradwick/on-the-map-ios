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


class LoginViewController: UIViewController {

    @IBOutlet var loginButton: LoginButton!
    @IBOutlet var backgroundView: GradientView!
    @IBOutlet var usernameField: LoginTextField!
    @IBOutlet var passwordField: LoginTextField!
    
    override func viewWillLayoutSubviews() {
        backgroundView.gradientWithColours(GRADIENT_COLOUR_TOP, bottomColour: GRADIENT_COLOUR_BOTTOM)
        
        passwordField.secureTextEntry = true
    }

    @IBAction func loginToUdacity(sender: AnyObject) {
        
    }
}

