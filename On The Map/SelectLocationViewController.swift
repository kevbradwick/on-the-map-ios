//
//  SelectLocationViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 16/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

class SelectLocationViewController: UIViewController {

    @IBOutlet var topTextMessage: UILabel!
    @IBOutlet var middleTextMessage: UILabel!
    @IBOutlet var bottomTextMessage: UILabel!
    @IBOutlet var geolocateButton: UIButton!
    @IBOutlet var textField: UITextView!
    
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
        
        geolocateButton.layer.cornerRadius = 0
        geolocateButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16.0)
        geolocateButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        geolocateButton.backgroundColor = blue
        geolocateButton.contentEdgeInsets = UIEdgeInsetsMake(7.0, 15.0, 7.0, 15.0)
    }
}
