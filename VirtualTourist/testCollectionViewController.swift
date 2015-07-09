//
//  testCollectionViewController.swift
//  VirtualTourist
//
//  Created by Admin on 06.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit


class testCollectionViewController:UICollectionViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var myImage = UIImage(named: "Apple_Swift_Logo")
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1
        // Return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        // Return the number of items in the section
        return 100
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewPhotoCell
        
        // Configure the cell
        
        cell.imageView.image = myImage
        return cell
    }
    
    
}