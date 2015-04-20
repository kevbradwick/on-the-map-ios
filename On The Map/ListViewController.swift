//
//  ListViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 14/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

let PROTOTYPE_CELL = "studentLocationCell"

class ListViewController: ViewController, UITableViewDataSource, UITableViewDelegate, ParseServiceDelegate {

    @IBOutlet var tableView: UITableView!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        parseService.delegate = self
        parseService.loadStudentLocations()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - TablewView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let location = locations[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PROTOTYPE_CELL) as! StudentTableViewCell
        cell.title?.text = "\(location.firstName) \(location.lastName)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    /*!
        Open the students link in Safari
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = locations[indexPath.row]
        if let url = location.mediaUrl {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - ParseService
    
    func parseService(service: ParseService, didLoadLocations locations: [StudentLocation]) {
        
        self.locations = locations
        
        println("Loaded \(locations.count) locations")
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func parseService(service: ParseService, didError error: NSError) {
        println("ParseAPI Error: \(error.debugDescription)")
    }
    
    func parseService(service: ParseService, didPostStudentLocation location: StudentLocation) {
        // do nothing
    }
    
    // MARK: - Actions
    
    @IBAction func reloadStudentLocations() {
        parseService.loadStudentLocations()
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        println("Unwind List Controller")
    }
}
