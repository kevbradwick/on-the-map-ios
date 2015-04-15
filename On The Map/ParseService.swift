//
//  ParseService.swift
//  On The Map
//
//  Created by Kevin Bradwick on 15/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation

let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
let PARSE_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
let PARSE_BASE_URL = "https://api.parse.com/1/classes/StudentLocation"

class ParseService : NSObject {
    
    let studentLocations = [StudentLocation]()
    
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
             
            // turn each location into a StudentLocation
            self.delegate?.parseService!(self, didLoadLocations: locations)
        })
        
        task.resume()
    }
}