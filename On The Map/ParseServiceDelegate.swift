//
//  ParseServiceDelegate.swift
//  On The Map
//
//  Created by Kevin Bradwick on 15/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation

protocol ParseServiceDelegate : NSObjectProtocol {
    
    /*!
        parseService:service:didLoadLocations:
    
        Discussion:
            This is called when locations have been received from the Parse API
    */
    func parseService(service: ParseService, didLoadLocations locations: [StudentInformation])
    
    /*!
        didError:service:error:
    
        Discussion:
            A catch all delegate method for any type of error
    */
    func parseService(service: ParseService, didError error: NSError)
    
    /*!
        parseService:service:didPostStudentLocation:
    
        Discussion:
            Get's called when a location was posted (new or update)
    */
    func parseService(service: ParseService, didPostStudentLocation location: StudentInformation)
}