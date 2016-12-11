//
//  BookmarkController.swift
//  CD_app
//
//  Created by Sean Zhang on 12/1/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import QuickLook

class BookmarkController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    
    var codeName: String = "ER"
    var typeName: String = "ND"
    var tagName: String = ""
    
    
    
    var names = [String]()
    var fileURLs = [URL]()
    
    
    
    let quickLookController = QLPreviewController()
    let dataController = DataController.sharedInstance
    let moc = DataController.sharedInstance.managedObjectContext
    
    lazy var fetchedResultsController: FetchedResultsController = {
        let controller = FetchedResultsController(managedObjectContext: self.moc, tableView: self.tableView, fetchRequest: Drawings.fetchRequest3)
        
        return controller
    }()
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self

        quickLookController.dataSource = self
        quickLookController.delegate = self
        
        createURLsForQL()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = fetchedResultsController.sections?.count
        return sections!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.fetchedObjects?.count
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createURLsForQL()
        let cellIdentifier = "BookCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BookCell
        let detail = fetchedResultsController.fetchedObjects?[indexPath.row].detail
        let name = fetchedResultsController.fetchedObjects?[indexPath.row].name
        cell.name.text = name!
        cell.detail.text = detail!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // MARK: createURLsForQuickLook
    
    func createURLsForQL (){
        fileURLs = [URL]()
        let count = fetchedResultsController.fetchedObjects?.count
        if count != 0 {
            
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
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        
        return fileURLs.count
    }
    
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return fileURLs[index] as QLPreviewItem
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if QLPreviewController.canPreview(fileURLs[indexPath.row] as QLPreviewItem) {
            
            quickLookController.currentPreviewItemIndex = indexPath.row
            
            navigationController?.pushViewController(quickLookController, animated: true)
            
        } else {
            print("\(fileURLs[indexPath.row]) Can't to see it QLPreviewItem")
        }
        
    }
}

class BookCell : UITableViewCell {
    
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
