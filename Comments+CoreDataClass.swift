//
//  Comments+CoreDataClass.swift
//  CD_app
//
//  Created by Sean Zhang on 12/2/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData

@objc(Comments)
public class Comments: NSManagedObject {

    static let fetchRequest1: NSFetchRequest<Comments> = {
        let fr1 = NSFetchRequest<Comments>(entityName: "Comments")
        let sd = NSSortDescriptor(key: "title", ascending: true)
        fr1.sortDescriptors = [sd]
        return fr1
    }()
    
}
