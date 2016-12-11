//
//  DataController.swift
//  CD_app
//
//  Created by Sean Zhang on 11/14/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class DataController: NSObject, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Drawings>!
    
    static let sharedInstance = DataController()
    
    var managedObjectContext: NSManagedObjectContext
    

    
    override init(){
        
        guard let modelURL = Bundle.main.url(forResource: "CD_app", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error creating model from given url")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        let folderURL = urls[urls.endIndex-1]
        
        let storeURL = folderURL.appendingPathComponent("dataModel.sqlite")
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            fatalError("Error while loading the Persistant Store with sqlite")
        }
        

    }
    
    func preloadData(){
        
        print("preloading Data............")
        let json = JSONParser()
        let moc = DataController.sharedInstance.managedObjectContext
        
        removeData()
        
        for index in 0...1193 { //(json.names.count-1)
            let dwg = NSEntityDescription.insertNewObject(forEntityName: "Drawings", into: moc) as! Drawings
            dwg.name = json.names[index]
            dwg.detail = json.details[index]
            dwg.rev = json.revs[index]
            dwg.bookmark = false
            let url = Bundle.main.url(forResource: dwg.name, withExtension:"pdf")
            if url == nil {
                let path = Bundle.main.path(forResource: dwg.name, ofType: "PDF")
                dwg.url = NSURL(fileURLWithPath: path!)
                
            } else {
                let path = Bundle.main.path(forResource: dwg.name, ofType: "pdf")
                dwg.url = NSURL(fileURLWithPath: path!)
            }
        }
        
        if moc.hasChanges {
            do {
                try moc.save()
                print("ManagedObjectContext hasChanged: Saving .....")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeData(){
        let request = NSFetchRequest<Drawings>(entityName: "Drawings")
        do {
        let items = try DataController.sharedInstance.managedObjectContext.fetch(request)
            for item in items {
                DataController.sharedInstance.managedObjectContext.delete(item)
            }
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchData() {
        
        let fetchRequest = NSFetchRequest<Drawings>(entityName: "Drawings")
        fetchRequest.predicate = NSPredicate(format: "detail CONTAINS[C] %@", "Blowdown")
        do {
        let data = try DataController.sharedInstance.managedObjectContext.fetch(fetchRequest)
            
            for _ in data {
                
            }
        } catch{
            print(error.localizedDescription)
        }
      
    }
    
    func createFetchedResultsController(){
        let fetchRequest:NSFetchRequest = NSFetchRequest<Drawings>(entityName: "Drawings")
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch let error as NSError{
            print("Fetching Error: \(error.localizedDescription)")
        }
        
    }
    
    func saveContext () {
        let context = DataController.sharedInstance.managedObjectContext
        print("ManagedObjectContext Function: saveContext")
        if context.hasChanges {
            print("ManagedObjectContext hasChanged: Saving .....")
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

