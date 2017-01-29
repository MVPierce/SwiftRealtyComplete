//
//  Listing.swift
//  SwiftRealty
//
//  Created by Pierce on 1/24/17.
//  Copyright © 2017 Pierce. All rights reserved.
//

import Foundation

class Listing: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var address: String = ""
    var price: Double = 0.0
    var imageFilename: String = ""      //  -|
    var s3BucketName: String = ""       //  _| Take note at how these have replaced our original image property
    var numberOfBedrooms: Int = 0
    var numberOfBathrooms: Int = 0
    var squareFootage: Double = 0.0
    var hasPool: Bool = false
    var id: Int = 0
    
    class func dynamoDBTableName() -> String {
        return "SRListings"
    }
    
    class func hashKeyAttribute() -> String {
        return "id"
    }
    
}

