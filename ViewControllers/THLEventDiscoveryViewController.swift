//
//  EventDiscoveryViewController.swift
//  Hype
//
//  Created by Edgar Li on 9/19/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import BoltsSwift

@objc protocol THLEventDiscoveryViewControllerDelegate {
    func eventDiscoveryViewControllerWantsToPresentDetailsForEvent(_ event: PFObject, venue: PFObject)
    func eventDiscoveryViewControllerWantsToPresentDetailsForAttendingEvent(_ event: PFObject, venue: PFObject, invite: PFObject)
}

class THLEventDiscoveryViewController: PFQueryCollectionViewController {
    
    // MARK: Init
    var delegate: THLEventDiscoveryViewControllerDelegate?

    convenience init(className: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        layout.minimumInteritemSpacing = 5.0
        self.init(collectionViewLayout: layout, className: className)
        
        title = "Sectioned Collection"
        pullToRefreshEnabled = true
        paginationEnabled = false
    }
    
    // MARK: UIViewController
    override func loadView() {
        super.loadView()
        
        collectionView?.register(THLEventDiscoveryCell.self, forCellWithReuseIdentifier: "THLEventDiscoveryCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.black
        automaticallyAdjustsScrollViewInsets = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.itemSize = CGSize(width: view.bounds.size.width - 25, height: 125)
        }
    }
    
    // MARK: Data
    
    override func queryForCollection() -> PFQuery<PFObject> {
        let query: PFQuery = super.queryForCollection()
        
        query.order(byAscending: "featured")
        query.addAscendingOrder("date")
        query.includeKey("location")
        query.includeKey("admissionOptions")
        
        query.whereKey("hidden", notEqualTo: NSNumber(value: true))
        query.whereKey("date", greaterThanOrEqualTo: Date().addingTimeInterval(-60.0 * 300.0))
        
        return query
    }
}


extension THLEventDiscoveryViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, object: PFObject?) -> THLEventDiscoveryCell? {
        let cell:THLEventDiscoveryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THLEventDiscoveryCell", for: indexPath) as! THLEventDiscoveryCell
        
        let event:THLEvent = object as! THLEvent
        cell.venueImageView.file = event.location.image
        cell.venueImageView.loadInBackground()
        cell.venueNameLabel.text = event.location.name.uppercased()
        cell.eventTitleLabel.text = event.title
        cell.venueNeighborhoodLabel.text = event.location.neighborhood.uppercased()
        
        let dateText = ((event.date! as NSDate).thl_weekdayString)
        cell.eventDateLabel.text = dateText
        
        if (event.featured == true) {
            cell.eventCategoryLabel.isHidden = false
        } else {
            cell.eventCategoryLabel.isHidden = true
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = object(at: indexPath)
        if (THLUser.current() != nil) {
            let queryFactory = THLParseQueryFactory()
            let invite: PFObject?
            do {
                invite = try queryFactory.localQueryForAcceptedInvite(forEvent: event?.objectId).getFirstObject()
                self.delegate?.eventDiscoveryViewControllerWantsToPresentDetailsForAttendingEvent(event!, venue: event?.value(forKey: "location") as! PFObject, invite: invite! as PFObject)
            } catch _ {
                invite = nil
                self.delegate?.eventDiscoveryViewControllerWantsToPresentDetailsForEvent(event!, venue: event?.value(forKey: "location") as! PFObject)

            }


        } else {
            self.delegate?.eventDiscoveryViewControllerWantsToPresentDetailsForEvent(event!, venue: event?.value(forKey: "location") as! PFObject)
        }
        
    }
}
