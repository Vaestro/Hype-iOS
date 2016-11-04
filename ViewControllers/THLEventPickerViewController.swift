
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
    func eventPickerDidSelectEvent(_ event: PFObject)
}

class THLEventPickerViewController: PFQueryCollectionViewController {
    var delegate: THLEventPickerViewControllerDelegate?
    var venueId: String!
    var selectedEvent: PFObject!

    // MARK: Init
    convenience init(venueId: String!, event: PFObject?) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.init(collectionViewLayout: layout, className: "Event")
        self.venueId = venueId
        selectedEvent = event
        self.collectionView!.backgroundColor = UIColor.black
        pullToRefreshEnabled = false
        loadingViewEnabled = false
        paginationEnabled = false
        collectionView?.alwaysBounceVertical = false
    }

    // MARK: UIViewController

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 90, height: 100)
        }
    }

    // MARK: Data

    override func objectsDidLoad(_ error: Error?) {
        super.objectsDidLoad(error)

        if (selectedEvent == nil) {
            selectedEvent = objects[0]
        }
    }

    override func queryForCollection() -> PFQuery<PFObject> {
        let query: PFQuery = super.queryForCollection()

        query.order(byAscending: "date")
        query.includeKey("location")
        query.includeKey("admissionOptions")
        query.whereKey("locationId", equalTo: venueId)
        query.whereKey("date", greaterThanOrEqualTo: Date().addingTimeInterval(-60.0 * 300.0))

        return query
    }

    // MARK: CollectionView

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath, object: object)
        cell?.textLabel.textAlignment = .center

        let date = object?.value(forKey: "date") as? Date
        let dateInitials:String = (date! as NSDate).thl_weekdayInitials() as String!
        let dayString:String = (date! as NSDate).thl_dayString as String!

        cell?.textLabel.text = "\(dateInitials)\n\n\(dayString)"
        cell?.textLabel.textAlignment = .center

        cell?.textLabel.textColor = UIColor.white

        cell?.contentView.backgroundColor = UIColor.black

        if (self.object(at: indexPath) == selectedEvent) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
            self.collectionView(collectionView, didSelectItemAt: indexPath)
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.cornerRadius = 5.0

            cell?.contentView.layer.borderColor = UIColor.customGoldColor().cgColor
        }

        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.cornerRadius = 5.0

        cell?.contentView.layer.borderColor = UIColor.customGoldColor().cgColor

        let object = self.object(at: indexPath)
        delegate?.eventPickerDidSelectEvent(object!)
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView .cellForItem(at: indexPath)
        cell?.contentView.layer.borderWidth = 0.0
    }

}
