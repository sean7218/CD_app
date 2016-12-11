//
//  FilterController.swift
//  CD_app
//
//  Created by Sean Zhang on 12/5/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol FilterControllerDelegate {
    func transferData(_ data: String)
}

class FilterController: UIViewController {
    
    // MARK: - DefineVariables
    var delegate: FilterControllerDelegate!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        

    }
    
    // MARK: - SetupButtons
    
    @IBAction func button1() {
        delegate.transferData("ND")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func button2() {
        delegate.transferData("XD")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func button3() {
        delegate.transferData("ALL")
        dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    
    
    
    
    
    
}
