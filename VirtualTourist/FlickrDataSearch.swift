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
            FlickrClient.Keys.Bbox:createBoundingBoxString(pin),
            FlickrClient.Keys.PerPage:"6",
            FlickrClient.Keys.Page:"\(loadedPage)"]
        
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
                            
                            
                        }
                        
                        
                    }
                    
                }
                
            }else{
                completionHandler(result: false, error: error)
                
            }
            
        }
        
    }
    
    func createBoundingBoxString(pin:Pin) -> String {
        
        let latitude = pin.latitude.doubleValue
        let longitude = pin.longitude.doubleValue
        
        
        let bottom_left_lon = max(longitude - FlickrClient.Constants.BOUNDING_BOX_HALF_WIDTH, FlickrClient.Constants.LON_MIN)
        let bottom_left_lat = max(latitude - FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LAT_MIN)
        let top_right_lon = min(longitude + FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LON_MAX)
        let top_right_lat = min(latitude + FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
}

