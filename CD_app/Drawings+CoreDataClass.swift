//
//  Drawings+CoreDataClass.swift
//  CD_app
//
//  Created by Sean Zhang on 11/20/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import CoreData

@objc(Drawings)
public class Drawings: NSManagedObject {
    
    static let fetchRequest1: NSFetchRequest<Drawings> = {
        let fr1 = NSFetchRequest<Drawings>(entityName: "Drawings")
        let sd = NSSortDescriptor(key: "name", ascending: true)
        fr1.sortDescriptors = [sd]
        return fr1
    }()
    
    static let fetchRequest2: NSFetchRequest<Drawings> = {
        let fr2 = NSFetchRequest<Drawings>(entityName: "Drawings")
        let sd = NSSortDescriptor(key: "name", ascending: true)
        let prd = NSPredicate(format: "name CONTAINS[C] %@", "ER")
        fr2.sortDescriptors = [sd]
        fr2.predicate = prd
        return fr2
    }()
    
    static let fetchRequest3: NSFetchRequest<Drawings> = {
        let fr3 = NSFetchRequest<Drawings>(entityName: "Drawings")
        let sd = NSSortDescriptor(key: "name", ascending: true)
        let prd = NSPredicate(format: "bookmark == YES")
        fr3.sortDescriptors = [sd]
        fr3.predicate = prd
        return fr3
    }()

    static let fetchRequest4: NSFetchRequest<Drawings> = {
        let fr4 = NSFetchRequest<Drawings>(entityName: "Drawings")
        let sd = NSSortDescriptor(key: "name", ascending: true)
        let prd = NSPredicate(format: "tag CONTAINS[C] %@", "#")
        fr4.sortDescriptors = [sd]
        fr4.predicate = prd
        return fr4
    }()
    
    static let fetchRequest5: NSFetchRequest<Drawings> = {
        let fr5 = NSFetchRequest<Drawings>(entityName: "Drawings")
        let sd = NSSortDescriptor(key: "name", ascending: true)
        let prd = NSPredicate(format: "name CONTAINS[C] %@", "#")
        fr5.sortDescriptors = [sd]
        fr5.predicate = prd
        return fr5
    }()
}
