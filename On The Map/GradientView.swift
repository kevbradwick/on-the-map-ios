//
//  GradientView.swift
//  On The Map
//
//  Created by Kevin Bradwick on 14/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    func gradientWithColours(topColour: UIColor, bottomColour: UIColor) {
        
        let deviceScale = UIScreen.mainScreen().scale
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width * deviceScale, self.frame.size.height * deviceScale)
        gradientLayer.colors = [topColour.CGColor, bottomColour.CGColor]
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

}
