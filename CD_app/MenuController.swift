//
//  MenuController.swift
//  CD_app
//
//  Created by Sean Zhang on 11/26/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol MenuControllerDelegate {
    func transferCode(_ codeName: String)
}

class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var delegate: MenuControllerDelegate!
    
    lazy var cancellButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)

        button.layer.frame = CGRect(x: 8, y: 16, width: 50, height: 50)
        let img = UIImage(named: "cancel.png")
        button.setImage(img, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    var menu: Array = ["BC", "BD", "BE", "BM", "BP", "BS", "BU", "CC", "CI", "CV", "DG", "DR", "DW", "EB", "EJ", "ER", "FL", "GA"]
    var current: String = "DWND"
    
    override func viewDidLoad() {
        //1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        view.addSubview(cancellButton)
        
    }
    
    func cancelButtonClick(sender: UIButton!) {
        print("Button Pressed")
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.title.text = menu[indexPath.row]
        cell.title.textColor = (menu[indexPath.row] == current) ? UIColor.gray : UIColor.black

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Just selected the menu item:  \(menu[indexPath.row])")
        current = menu[indexPath.row]
        delegate.transferCode(menu[indexPath.row])
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuController = segue.source as! MenuController
        if let selectIndexPath = menuController.tableView.indexPathForSelectedRow {
            current = menu[selectIndexPath.row]
        }
    }
    
}

class MenuCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
