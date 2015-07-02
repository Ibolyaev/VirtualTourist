//
//  Pin.swift
//  VirtualTourist
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import MapKit
import CoreData



@objc(Pin)

class Pin: NSManagedObject,MKAnnotation {
    
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    
    var coordinate: CLLocationCoordinate2D {
        var coord = CLLocationCoordinate2D(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
        
        return coord
    }
    // 5. Include this standard Core Data init method.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(longitude: NSNumber, latitude: NSNumber, context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        self.longitude = longitude
        self.latitude  = latitude
        
        
    }

    
}

