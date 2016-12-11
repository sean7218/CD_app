//
//  CommentController.swift
//  CD_app
//
//  Created by Sean Zhang on 12/2/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CommentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let moc = DataController.sharedInstance.managedObjectContext
    let dataController = DataController.sharedInstance
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Comments> in 
        
        let controller = NSFetchedResultsController(fetchRequest: Comments.fetchRequest1, managedObjectContext: DataController.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
        
    }()
    
    override func viewDidLoad() {
        
        do {
            print("refresh")
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - SetupTheTableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let c = fetchedResultsController.sections?[section] else { return 0 }
        return c.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CommentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommentCell
        cell.title?.text = fetchedResultsController.fetchedObjects?[indexPath.row].body

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    // MARK: - SetupTheAddAction
    @IBAction func addNotes(_ sender: UIBarButtonItem) {
        print("AddNotes")
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Comments", into: moc) as! Comments
        newNote.body = "V17494.NCR.0012: The actual product is the same with MTR. The Line No. (LP3015-3) was missing from pipe marking but the material can be checked from heat number."
        self.dataController.saveContext()
            do {
                print("refresh")
                try fetchedResultsController.performFetch()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        
        tableView.reloadData()
        
    }
    
    func removeData(){
        let request = NSFetchRequest<Comments>(entityName: "Comments")
        do {
            let items = try DataController.sharedInstance.managedObjectContext.fetch(request)
            for item in items {
                DataController.sharedInstance.managedObjectContext.delete(item)
            }
        } catch{
            print(error.localizedDescription)
        }
    }
    
}



class CommentCell: UITableViewCell {
    
    @IBOutlet var title: UILabel?
    @IBOutlet var body: UILabel?
    
}
