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
        
        let url = NSURL(string: PARSE_BASE_URL)!
        
        // the http request with auth headers
        let request = NSMutableURLRequest(URL: url)
        request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PARSE_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                self.delegate?.parseService!(self, didError: error)
                return
            }
            
            var parserError: NSError? = nil
            
            // parse the data to a dictionary
            let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments,
                error: &parserError) as! [String: AnyObject]
            
            if parserError != nil {
                self.delegate?.parseService!(self, didError: parserError!)
                return
            }

            var locations = [StudentLocation]()
            let results = jsonData["results"] as? [[String: AnyObject]]
            
            // check for no results
            if results == nil {
                var error = NSError(domain: "Parse API Results", code: 10, userInfo: nil)
                self.delegate?.parseService!(self, didError: error)
                return
            }
            
            for studentLocation in results! {
                locations.append(StudentLocation(locationDict: studentLocation))
            }
            
            self.studentLocations = locations
             
            // turn each location into a StudentLocation
            self.delegate?.parseService!(self, didLoadLocations: locations)
        })
        
        task.resume()
    }
    
    func postStudentLocation(location: StudentLocation) {
        
        var existingLocations = self.studentLocations.filter({ $0.uniqueKey == location.uniqueKey })
        
        var request: NSMutableURLRequest
        
        if existingLocations.count == 1 {
            let existingLocation = existingLocations[0]
            request = NSMutableURLRequest(URL: NSURL(string: "\(PARSE_BASE_URL)/\(existingLocation.objectId)")!)
            request.HTTPMethod = "PUT"
        } else {
            request = NSMutableURLRequest(URL: NSURL(string: PARSE_BASE_URL)!)
            request.HTTPMethod = "POST"
        }
        
        request.addValue(PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PARSE_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        var body: [String: AnyObject] = [
            "uniqueKey": location.uniqueKey,
            "firstName": location.firstName,
            "lastName": location.lastName,
            "mapString": location.mapString,
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
        
        if let mediaUrl = location.mediaUrl {
            body["mediaUrl"] = mediaUrl.absoluteString
        }
        
        var error: NSError? = nil
        let data: NSData = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
        let json = NSString(bytes: data.bytes, length: data.length, encoding: NSUTF8StringEncoding)
        
        request.HTTPBody = json!.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.parseService!(self, didError: error!)
                })
                return
            }
            
            var parserError: NSError? = nil
            
            // parse the data to a dictionary
            let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments,
                error: &parserError) as! [String: AnyObject]
            
            if parserError != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.parseService!(self, didError: parserError!)
                })
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate?.parseService!(self, didPostStudentLocation: location)
            })
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