//
//  TagController.swift
//  CD_app
//
//  Created by Sean Zhang on 12/7/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol TagControllerDelegate {
    func transferTag(_ tagName: String)
}

class TagController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var tagName = ""
    var delegate: TagControllerDelegate!
    
    var convertedArray = [String]()
    var finalList = [String]()
    
    lazy var fetchedResultsController: FetchedResultsController = {
        
        let frc = FetchedResultsController(managedObjectContext: DataController.sharedInstance.managedObjectContext, tableView: self.tableView, fetchRequest: Drawings.fetchRequest4)
    
        return frc
    }()


    
    override func viewDidLoad() {
        //setup
        //tableView.addGestureRecognizer(tapOnTableView)
        tableView.addGestureRecognizer(swipeOnTableView)
        _ = fetchedResultsController.fetchedObjects
        finalList = fetchedResultsToArray()
        finalList = removeDuplicates(array: finalList)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return fetchedResultsController.sections?.count ?? 0
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let sect = fetchedResultsController.sections?[section] else { return 0 }
        //return sect.numberOfObjects

        return finalList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TagCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        //cell?.textLabel?.text = fetchedResultsController.fetchedObjects?[indexPath.row].tag
        cell?.textLabel?.text = finalList[indexPath.row]
     
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tagName = (fetchedResultsController.fetchedObjects?[indexPath.row].tag)!
        tagName = finalList[indexPath.row]
        delegate.transferTag(tagName)
        dismiss(animated: true, completion: nil)
    }
    
    
    var swipeOnTableView: UISwipeGestureRecognizer = {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
            swipeGesture.direction = .left
        return swipeGesture
    }()
    
    func dismissVC() {
        print("Dismiss Whentapon Outside")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissWithButton(sender: UIButton) {
        print("dismissButton")
        dismiss(animated: true, completion: nil)
    }
    
    func removeDuplicates(array: [String]) -> [String] {
    
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                
            } else {
                encountered.insert(value)
                result.append(value)
            }
        }
        
        return result
    }
    
    func fetchedResultsToArray() -> [String] {
        
        convertedArray.removeAll()
        print("converting")
        if let objects = fetchedResultsController.fetchedObjects {
            for item in objects {
                convertedArray.append(item.tag!)
            }
        }
        
        return convertedArray
    }
    
    
}
