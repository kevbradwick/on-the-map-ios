//
//  Student.swift
//  On The Map
//
//  Created by Kevin Bradwick on 19/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import Foundation


class Student : NSObject, Streamable {
    
    var facebookId: String?
    var imageUrl: NSURL?
    var email: String?
    var firstName: String?
    var lastName: String?
    var key: String!
    
    /*!
        Initialise a Student with the json dictionary from a successful request to get the user's details
    */
    required init(studentDictionary: [String: AnyObject]) {
        
        if let fbId = studentDictionary["_facebook_id"] as? String {
            facebookId = fbId
        }
        
        if let imgUrl = studentDictionary["_image_url"] as? String {
            imageUrl = NSURL(string: imgUrl)!
        }
        
        if let email = studentDictionary["email"] as? [String: AnyObject] {
            self.email = email["address"] as? String
        }
        
        if let firstName = studentDictionary["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = studentDictionary["last_name"] as? String {
            self.lastName = lastName
        }
        
        key = studentDictionary["key"] as! String
    }
    
    /*!
        Gives textual representation of the student. Useful in println() statements.
    */
    func writeTo<Target : OutputStreamType>(inout target: Target) {
        target.write("Student - #\(key): \(firstName!) \(lastName!) <\(email!)>")
    }
}