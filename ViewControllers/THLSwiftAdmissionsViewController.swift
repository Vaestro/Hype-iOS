//
//  THLAdmissionsViewController.swift
//  Hype
//
//  Created by Edgar Li on 6/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

@objc protocol THLSwiftAdmissionsViewControllerDelegate {
    func didSelectAdmissionOption(admissionOption: PFObject, event: PFObject)
}

class THLSwiftAdmissionsViewController: UIViewController, THLEventPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    //  MARK: -
    //  MARK: Init
    var delegate: THLSwiftAdmissionsViewControllerDelegate?

    var eventPickerView: THLEventPickerViewController
    var admissionOptionCollectionView: UICollectionView
    
    var venue: PFObject
    var event: PFObject
    var admissionOptions: [PFObject]
    
    var sections: [Int: [PFObject]] = Dictionary()
    var sectionKeys: [Int] = Array()

    var navBarTitleView: THLEventNavBarTitleView
    
    let layout: UICollectionViewFlowLayout
    
    let reusableViewIdentifier = "header"
    let admissionOptionCollectionViewIdentifier = "AdmissionOptionCollectionViewControllerCell"
    let tablePackageAdmissionCollectionViewIdentifier = "TablePackageAdmissionCollectionViewControllerCell"

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(venue: PFObject, event: PFObject) {
        self.venue = venue
        self.event = event
        self.admissionOptions = Array()
        
        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
        layout.minimumInteritemSpacing = 5.0;
        
        admissionOptionCollectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: layout)
        eventPickerView = THLEventPickerViewController(venueId: venue.objectId, event: event)
        navBarTitleView = THLEventNavBarTitleView.init(venueName: venue["name"] as? String, date: event["date"] as? NSDate)

        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .Plain, target: self, action: #selector(dismiss))

        eventPickerView.delegate = self
        
    }
    
    
    //  MARK: -
    //  MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        admissionOptionCollectionView.delegate = self
        admissionOptionCollectionView.dataSource = self
        admissionOptionCollectionView.emptyDataSetSource = self
        admissionOptionCollectionView.emptyDataSetDelegate = self
        
        admissionOptionCollectionView.registerClass(THLAdmissionOptionCell.self, forCellWithReuseIdentifier: admissionOptionCollectionViewIdentifier)
        admissionOptionCollectionView.registerClass(THLTablePackageAdmissionCell.self, forCellWithReuseIdentifier: tablePackageAdmissionCollectionViewIdentifier)
        admissionOptionCollectionView.registerClass(THLCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusableViewIdentifier)
        
        self.view.addSubview(eventPickerView.view)
        self.view.addSubview(admissionOptionCollectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = navBarTitleView
    }
    
    override func viewDidLayoutSubviews() {
        self.eventPickerView.view.frame.size.height = 100.0;
        admissionOptionCollectionView.frame = CGRectMake(0, 0 + eventPickerView.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - eventPickerView.view.frame.size.height)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout.itemSize = CGSizeMake(self.view.frame.size.width - 25, 55);
        layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(admissionOptionCollectionView.bounds), 70.0);
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //  MARK: -
    //  MARK: Data
    
    func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        if let indexPath = indexPath {
            let array = sections[sectionKeys[indexPath.section]]
            return array?[indexPath.row]
        }
        return nil
    }
    
    //  MARK: -
    //  MARK: Responding to events
    
    func eventPickerDidSelectEvent(event: PFObject) {
        self.event = event
        if let eventAdmissionOptions = event["admissionOptions"] as! [PFObject]? {
            admissionOptions = eventAdmissionOptions
            admissionOptionsDidLoad()
        }
    
        let date = event["date"] as? NSDate
        navBarTitleView.dateLabel.text = date!.thl_weekdayString
    }
    
    func admissionOptionsDidLoad() {
        sections.removeAll(keepCapacity: false)
        for option in admissionOptions {
            let type = (option["type"] as? Int) ?? 0
            var array = sections[type] ?? Array()
            array.append(option)
            sections[type] = array
        }
        sectionKeys = sections.keys.sort(<)
        
        admissionOptionCollectionView.reloadData()

    }

    /*
     ==========================================================================================
     UICollectionView protocol required methods
     ==========================================================================================
     */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let array = sections[sectionKeys[section]]
        return array?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let admissionOption:PFObject! = objectAtIndexPath(indexPath)
        
        if (admissionOption["type"].integerValue == 0) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(admissionOptionCollectionViewIdentifier, forIndexPath: indexPath) as!THLAdmissionOptionCell
                cell.titleLabel.text = admissionOption["name"] as? String
            
                if (admissionOption["price"].floatValue == 0.0) {
                    cell.priceLabel.text = "FREE"
                } else {
                    cell.priceLabel.text = NSString(format: "%.2f", admissionOption["price"].floatValue) as String
                }
            return cell;
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(tablePackageAdmissionCollectionViewIdentifier, forIndexPath: indexPath) as!THLTablePackageAdmissionCell
            cell.titleLabel.text = admissionOption["name"] as? String
            cell.priceLabel.text = "\(admissionOption["price"].integerValue) total"
            cell.partySizeLabel.text = "\(admissionOption["partySize"].integerValue) people"
            cell.perPersonLabel.text = NSString(format: "%.f/person", admissionOption["price"].floatValue/admissionOption["partySize"].floatValue) as String

            return cell
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let reusableView = admissionOptionCollectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reusableViewIdentifier, forIndexPath: indexPath) as! THLCollectionReusableView
        switch kind {
            case UICollectionElementKindSectionHeader:
            
                switch (sectionKeys[indexPath.section]) {
                    case 0:
                        reusableView.label.text = "TICKETS"
                        reusableView.subtitleLabel.text = nil
                    case 1:
                        reusableView.label.text = "TABLE & BOTTLE SERVICE"
                        reusableView.subtitleLabel.text = nil
                    default:
                        assert(false, "Unexpected admission option type")
                    }
                return reusableView
            default:
                return reusableView
            }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let admissionOption = objectAtIndexPath(indexPath)
        if (admissionOption!["type"].integerValue == 0 && admissionOption!["gender"].integerValue != THLUser.currentUser()!.sex.rawValue) {
            return displayTicketGenderError()
        }
        
        delegate?.didSelectAdmissionOption(admissionOption!, event: event)
    }

    
    func displayTicketGenderError() {
        let alert:UIAlertView = UIAlertView.init(title: "Error", message: "Please select the ticket that corresponds to your gender", delegate: self, cancelButtonTitle: "OK")
        alert.show()
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

    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        let str = "No Admission Options Available"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString {
        let str = "Please check another event or contact your concierge for help"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}