//
//  UdacityService.swift
//  On The Map
//
//  Created by Kevin Bradwick on 13/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation


let BASE_URL = "https://www.udacity.com"


class UdacityService : NSObject {
    
    let session = NSURLSession.sharedSession()
    
    /*!
        Get's a new session ID by posting to /api/session with the user credentials
    */
    func getSessionId(username: String, password: String, completion: (sessionId: String) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        println(request.HTTPBody)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error)
                return
            }
            
            let data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            var parsingError: NSError? = nil
            let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject]
            
            println(jsonData)
        })
        
        task.resume()
    }
}