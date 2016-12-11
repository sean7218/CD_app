//
//  FetchedResultsController.swift
//  CD_app
//
//  Created by Sean Zhang on 11/30/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FetchedResultsController: NSFetchedResultsController<Drawings>, NSFetchedResultsControllerDelegate {
    
    private let tableView: UITableView
    
    init (managedObjectContext: NSManagedObjectContext, tableView: UITableView, fetchRequest: NSFetchRequest<Drawings>) {
        
        self.tableView = tableView
        
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        tryFetch()
        
    }
    
    // MARK: Method - FetchedResultsController.performFetch()
    func tryFetch(){
        
        do {
            try performFetch()
        }
        catch let error as NSError{
            print("Unresolved Error: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("FetchedResultsController did change content")
        tableView.reloadData()
    }
}
