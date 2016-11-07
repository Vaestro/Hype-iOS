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

class SimpleCollectionReusableView : UICollectionReusableView {
    let titleLabel: UILabel = UILabel(frame: CGRect.zero)
    let subtitleLabel: UILabel = UILabel(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Raleway-ExtraBold", size: 14)
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.font = UIFont(name: "Raleway-Regular", size: 14)

        addSubview(titleLabel)
        addSubview(subtitleLabel)

    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x:10,y:10,width:frame.size.width,height:20)
        subtitleLabel.frame = CGRect(x:10,y:30,width:frame.size.width,height:20)
    }
}

class THLEventDiscoveryViewController: PFQueryCollectionViewController {
    
    // MARK: Init
    var delegate: THLEventDiscoveryViewControllerDelegate?
    var sections: [Int: [PFObject]] = Dictionary()
    var sectionKeys: [Int] = Array()

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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.black
        automaticallyAdjustsScrollViewInsets = true
        
        collectionView?.register(THLEventDiscoveryCell.self, forCellWithReuseIdentifier: "THLEventDiscoveryCell")
        collectionView?.register(SimpleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")

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
    
    // MARK: Data
    override func objectsDidLoad(_ error: Error?) {
        super.objectsDidLoad(error)
        
        sections.removeAll(keepingCapacity: false)
        if let objects = objects as? [PFObject] {
            for object in objects {
                let date = (object["date"] as? Date)
                let day = Calendar.current.component(.day, from: date!)
                var array = sections[day] ?? Array()
                array.append(object)
                sections[day] = array
            }
        }
        sectionKeys = sections.keys.sorted(by: <)
        
        collectionView?.reloadData()
    }

    override func object(at indexPath: IndexPath?) -> PFObject? {
        if let indexPath = indexPath {
            let array = sections[sectionKeys[indexPath.section]]
            return array?[indexPath.row]
        }
        return nil
    }

}


extension THLEventDiscoveryViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let array = sections[sectionKeys[section]]
        return array?.count ?? 0
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, object: PFObject?) -> THLEventDiscoveryCell? {
        let cell:THLEventDiscoveryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THLEventDiscoveryCell", for: indexPath) as! THLEventDiscoveryCell
        
        let event:THLEvent? = object as? THLEvent
        cell.venueImageView.file = event?.location?.image
        cell.venueImageView.loadInBackground()
        cell.venueNameLabel.text = event?.location?.name.uppercased()
        cell.eventTitleLabel.text = event?.title
        cell.venueNeighborhoodLabel.text = event?.location?.neighborhood.uppercased()
        
        let dateText = ((event?.date as! NSDate).thl_weekdayString)
        cell.eventDateLabel.text = dateText
        
        if (event?.featured == true) {
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
    

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SimpleCollectionReusableView {
            let event = object(at: indexPath) as? PFObject!
            let date:NSDate = event?.value(forKey:"date") as! NSDate
            
            view.titleLabel.text = date.thl_dayOfTheWeek().uppercased()
            view.subtitleLabel.text = date.thl_dateString.uppercased()
            return view
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }

    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if sections.count > 0 {
            return CGSize(width: collectionView.bounds.width, height: 55.0)
        }
        return CGSize.zero
    }
}
