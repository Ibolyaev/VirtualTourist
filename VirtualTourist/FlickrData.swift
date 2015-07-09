//
//  FlickrData.swift
//  VirtualTourist
//
//  Created by Admin on 09.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import CoreData

extension FlickrClient {
    
    func loadPhotosByPlaceFlickr(pin: Pin, sharedContext: NSManagedObjectContext,completionHandler: (result: Bool, error: NSError?) -> Void) {
        
        //clear photos before upload new one
        
        var loadedPage = pin.loadedPage
        
        //currentResaultPage++
        
        var parameters = [FlickrClient.Keys.ApiKey:FlickrClient.Constants.ApiKey,
            FlickrClient.Keys.DataFormat:FlickrClient.Constants.DataFormat,
            FlickrClient.Keys.NoJsonCallBack:FlickrClient.Constants.NoJsonCallBack,
            FlickrClient.Keys.Method:FlickrClient.Methods.search,
            "text":"panda",
            "per_page":"6",
            "page":"\(loadedPage)"]
        
        FlickrClient.sharedInstance().taskForGetMethod(FlickrClient.Methods.search, parameters: parameters) { (result, error) -> Void in
            
            if let parsedResult = result as? NSDictionary {
                
                if let photosDictionary = parsedResult.valueForKey(FlickrClient.JSONKeys.Photos) as? NSDictionary {
                    if let photoArray = photosDictionary.valueForKey(FlickrClient.JSONKeys.Photo) as? [[String: AnyObject]] {
                        
                        
                        
                        var photos = photoArray.map() { (dictionary: [String : AnyObject]) -> Photo in
                            let photo = Photo(pin: pin,dictionary: dictionary, context: sharedContext)
                            
                            return photo
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            completionHandler(result: true, error: nil)
                            pin.loadedPage = loadedPage.integerValue + 1
                            CoreDataStackManager.sharedInstance().saveContext()
                            println("Loaded: \(pin.loadedPage)")
                            
                        }
                        
                        
                    }
                    
                }
                
            }else{
                completionHandler(result: false, error: error)
                
            }
            
        }
        
    }
    
    
}

