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
    
    var delegate: UdacityServiceDelegate?
    
    /*!
        Get's a new session ID by posting to /api/session with the user credentials
    */
    func authenticate(username: String, password: String) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(BASE_URL)/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
                
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                self.delegate?.udacityService!(self, didError: error)
                return
            }
            
            let data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // try to parse the response data
            var parsingError: NSError? = nil
            let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject]
            
            if parsingError != nil {
                self.delegate?.udacityService!(self, didError: parsingError!)
                return
            }
            
            // authentication failure
            if let status = jsonData!["status"] as? Int where status == 403 {
                var error = NSError(domain: "Authentication Error", code: 403, userInfo: nil)
                self.delegate?.udacityService!(self, didError: error)
                return
            }
            
            let session = jsonData!["session"] as! [String: AnyObject]
            let account = jsonData!["account"] as! [String: AnyObject]
            
            self.delegate?.udacityService!(self, didCreateSession: session["id"] as! String, userId: account["key"] as! String)
        })
        
        task.resume()
    }
    
    /*!
    
    */
    func getUser(id: String, completionHandler handler: (student: Student) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(BASE_URL)/api/users/\(id)")!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        
            let data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // try to parse the response data
            var parsingError: NSError? = nil
            let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject]
            
            if parsingError != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.udacityService!(self, didError: parsingError!)
                })
                return
            }
            
            // okay, here's the user object
            if let user = jsonData!["user"] as? [String: AnyObject] {
                dispatch_async(dispatch_get_main_queue(), {
                    handler(student: Student(studentDictionary: user))
                })
            }
        })
        
        task.resume()
    }
}