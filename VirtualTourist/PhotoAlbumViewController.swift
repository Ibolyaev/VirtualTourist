//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumViewController:UIViewController  {
    
    var pin:Pin?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.addAnnotation(pin)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(pin!.coordinate, span)
        self.mapView.setRegion(region, animated: true)

        
    }
    
}