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
        
        let body: [String: AnyObject] = [
            "udacity": [
                "username": username,
                "password": password,
            ]
        ]
        
        doRequest("\(BASE_URL)/api/session", body: body, httpMethod: "POST", onComplete: { (data) -> Void in
            
            // check for authentication failure
            if let status = data["status"] as? Int where status == 403 {
                var error = NSError(domain: "Authentication Error", code: 403, userInfo: nil)
                self.delegate?.udacityService!(self, didError: error)
                return
            }
            
            let session = data["session"] as! [String: AnyObject]
            let account = data["account"] as! [String: AnyObject]
            
            self.delegate?.udacityService!(self, didCreateSession: session["id"] as! String, userId: account["key"] as! String)
        })
    }
    
    /*!
        getStudent:id:completionHandler:
    
        Discussion:
            Get the student information
    */
    func getStudent(id: String, completionHandler handler: (student: Student) -> Void) {
        
        doRequest("\(BASE_URL)/api/users/\(id)", body: nil, httpMethod: "GET", onComplete: { (data) -> Void in
            if let user = data["user"] as? [String: AnyObject] {
                handler(student: Student(studentDictionary: user))
            }
        })
    }
    
    /*!
        makeRequest:url:params:headers:httpMethod:onComplete:
    
        Discussion:
            Make a generic http request to the Udacity Service
    */
    private func doRequest(url: String, body: [String: AnyObject]?, httpMethod: String, onComplete: (data: [String: AnyObject]) -> Void) {
        
        // build the http request
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = httpMethod
        
        // if a body has been supplied, convert it to a JSON string
        if let body = body {
            var error: NSError? = nil
            let data: NSData = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
            let json = NSString(bytes: data.bytes, length: data.length, encoding: NSUTF8StringEncoding)
            request.HTTPBody = json!.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            var parsingError: NSError? = nil
            let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject]
            
            // if a parsing error happens, trigger the error handler on the delegate
            if parsingError != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.udacityService!(self, didError: parsingError!)
                })
                return
            }
            
            // simply call the completion handler with the json data
            if let jsonData = jsonData {
                dispatch_async(dispatch_get_main_queue(), {
                    onComplete(data: jsonData)
                })
            }
        })
        
        task.resume()
    }
}