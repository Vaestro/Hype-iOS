//
//  THLVenueDiscoveryViewController.swift
//  Hype
//
//  Created by Edgar Li on 6/21/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import ParseUI

class THLVenueDiscoveryViewController: PFQueryCollectionViewController {
    
    // MARK: Init
    
    convenience init(className: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        layout.minimumInteritemSpacing = 5.0
        self.init(collectionViewLayout: layout, className: className)
        self.collectionView!.backgroundColor = UIColor.blackColor();
        title = "VENUES"
        pullToRefreshEnabled = true
        paginationEnabled = false
    }
    
    // MARK: UIViewController
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView!.registerNib(UINib(nibName: "THLVenueDiscoveryViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView!.registerClass(THLVenueDiscoveryViewCell.self, forCellWithReuseIdentifier: "Cell")

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let bounds = UIEdgeInsetsInsetRect(view.bounds, layout.sectionInset)
//            let sideLength = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0 - layout.minimumInteritemSpacing
            layout.itemSize = CGSizeMake(CGRectGetWidth(bounds), CGRectGetWidth(bounds)*0.40)
        }
    }
    
    // MARK: Data
    
    override func queryForCollection() -> PFQuery {
        return super.queryForCollection().orderByAscending("priority")
    }
    
    // MARK: CollectionView
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        let cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? THLVenueDiscoveryViewCell
        cell?.venueImageView.file = object?["image"] as? PFFile
        if cell?.venueImageView.image == nil {
            cell?.venueImageView.loadInBackground()
        }
        
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return cell
    }
    
}