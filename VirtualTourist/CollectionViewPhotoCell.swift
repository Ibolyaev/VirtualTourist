//
//  CollectionViewPhotoCell.swift
//  VirtualTourist
//
//  Created by Admin on 06.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewPhotoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func awakeFromNib() {
        
        let customColorView = UIView(frame: self.bounds)
        customColorView.backgroundColor = UIColor(red: 188/255.0, green: 0, blue: 0, alpha: 0.5)
        self.selectedBackgroundView =  customColorView
        
        
        
    }
    
    override func prepareForReuse() {
        
        self.selected = false
        
    }
    
}
