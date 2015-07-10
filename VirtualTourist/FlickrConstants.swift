//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
extension FlickrClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey : String = "2be09ae2040505be5b989346137ea3e9"
        
        // MARK: URLs
        static let BaseURLSecure : String = "https://api.flickr.com/services/rest/"
        static let DataFormat : String = "json"
        static let NoJsonCallBack : String = "1"
        
        static let BOUNDING_BOX_HALF_WIDTH = 1.0
        static let BOUNDING_BOX_HALF_HEIGHT = 1.0
        static let LAT_MIN = -90.0
        static let LAT_MAX = 90.0
        static let LON_MIN = -180.0
        static let LON_MAX = 180.0
        
        
    }
    
    
    
    struct Keys {
        static let ApiKey = "api_key"
        static let DataFormat = "format"
        static let NoJsonCallBack = "nojsoncallback"
        static let Method = "method"
        static let Bbox = "bbox"
        static let PerPage = "per_page"
        static let Page = "page"
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Account
        static let search = "flickr.photos.search"
        
        
        
        
    }
    // MARK: - JSON  Keys
    struct JSONKeys {
        
        // Object
        static let Photos = "photos"
        static let Photo = "photo"
        static let Id = "id"
        static let Server = "server"
        static let Farm = "farm"
        static let Secret = "secret"
      
        
        static let Results = "results"
        
    }
    
    
}