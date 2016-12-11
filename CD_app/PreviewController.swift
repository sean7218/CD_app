//
//  PreviewController.swift
//  CD_app
//
//  Created by Sean Zhang on 11/30/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import QuickLook

class PreviewController: QLPreviewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    var fileURLs = [URL]()

    override func viewDidLoad() {
        fileURLs = []
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return fileURLs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURLs[index] as QLPreviewItem
    }
}
