//
//  LoginTextField.swift
//  On The Map
//
//  Created by Kevin Bradwick on 14/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
   
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        borderStyle = UITextBorderStyle.None
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        textColor = UIColor.whiteColor()
        font = UIFont(name: "Roboto", size: 16.0)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
}
