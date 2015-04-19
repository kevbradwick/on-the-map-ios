//
//  ViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 19/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var parseService = ParseService.sharedInstance()
    var overwriteLocation = false
    var student = (UIApplication.sharedApplication().delegate as! AppDelegate).student!
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        let alreadyPosted = parseService.studentAlreadyPosted(student.key)
        
        // check if the student has already posted a location and that this controller
        // has been set to not overwrite the current location
        if identifier == "addLocation" && alreadyPosted && !overwriteLocation {
            
            let student = (UIApplication.sharedApplication().delegate as! AppDelegate).student!
            
            // launch alert controller
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
            alertController.title = "Overwrite location?"
            alertController.message = "You have already posted your location. Do you wish to overwrite it?"
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            
            let okayAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                // perform the seque
                self.overwriteLocation = true
                self.performSegueWithIdentifier(identifier, sender: sender)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okayAction)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alertController, animated: true, completion: nil)
            })
            
            return false
        }
        
        return true
    }
    
}
