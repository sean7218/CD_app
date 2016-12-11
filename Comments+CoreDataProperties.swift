//
//  Comments+CoreDataProperties.swift
//  CD_app
//
//  Created by Sean Zhang on 12/2/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData


extension Comments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comments> {
        return NSFetchRequest<Comments>(entityName: "Comments");
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?

}
