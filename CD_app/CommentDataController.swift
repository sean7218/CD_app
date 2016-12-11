//
//  CommentDataController.swift
//  CD_app
//
//  Created by Sean Zhang on 12/2/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CommentDataController: DataController {
    
    override init() {
        super.init()
    }
    
    
    override func preloadData(){
        
        let moc = DataController.sharedInstance.managedObjectContext
        
        for index in 0...5 {
            let note = NSEntityDescription.insertNewObject(forEntityName: "Comments", into: moc) as! Comments
            note.title = String(index)
        }
        
        if moc.hasChanges {
            do {
                try moc.save()
                print("Saving .....")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func removeData(){
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
    
    override func fetchData() {
        
        let fetchRequest = NSFetchRequest<Comments>(entityName: "Comments")
        fetchRequest.predicate = NSPredicate(format: "body CONTAINS[C] %@", "a")
        do {
            let data = try DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
            
            for _ in data {
                
            }
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
    override func createFetchedResultsController(){

        
    }
}
