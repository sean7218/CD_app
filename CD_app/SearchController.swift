//
//  SearchController.swift
//  CD_app
//
//  Created by Sean Zhang on 11/23/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import QuickLook

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate, QLPreviewControllerDataSource {
    
    var names = [String]()
    var fileURLs = [URL]()
    let quickLookController = QLPreviewController()
    
    var searchResultController: UITableViewController!
    var searchController: UISearchController!
    var fetchedResultsController: NSFetchedResultsController<Drawings>!

    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        
        createEmptyFetchRequest()
        
        //Create Controllers
        searchResultController = UITableViewController(style: .plain)
        searchController = UISearchController(searchResultsController: nil)
 
        
        //create searchbar
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        tableView.dataSource = self
        tableView.delegate = self
        
        //show searchbar
        //tableView.tableHeaderView = searchController.searchBar
        self.navigationItem.titleView = searchController.searchBar
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.hidesBackButton = false
        searchController.searchBar.awakeFromNib()
        searchController.searchBar.becomeFirstResponder()
        
        quickLookController.dataSource = self
        createURLsForQL()
    }
    

    func createEmptyFetchRequest(){
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Drawings.fetchRequest5, managedObjectContext: DataController.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    //1 -----------------------------------------------------------SETTING UP TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    //2
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let totalRowCount = fetchedResultsController.sections?[section] else { return 0 }
        return totalRowCount.numberOfObjects
    }
    
    //3
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterCell
        cell.name.text = fetchedResultsController.fetchedObjects?[indexPath.row].name
        cell.detail.text = fetchedResultsController.fetchedObjects?[indexPath.row].detail
        return cell
    }
    
    //4
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    //----------------------------------------------------------END
       //------------------------------------------------------------ SETTING UP THE SEARCHCONTROLLER
    //5
    func updateSearchResults(for searchController: UISearchController) {
        print("searching updating...")
    }
    
    //6
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("SearchBar Text now started")
    }
    
    //7
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return names.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURLs[index] as QLPreviewItem
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if QLPreviewController.canPreview(fileURLs[indexPath.row] as QLPreviewItem) {
            quickLookController.currentPreviewItemIndex = indexPath.row
            navigationController?.pushViewController(quickLookController, animated: true)
        }
    }
    
    //8
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search Button Pushed")
        let text = searchBar.text
        let predicate = NSPredicate(format: "detail CONTAINS[C] %@", text!)
        let fetchRequest = NSFetchRequest<Drawings>(entityName: "Drawings")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: DataController.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetchresult controller failed perform fatch: \(error.localizedDescription)")
        }

        createURLsForQL()
        quickLookController.refreshCurrentPreviewItem()
        quickLookController.reloadData()
        tableView.reloadData()
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: createURLsForQuickLook
    /*
    func createURLsForQL (){
        let fr = NSFetchRequest<Drawings>(entityName: "Drawings")
        fr.sortDescriptors = [{return NSSortDescriptor(key: "name", ascending: true)}()]
        fetchResultController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: DataController.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchResultController.performFetch()
        }
        catch let error as NSError{
            print("Can't fetch any results\(error.localizedDescription)")
        }
        let count = fetchResultController.fetchedObjects?.count
        for index in 0...(count!-1) {

                
            let name = fetchResultController.fetchedObjects?[index].name
            print("[SearchController] current name is \(name!)")
            let url = Bundle.main.url(forResource: name!, withExtension:"pdf")
          
            if url == nil {
            let url = Bundle.main.url(forResource: name!, withExtension: "PDF")
                fileURLs.append(url!)
                print("[SearchController] current url is \(url)")
            } else {
                    fileURLs.append(url!)
                   print("[SearchController] current url is \(url)")
            }
            names.append(name!)
            }
    }*/
    
    func createURLsForQL (){
        fileURLs = [URL]()
        let count = fetchedResultsController.fetchedObjects?.count
        if count != nil && count != 0{
            
            for index in 0...(count!-1) {
                let name = fetchedResultsController.fetchedObjects?[index].name
                let url = Bundle.main.url(forResource: name!, withExtension:"pdf")
                if url == nil {
                    let url = Bundle.main.url(forResource: name!, withExtension: "PDF")
                    fileURLs.append(url!)
                } else {
                    fileURLs.append(url!)
                }
                names.append(name!)
            }
        }
    }
}


class FilterCell : UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

