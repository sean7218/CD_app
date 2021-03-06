//
//  Documents.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.8
//

import Foundation
import UIKit
import AWSDynamoDB

class Documents: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _docID: String?
    var _detail: String?
    var _name: String?
    var _revision: NSNumber?
    var _systemCode: String?
    var _typeCode: String?
    
    class func dynamoDBTableName() -> String {

        return "tfavogt-mobilehub-1908441526-Documents"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_docID"
    }
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return [
               "_userId" : "userId",
               "_docID" : "docID",
               "_detail" : "detail",
               "_name" : "name",
               "_revision" : "revision",
               "_systemCode" : "systemCode",
               "_typeCode" : "typeCode",
        ]
    }
}
