//
//  ListViewController.swift
//  On The Map
//
//  Created by Kevin Bradwick on 14/04/2015.
//  Copyright (c) 2015 KodeFoundry. All rights reserved.
//

import UIKit

let PROTOTYPE_CELL = "studentLocationCell"

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseServiceDelegate {

    @IBOutlet var tableView: UITableView!
    
    var locations = [StudentLocation]()
    var parseService = ParseService.sharedInstance()
    
    override func viewDidLoad() {
        parseService.delegate = self
        parseService.loadStudentLocations()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - TablewView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PROTOTYPE_CELL) as! UITableViewCell
        let location = locations[indexPath.row]
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mapString
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
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
}
