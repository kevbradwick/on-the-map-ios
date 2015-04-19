//
//  UdacityServiceDelegate.swift
//  On The Map
//
//  Created by Kevin Bradwick on 19/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation

@objc(UdacityServiceDelegate)

protocol UdacityServiceDelegate : NSObjectProtocol {

    /*!
        udacityService:service:didError:
    
        Discussion:
            Will get called for any type of error encountered when using the Udacity service
    */
    optional func udacityService(service: UdacityService, didError error: NSError)
    
    /*!
        udacityService:service:didCreateSession:
    
        Discussion:
            Wil get called when a session has been created
    */
    optional func udacityService(service: UdacityService, didCreateSession sessionId: String, userId: String)
}