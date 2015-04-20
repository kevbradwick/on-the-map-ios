//
//  ParseService.swift
//  On The Map
//
//  Created by Kevin Bradwick on 15/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation

let PARSE_APP_ID = ""
let PARSE_API_KEY = ""
let PARSE_BASE_URL = "https://api.parse.com/1/classes/StudentLocation"

class ParseService : NSObject {
    
    var studentLocations = [StudentLocation]()
    
    private let urlSession = NSURLSession.sharedSession()
    
    var delegate: ParseServiceDelegate?
    
    /*!
        Service singleton
    */
    class func sharedInstance() -> ParseService {
        struct Shared {
            static let instance = ParseService()
        }
        
        return Shared.instance
    }
    
    /*!
        loadStudentLocations:
    
        Discussion:
            Make a request to the Parse API for student locations. When the request is complete,
            a call will be made to parseService:service:didLoadLocations:
    */
    func loadStudentLocations() {
        
        doRequest(PARSE_BASE_URL, body: nil, httpMethod: "GET", onComplete: { (data) -> Void in
            
            var locations = [StudentLocation]()
            let results = data["results"] as? [[String: AnyObject]]
            
            if results == nil {
                var error = NSError(domain: "Parse API Results", code: 10, userInfo: nil)
                self.delegate?.parseService!(self, didError: error)
                return
            }
            
            for studentLocation in results! {
                locations.append(StudentLocation(locationDict: studentLocation))
            }
            
            self.studentLocations = locations
            self.delegate?.parseService!(self, didLoadLocations: locations)
        })
    }
    
    /*!
        Submit a student location. This will perform an update (PUT) if the user has already posted
    */
    func postStudentLocation(location: StudentLocation) {
        
        var body: [String: AnyObject] = [
            "uniqueKey": location.uniqueKey,
            "firstName": location.firstName,
            "lastName": location.lastName,
            "mapString": location.mapString,
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
        
        if let mediaUrl = location.mediaUrl {
            body["mediaURL"] = mediaUrl.absoluteString
        }
        
        var existingLocations = self.studentLocations.filter({ $0.uniqueKey == location.uniqueKey })
        var httpMethod = existingLocations.count > 0 ? "PUT" : "POST"
        var urlString = existingLocations.count > 0 ? "\(PARSE_BASE_URL)/\(existingLocations[0].objectId)" : PARSE_BASE_URL
        
        doRequest(urlString, body: body, httpMethod: httpMethod, onComplete: { (data) -> Void in
            self.delegate?.parseService!(self, didPostStudentLocation: location)
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
        request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PARSE_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.HTTPMethod = httpMethod
        
        // if a body has been supplied, convert it to a JSON string
        if let body = body {
            var error: NSError? = nil
            let data: NSData = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
            let json = NSString(bytes: data.bytes, length: data.length, encoding: NSUTF8StringEncoding)
            request.HTTPBody = json!.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            // trigger error on request error
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.parseService!(self, didError: error)
                })
                return
            }
            
            var parsingError: NSError? = nil
            let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject]
            
            // if a parsing error happens, trigger the error handler on the delegate
            if parsingError != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.parseService!(self, didError: parsingError!)
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
    
    /*!
        Check to see if a student has already posted
    */
    func studentAlreadyPosted(key: String) -> Bool {
        
        let locations = studentLocations.filter({ (student: StudentLocation) -> Bool in student.uniqueKey == key })
        return locations.count > 0
    }
}