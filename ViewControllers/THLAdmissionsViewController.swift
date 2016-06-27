//
//  THLAdmissionsViewController.swift
//  Hype
//
//  Created by Edgar Li on 6/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

let admissionOptionCollectionView = UICollectionView()
let eventCollectionView = UICollectionView()
let admissionOptionCollectionViewIdentifier = "AdmissionOptionCollectionViewControllerCell"
let eventCollectionViewIdentifier = "EventCollectionViewControllerCell"

var events = [PFObject]()
var admissionOptions = [PFObject]()

class THLAdmissionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //  MARK: -
    //  MARK: Init
    var venue: PFObject = PFObject()
    var event: PFObject = PFObject()

    
    convenience init(venue: PFObject, event: PFObject) {
        self.init()
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.venue = venue
        self.event = event
    }
    
    //  MARK: -
    //  MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        
        // Initialize the collection views, set the desired frames
        admissionOptionCollectionView.delegate = self
        eventCollectionView.delegate = self
        
        admissionOptionCollectionView.registerClass(THLAdmissionOptionCell.self, forCellWithReuseIdentifier: admissionOptionCollectionViewIdentifier)
        
        eventCollectionView.registerClass(THLPerkStoreCell.self, forCellWithReuseIdentifier: eventCollectionViewIdentifier)
        
        admissionOptionCollectionView.dataSource = self
        eventCollectionView.dataSource = self
        
        self.view.addSubview(admissionOptionCollectionView)
        self.view.addSubview(eventCollectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadObjects()
    }
    
    override func viewDidAppear(animated: Bool) {
//        loadCollectionViewData()
    }
    
    
//  MARK: -
//  MARK: Responding to events

    func objectsWillLoad() {
        
    }
    
    func objectsDidLoad(error: NSError ) {
//    [self _refreshLoadingView];
//        firstLoad = NO;
    }
    
    //  MARK: -
    //  MARK: Accessing Results
    

    //  MARK: -
    //  MARK: Loading data
    func loadObjects() {
        var query = PFQuery(className:"Event")
        // Fetch data from the parse platform
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            
            // The find succeeded now rocess the found objects into the countries array
            if error == nil {
                
                // Clear existing country data
                events.removeAll(keepCapacity: true)
                admissionOptions.removeAll(keepCapacity: true)

                // Add country objects to our array
                if let objects = objects as? [PFObject] {
                    countries = Array(objects.generate())
                }
                
                // reload our data into the collection view
                self.collectionView.reloadData()
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }    }
    
    /*
     ==========================================================================================
     UICollectionView protocol required methods
     ==========================================================================================
     */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == eventCollectionView {
            return events.count
        }
        
        return admissionOptions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        if collectionView == eventCollectionViewController {
//            let cellA = collectionView.dequeueReusableCellWithReuseIdentifier(eventCollectionViewControllerIdentifier) as UICollectionViewCell
//            
//            // Set up cell
//            return cellA
//        }
//            
//        else {
//            let cellB = collectionView.dequeueReusableCellWithReuseIdentifier(admissionOptionCollectionViewControllerIdentifier) as UICollectionViewCell
//            
//            // ...Set up cell
//            
//            return cellB
//        }
        return UICollectionViewCell()
    }
    /*
     ==========================================================================================
     Process memory issues
     To be completed
     ==========================================================================================
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}