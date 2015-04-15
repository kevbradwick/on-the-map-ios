//
//  ParseServiceDelegate.swift
//  On The Map
//
//  Created by Kevin Bradwick on 15/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation

@objc(ParseServiceDelegate)

protocol ParseServiceDelegate : NSObjectProtocol {
    
    /*!
        didLoadStudentLocations:service:locations:
    
        Discussion:
            This is called when locations have been received from the Parse API
    */
    optional func parseService(service: ParseService, didLoadLocations locations: [StudentLocation])
    
    /*!
        didError:service:error:
    
        Discussion:
            A catch all delegate method for any type of error
    */
    optional func parseService(service: ParseService, didError error: NSError)
}