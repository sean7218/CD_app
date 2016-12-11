//
//  JSONParser.swift
//  CD_app
//
//  Created by Sean Zhang on 11/14/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import Foundation
import UIKit

class JSONParser {
    
    var json: NSArray!
    let url = Bundle.main.url(forResource: "V17494M", withExtension: ".json")

    typealias Payload = [String: AnyObject]
    
    var names = [String]()
    var details = [String]()
    var revs = [String]()
    
    init(){
        do {
            let JSONData = try Data(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            json = try JSONSerialization.jsonObject(with: JSONData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
 
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        //Convert the json file into array
        for item in json {
            let item = item as! Payload
            
            if let name = item["Document No"] as? String {
                names.append(name)
                
                if let dscrpt = item["Description"] as? String {
                    details.append(dscrpt)
                    
                    if let rev = item["Revision"] as? String {
                        revs.append(rev)
                        
                    }
                }
            }
        }
    }

}
