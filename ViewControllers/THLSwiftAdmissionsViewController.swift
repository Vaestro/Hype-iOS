//
//  THLAdmissionsViewController.swift
//  Hype
//
//  Created by Edgar Li on 6/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLSwiftAdmissionsViewController: UIViewController, THLEventPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    //  MARK: -
    //  MARK: Init
    var eventPickerView: THLEventPickerViewController
    var admissionOptionCollectionView: UICollectionView
    
    var venue: PFObject
    var event: PFObject
    var admissionOptions: [PFObject]
    
    var sections: [Int: [PFObject]] = Dictionary()
    var sectionKeys: [Int] = Array()

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

        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .Plain, target: self, action: #selector(dismiss))
        eventPickerView.delegate = self
    }
    
    
    //  MARK: -
    //  MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        admissionOptionCollectionView.delegate = self
        admissionOptionCollectionView.dataSource = self

        admissionOptionCollectionView.registerClass(THLAdmissionOptionCell.self, forCellWithReuseIdentifier: admissionOptionCollectionViewIdentifier)
        admissionOptionCollectionView.registerClass(THLTablePackageAdmissionCell.self, forCellWithReuseIdentifier: tablePackageAdmissionCollectionViewIdentifier)
        admissionOptionCollectionView.registerClass(THLCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusableViewIdentifier)
        
        self.view.addSubview(eventPickerView.view)
        self.view.addSubview(admissionOptionCollectionView)
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
        admissionOptions = event["admissionOptions"] as! [PFObject]
        
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

        switch kind {
            case UICollectionElementKindSectionHeader:
                let reusableView = admissionOptionCollectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reusableViewIdentifier, forIndexPath: indexPath) as! THLCollectionReusableView
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
                assert(false, "Unexpected element kind")
            }
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