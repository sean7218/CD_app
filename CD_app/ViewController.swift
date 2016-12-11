//
//  ViewController.swift
//  CD_app
//
//  Created by Sean Zhang on 11/14/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import QuickLook



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDataSource,QLPreviewControllerDelegate, UIPopoverPresentationControllerDelegate {
    

    var codeName: String = "ER"
    var typeName: String = "ND"
    var tagName: String = ""
    
    var showSegment: Bool = false
    @IBOutlet var tableView: UITableView!

    
    
    var names = [String]()
    var fileURLs = [URL]()
    let quickLookController = QLPreviewController()
    let dataController = DataController.sharedInstance
    let moc = DataController.sharedInstance.managedObjectContext

    lazy var fetchedResultsController: FetchedResultsController = {
        let controller = FetchedResultsController(managedObjectContext: self.moc, tableView: self.tableView, fetchRequest: Drawings.fetchRequest2)
       
        return controller
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // setup on quicklook
        quickLookController.dataSource = self
        quickLookController.delegate = self
        
        // setup on tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // setup on coreData
        //dataController.preloadData()

        createURLsForQL()
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        let dwg = fetchedResultsController.object(at: indexPath)
        cell.name.text = dwg.name
        cell.detail.text = dwg.detail
        if let temp = dwg.tag {
            cell.tags.text = "TAG: \(temp)"
        } else {
            cell.tags.text = "   :"
        }
        
        if dwg.bookmark {
            cell.name.textColor = UIColor.red
        } else {
            cell.name.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
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
    

    // MARK: - clearFilterAndCodeName
    @IBAction func changeFilter(_ sender: Any) {
        
        print("ChangeFilter Now")
        codeName = "V17494"
        
        fetchedResultsController.fetchRequest.predicate = nil
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Can't change fetchRequest Predicat \(error.localizedDescription)")
        }
        createURLsForQL()
        quickLookController.refreshCurrentPreviewItem()
        quickLookController.reloadData()
        tableView.reloadData()
    }
    
    // MARK: - showPopoverViewController(_ send: Any)
    @IBAction func showSegment(_ sender: UIBarButtonItem) {
        print("showPopoverViewController")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopoverViewController") as! FilterController
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        vc.preferredContentSize = CGSize(width: 200, height: 150)
        popover.delegate = self
        popover.barButtonItem = sender

        present(vc, animated: true, completion: nil)

    }
    

    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
     
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopoverViewController") as! FilterController
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
     
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        vc.preferredContentSize = CGSize(width: 200, height: 150)
        popover.delegate = self
        return vc
     
    }
 

    // MARK: - TableViewActionsForRow
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
 
        // MARK: - HandlerBookmark
        let handler1: (UITableViewRowAction, IndexPath) -> Void = { (action, indexPath) -> Void in
            
            if let itemAtRow = self.fetchedResultsController.fetchedObjects?[indexPath.row] {
                
                let alert = UIAlertController(title: "Bookmark", message: "Are you sure bookmarking\n \(itemAtRow.name!)",
                    preferredStyle: .alert)
                let action1 = UIAlertAction.init(title: "YES", style: .default, handler: { action -> Void in
                    
                    itemAtRow.bookmark = true
                    self.dataController.saveContext()
                    tableView.isEditing = false
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                })
                let action2 = UIAlertAction.init(title: "NO", style: .default, handler: { action -> Void in
                    
                    itemAtRow.bookmark = false
                    self.dataController.saveContext()
                    tableView.isEditing = false
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                })
                alert.addAction(action1)
                alert.addAction(action2)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        // MARK: - HandlerTag
        let handler2: (UITableViewRowAction, IndexPath) -> Void = { (action, indexPath) -> Void in
            
            
            let itemAtRow = self.fetchedResultsController.fetchedObjects?[indexPath.row]
            
            let alert = UIAlertController(title: "Tag", message: "Please Enter After #", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {(textField: UITextField) -> Void in
                
                if itemAtRow?.tag != nil {
                    textField.text = itemAtRow?.tag
                    
    
                } else {
                    textField.text = "#"
                }

                NotificationCenter.default.addObserver(forName: .UITextFieldTextDidBeginEditing, object: textField, queue: OperationQueue.main, using: { (notification2) -> Void in
                    let tapOutsideGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController(sender:)))
                    print("UITextFieldTextBeginEditing")
                    alert.view.superview?.subviews[1].isUserInteractionEnabled = true
                    alert.view.superview?.subviews[1].addGestureRecognizer(tapOutsideGesture)
                    tableView.isEditing = false
                })
                
                NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: OperationQueue.main, using: { (notification3) -> Void in
                    print("UIKeyboardWillHide")

                    tableView.isEditing = false
                })

            })
            
            let action1 = UIAlertAction(title: "Save", style: .default, handler: { action1 -> Void in
                print("Save")
                
               
                itemAtRow?.tag = alert.textFields?[0].text
                 self.dataController.saveContext()
                tableView.reloadRows(at: [indexPath], with: .none)
            })
            let action2 = UIAlertAction(title: "Cancel", style: .default, handler: { action2 -> Void in
                print("Cancel")
            })

            alert.addAction(action1)
            alert.addAction(action2)

            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        let bookmarkAction = UITableViewRowAction(style: .default, title: "Bookmark", handler: handler1)
        
        let hashTagAction = UITableViewRowAction(style: .default, title: "Tag", handler: handler2)
        hashTagAction.backgroundColor = UIColor(red: 0, green: 0.4784, blue: 1, alpha: 1.0)
        
        return [bookmarkAction, hashTagAction]
        
        
    }
    
    func dismissAlertController(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        print("dismiss the AlertController")
    }
    
}

// MARK: - ExtensionForProtocal[Filter]
extension ViewController: FilterControllerDelegate {
    
    func transferData(_ data: String) {
        print("Transfering data [typeName]")
        var pds: NSCompoundPredicate
        self.typeName = data
        let pd1 = NSPredicate(format: "name CONTAINS[C] %@", codeName)
        let pd2 = NSPredicate(format:"name CONTAINS[C] %@", typeName)
        if typeName == "ALL" {
            pds = NSCompoundPredicate(andPredicateWithSubpredicates: [pd1])
        } else {
            pds = NSCompoundPredicate(andPredicateWithSubpredicates: [pd1, pd2])
        }
        
        fetchedResultsController.fetchRequest.predicate = pds
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Can't change fetchRequest Predicat \(error.localizedDescription)")
        }
        createURLsForQL()
        quickLookController.refreshCurrentPreviewItem()
        quickLookController.reloadData()
        tableView.reloadData()
    }
    
}

// MARK: - ExtensionForProtocal[Menu]
extension ViewController: MenuControllerDelegate {
    
    
    func transferCode(_ codeName: String) {
        print("Transfering Data [codeName]")
        self.codeName = codeName

        let pd1 = NSPredicate(format: "name CONTAINS[C] %@", codeName)
        //let pd2 = NSPredicate(format:"name CONTAINS[C] %@", typeName)
        let pds = NSCompoundPredicate(andPredicateWithSubpredicates: [pd1])
        fetchedResultsController.fetchRequest.predicate = pds
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Can't change fetchRequest Predicat \(error.localizedDescription)")
        }
        createURLsForQL()
        quickLookController.refreshCurrentPreviewItem()
        quickLookController.reloadData()
        tableView.reloadData()
    }
}


// MARK: - ExtensionForProtocal[Tag]
extension ViewController: TagControllerDelegate {
    

    
    
    func transferTag(_ tagName: String) {
        print("Transfering Data [tagName]")
        self.tagName = tagName
        
        let pd1 = NSPredicate(format: "tag CONTAINS[C] %@", tagName)
        //let pd2 = NSPredicate(format:"name CONTAINS[C] %@", typeName)
        let pds = NSCompoundPredicate(andPredicateWithSubpredicates: [pd1])
        fetchedResultsController.fetchRequest.predicate = pds
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Can't change fetchRequest Predicat \(error.localizedDescription)")
        }
        createURLsForQL()
        quickLookController.refreshCurrentPreviewItem()
        quickLookController.reloadData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TagSegue" {
            let destinVC = segue.destination as! TagController
            destinVC.delegate = self
        }
        
        if segue.identifier == "MenuSegue" {
            let destinVC = segue.destination as! MenuController
            destinVC.delegate = self
        }
        
    }
}
