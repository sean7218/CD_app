//
//  Drawings+CoreDataProperties.swift
//  CD_app
//
//  Created by Sean Zhang on 11/20/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData


extension Drawings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drawings> {
        return NSFetchRequest<Drawings>(entityName: "Drawings");
    }
    
    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var detail: String?
    @NSManaged public var rev: String?
    @NSManaged public var url: NSURL?
    @NSManaged public var bookmark: Bool
    @NSManaged public var tag: String?


}
