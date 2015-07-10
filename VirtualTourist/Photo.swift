//
//  Photo.swift
//  VirtualTourist
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit



@objc(Photo)

class Photo: NSManagedObject {
    //You can construct the source URL to a photo once you know its ID, server ID, farm ID and secret, as returned by many API methods.
    @NSManaged var pin: Pin
    @NSManaged var imagePath: String?
    @NSManaged var id: String
    @NSManaged var server: String
    @NSManaged var farm: NSNumber
    @NSManaged var secret: String
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(pin:Pin, dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        self.pin = pin
        
        self.id = dictionary[FlickrClient.JSONKeys.Id] as! String
        self.server = dictionary[FlickrClient.JSONKeys.Server] as! String
        self.farm = dictionary[FlickrClient.JSONKeys.Farm] as! Int
        self.secret = dictionary[FlickrClient.JSONKeys.Secret] as! String
        
                
        self.imagePath = "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret).jpg"
        
    }
    
    
    var image: UIImage? {
        get {
            return FlickrClient.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        
        set {
            FlickrClient.Caches.imageCache.storeImage(newValue, withIdentifier: imagePath!)
        }
    }

    
}