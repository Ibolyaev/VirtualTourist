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
import CoreData

class PhotoAlbumViewController:UIViewController, NSFetchedResultsControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate  {
    
    var pin:Pin?
    
    var loadedImages = 0
    
    var selectedPhotos = [Photo]()
    
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin!);
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
        }()
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.collectionView.allowsMultipleSelection = true
        
        
    }
    
    
    func loadNewPhotos() {
        
        self.newCollectionButton.enabled = false
        self.loadedImages = 0
        
        FlickrClient.sharedInstance().loadPhotosByPlaceFlickr(pin!, sharedContext: sharedContext) { (result, error) -> Void in
            
            
            if let error = error {
                self.displayError(error.localizedDescription,titleError: "Failed to load flickr photos")
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.collectionView.reloadData()
                    
                    
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.addAnnotation(pin)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(pin!.coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        fetchedResultsController.performFetch(nil)
        fetchedResultsController.delegate = self
        
        
    }
    
    @IBAction func newCollectionTouchUpInside(sender: UIButton) {
        
        if selectedPhotos.count > 0 {
            for element in selectedPhotos {
                
                sharedContext.deleteObject(element)
                //need to delete local files as well
                FlickrClient.Caches.imageCache.storeImage(nil, withIdentifier: element.imagePath!)
                CoreDataStackManager.sharedInstance().saveContext()
                
            }
        }else{
            
            ClearPhotoContext()
            loadNewPhotos()
        }
        selectedPhotos.removeAll(keepCapacity: false)
        updateNewCollectionButton()
        
    }
    
    func ClearPhotoContext() {
        
        if let countOfElements = fetchedResultsController.fetchedObjects?.count {
            
            if let fetchedObjects = fetchedResultsController.fetchedObjects {
                
                for el in fetchedObjects {
                    sharedContext.deleteObject(el as! NSManagedObject)
                    FlickrClient.Caches.imageCache.storeImage(nil, withIdentifier: el.imagePath!!)
                    CoreDataStackManager.sharedInstance().saveContext()
                }
                
            }
            
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            
            if let indexPath = indexPath {
                collectionView.insertItemsAtIndexPaths(NSArray(object: indexPath) as [AnyObject])
            }
            
            
        case .Delete:
            collectionView.deleteItemsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject])
            
            
        case .Update:
            
            let photoObject = fetchedResultsController.objectAtIndexPath(indexPath!) as! Photo
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! CollectionViewPhotoCell
            
            
            configureCell(cell, photo: photoObject)
            
        case .Move:
            collectionView.deleteItemsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject])
            collectionView.insertItemsAtIndexPaths(NSArray(object: newIndexPath!) as [AnyObject])
            
        default:
            return
        }
        
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                collectionView.insertSections(NSIndexSet(index: sectionIndex))
                
            case .Delete:
                collectionView.deleteSections(NSIndexSet(index: sectionIndex))
                
            default:
                return
            }
    }
    
    
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        //self.collectionView.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let sectionInfo = self.fetchedResultsController.sections![section] as?
            NSFetchedResultsSectionInfo {
                
                return sectionInfo.numberOfObjects
                
        }
        
        return 100
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let photoObject = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! CollectionViewPhotoCell
        
        configureCell(cell, photo: photoObject)
                
        return cell
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! CollectionViewPhotoCell
        
        if cell.selected {
            
            selectedPhotos.append(fetchedResultsController.objectAtIndexPath(indexPath) as! Photo)
            
        }
        
        
        updateNewCollectionButton()
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
       let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! CollectionViewPhotoCell
        
        if !cell.selected {
            
            if let foundIndex = find(selectedPhotos, fetchedResultsController.objectAtIndexPath(indexPath) as! Photo) {
                selectedPhotos.removeAtIndex(foundIndex)
                
            }
        }
        
        updateNewCollectionButton()
        
    }
    
    func updateNewCollectionButton() {
        
        if selectedPhotos.count > 0 {
            
            newCollectionButton.setTitle("Remove selected pictures", forState: UIControlState.Normal)}
            
        else{
            
            newCollectionButton.setTitle("New collection", forState: UIControlState.Normal)
        }
        
        
    }
    
    
    func displayError(errorString: String?,titleError: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                
                let alertController = UIAlertController(title: titleError, message: "\(errorString)", preferredStyle: .Alert)
                
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
        })
    }
    
    // MARK: - Configure Cell
    
    func configureCell(cell: CollectionViewPhotoCell, photo: Photo) {
        var image = UIImage(named: "posterPlaceHoldr")
        
        cell.imageView!.image = nil
        
        if photo.imagePath == nil || photo.imagePath == "" {
            image = UIImage(named: "noImage")
        } else if photo.image != nil {
            image = photo.image
        }
            
        else {
            
            cell.activityIndicator.hidden = false
            cell.activityIndicator.startAnimating()
            // Start the task that will eventually download the image
            let task = FlickrClient.sharedInstance().taskForImageWithSize(photo.imagePath!) { data, error in
                
                if let error = error {
                    self.displayError(error.localizedDescription, titleError: "Photo download error")
                    
                }
                
                if let data = data {
                    // Craete the image
                    let image = UIImage(data: data)
                    
                    // update the model, so that the infrmation gets cashed
                    photo.image = image
                    
                    // update the cell later, on the main thread
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.activityIndicator.stopAnimating()
                        cell.imageView!.image = image
                        self.loadedImages++
                        if self.loadedImages == self.fetchedResultsController.fetchedObjects?.count {
                            self.newCollectionButton.enabled = true
                        }
                        
                    }
                }
            }
            
         }
        
        cell.imageView!.image = image
        
        

        
    }
    
    
}