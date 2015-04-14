//
//  LoginButton.swift
//  On The Map
//
//  Created by Kevin Bradwick on 13/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 0
        setTitle("Login", forState: .Normal)
        titleLabel?.font = UIFont(name: "Roboto", size: 16.0)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backgroundColor = UIColor(red: 240/255, green: 88/255, blue: 14/255, alpha: 1.0)
    }
}
