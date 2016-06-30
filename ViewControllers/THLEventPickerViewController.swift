
//  THLEventPickerViewController.swift
//  Hype
//
//  Created by Edgar Li on 6/28/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import Parse
import ParseUI


protocol THLEventPickerViewControllerDelegate {
    func eventPickerDidSelectEvent(event: PFObject)
}

class THLEventPickerViewController: PFQueryCollectionViewController {
    var delegate: THLEventPickerViewControllerDelegate?
    var venueId: String!
    var selectedEvent: PFObject!
    
    // MARK: Init
    convenience init(venueId: String!, event:PFObject?) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.init(collectionViewLayout: layout, className: "Event")
        self.venueId = venueId
        selectedEvent = event
        self.collectionView!.backgroundColor = UIColor.blackColor()
        pullToRefreshEnabled = false
        loadingViewEnabled = false
        paginationEnabled = false
        collectionView?.alwaysBounceVertical = false
    }
    
    // MARK: UIViewController
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSizeMake(90, 100)
        }
    }
    
    // MARK: Data
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        if (selectedEvent == nil) {
            selectedEvent = objects[0]
        }
    }
    
    override func queryForCollection() -> PFQuery {
        let query: PFQuery = super.queryForCollection()
        
        query.orderByAscending("date")
        query.includeKey("location")
        query.includeKey("admissionOptions")
        query.whereKey("locationId", equalTo: venueId)
        query.whereKey("date", greaterThanOrEqualTo: NSDate())
        
        return query
    }
    
    // MARK: CollectionView
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath, object: object)
        cell?.textLabel.textAlignment = .Center
        
        let date = object?["date"] as! NSDate
        
        cell?.textLabel.text = "\(date.thl_weekdayInitials())\n\n\(date.thl_dayString)"
        cell?.textLabel.textAlignment = .Center
        
        cell?.textLabel.textColor = UIColor.whiteColor()
        
        cell?.contentView.backgroundColor = UIColor.blackColor()
        
        if (objectAtIndexPath(indexPath) == selectedEvent) {
            collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            self.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.cornerRadius = 5.0
            
            cell?.contentView.layer.borderColor = UIColor.customGoldColor().CGColor
        }
        
        return cell
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)

        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.cornerRadius = 5.0
        
        cell?.contentView.layer.borderColor = UIColor.customGoldColor().CGColor
        
        let object = objectAtIndexPath(indexPath)
        delegate?.eventPickerDidSelectEvent(object!)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView .cellForItemAtIndexPath(indexPath)
        cell?.contentView.layer.borderWidth = 0.0
    }
    
}