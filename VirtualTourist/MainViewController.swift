//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Admin on 01.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MainViewController: UIViewController,MKMapViewDelegate,NSFetchedResultsControllerDelegate {

    var touchAndHoldRecognizer: UILongPressGestureRecognizer? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Configure long tap recognizer */
        touchAndHoldRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressGestures:")
        
        //mapView
        self.mapView.addGestureRecognizer(touchAndHoldRecognizer!)
        mapView.delegate = self
        
        //fetchedResultsController
        
        fetchedResultsController.performFetch(nil)
        fetchedResultsController.delegate = self
        loadfetchedResults()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    /*fetchedResultsController ++*/
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "longitude", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
        }()
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type){
        case .Insert:
            fetchedResultsChangeInsert(anObject as! Pin)
        case .Delete:
            fetchedResultsChangeDelete(anObject as! Pin)
        case .Update:
            fetchedResultsChangeUpdate(anObject as! Pin)
        default:
            break
            
        }
        
    }

    func loadfetchedResults() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(fetchedResultsController.fetchedObjects)
    }
    
    
    func fetchedResultsChangeInsert(pin:Pin) {
        mapView.addAnnotation(pin)
    }
    func fetchedResultsChangeDelete(pin:Pin) {
        mapView.removeAnnotation(pin)
    }
    func fetchedResultsChangeUpdate(pin:Pin) {
        mapView.removeAnnotation(pin)
        mapView.addAnnotation(pin)
    }
    
    
    func handleLongPressGestures(recognizer: UILongPressGestureRecognizer) {
        
        if (self.touchAndHoldRecognizer?.isEqual(recognizer) != nil) {
           
            switch(recognizer.state) {
            case .Ended:
                
                let touchPoint = recognizer.locationInView(mapView)
                
                let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = touchMapCoordinate
                Pin(longitude: touchMapCoordinate.longitude, latitude: touchMapCoordinate.latitude, context: sharedContext)
                mapView.addAnnotation(pointAnnotation)
                CoreDataStackManager.sharedInstance().saveContext()
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegionMake(touchMapCoordinate, span)
                self.mapView.setRegion(region, animated: true)
                
            default:
                break
            }
            
            
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        
        let reuseID = "pin"
        
        var pav = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if pav == nil {
            var pav = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pav.draggable = true
            pav.canShowCallout = true
        }else{
            pav.annotation = annotation
        }
        
        return pav
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if let pin = view.annotation as? Pin{
            var controller = self.storyboard!.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
            controller.pin = pin
            
            self.showViewController(controller, sender: self)
        }
        
        
    }
    
    // would not call ???
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if (newState == MKAnnotationViewDragState.Ending)
        {
            var droppedAt = view.annotation.coordinate
            println(droppedAt)
            //NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        }
    }
    

}

