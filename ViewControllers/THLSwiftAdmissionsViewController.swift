//
//  THLAdmissionsViewController.swift
//  Hype
//
//  Created by Edgar Li on 6/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import TTTAttributedLabel

@objc protocol THLSwiftAdmissionsViewControllerDelegate {
    func didSelectAdmissionOption(_ admissionOption: PFObject, event: PFObject)
    func didSelectHypeConnectForEvent(_ event:PFObject)
}

class THLSwiftAdmissionsViewController: UIViewController, THLEventPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TTTAttributedLabelDelegate {

    //  MARK: -
    //  MARK: Init
    var delegate: THLSwiftAdmissionsViewControllerDelegate?

    var eventPickerView: THLEventPickerViewController
    var admissionOptionCollectionView: UICollectionView

    var venue: PFObject
    var event: PFObject?
    var admissionOptions: [PFObject]

    var sections: [Int: [PFObject]] = Dictionary()
    var sectionKeys: [Int] = Array()

    var navBarTitleView: THLEventNavBarTitleView
    var contactConciergeLabel: TTTAttributedLabel
    let layout: UICollectionViewFlowLayout

    let reusableViewIdentifier = "header"
    let admissionOptionCollectionViewIdentifier = "AdmissionOptionCollectionViewControllerCell"
    let tablePackageAdmissionCollectionViewIdentifier = "TablePackageAdmissionCollectionViewControllerCell"

    var buttonBackground: UIView
    var separatorView: UIView

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(venue: PFObject, event: PFObject?) {
        self.venue = venue
        self.event = event
        self.admissionOptions = Array()

        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        layout.minimumInteritemSpacing = 5.0

        admissionOptionCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        eventPickerView = THLEventPickerViewController(venueId: venue.objectId, event: event)
        navBarTitleView = THLEventNavBarTitleView.init(venueName: venue["name"] as? String, date: event?["date"] as? Date)

        contactConciergeLabel = TTTAttributedLabel.init(frame:CGRect.zero)
        buttonBackground = UIView()
        separatorView = UIView()

        super.init(nibName: nil, bundle: nil)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(THLSwiftAdmissionsViewController.dismiss as (THLSwiftAdmissionsViewController) -> () -> ()))
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

        admissionOptionCollectionView.register(THLAdmissionOptionCell.self, forCellWithReuseIdentifier: admissionOptionCollectionViewIdentifier)
        admissionOptionCollectionView.register(THLTablePackageAdmissionCell.self, forCellWithReuseIdentifier: tablePackageAdmissionCollectionViewIdentifier)
        admissionOptionCollectionView.register(THLCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusableViewIdentifier)

        self.view.addSubview(eventPickerView.view)
        self.view.addSubview(admissionOptionCollectionView)

        buttonBackground.backgroundColor = UIColor.black
        self.view!.addSubview(buttonBackground)

        separatorView.backgroundColor = UIColor.gray
        buttonBackground.addSubview(separatorView)

        self.contactConciergeLabel = TTTAttributedLabel.init(frame: CGRect.zero)
        self.contactConciergeLabel.textColor = UIColor.white
        self.contactConciergeLabel.font = UIFont(name: "Raleway-Bold", size: 16)
        self.contactConciergeLabel.numberOfLines = 0
        self.contactConciergeLabel.linkAttributes = [NSForegroundColorAttributeName: UIColor.white, NSUnderlineColorAttributeName: UIColor.customGoldColor(), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleThick.rawValue]
        self.contactConciergeLabel.activeLinkAttributes = [NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue]
        self.contactConciergeLabel.textAlignment = .left
        let labelText: NSString! = "OR GO WITH A HOST"
        self.contactConciergeLabel.text = labelText as String
        let concierge: NSRange = labelText.range(of: "HOST")
        contactConciergeLabel.addLink(to: URL(string: "action://show-intercom")!, with: concierge)
        self.contactConciergeLabel.delegate = self
        contactConciergeLabel.sizeToFit()

        buttonBackground.addSubview(self.contactConciergeLabel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = navBarTitleView
    }

    override func viewDidLayoutSubviews() {
        self.eventPickerView.view.frame.size.height = 100.0

        admissionOptionCollectionView.frame = CGRect(x: 0, y: 0 + eventPickerView.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - eventPickerView.view.frame.size.height - 80.0)
        buttonBackground.frame = CGRect(x: 0, y: eventPickerView.view.frame.size.height + admissionOptionCollectionView.frame.size.height, width: view.frame.size.width, height: 80.0)
        separatorView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0.5)

        contactConciergeLabel.center = buttonBackground .convert(buttonBackground.center, from: buttonBackground.superview)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout.itemSize = CGSize(width: self.view.frame.size.width - 25, height: 55)
        layout.headerReferenceSize = CGSize(width: admissionOptionCollectionView.bounds.width, height: 70.0)
    }

    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    //  MARK: -
    //  MARK: Data

    func objectAtIndexPath(_ indexPath: IndexPath?) -> PFObject? {
        if let indexPath = indexPath {
            let array = sections[sectionKeys[(indexPath as NSIndexPath).section]]
            return array?[(indexPath as NSIndexPath).row]
        }
        return nil
    }

    //  MARK: -
    //  MARK: Responding to events

    func eventPickerDidSelectEvent(_ event: PFObject) {
        self.event = event
        if let eventAdmissionOptions = event["admissionOptions"] as! [PFObject]? {
            admissionOptions = eventAdmissionOptions
            admissionOptionsDidLoad()
        }

        let date = event["date"] as? Date
        navBarTitleView.dateLabel.text = (date! as NSDate).thl_weekdayString
    }

    func admissionOptionsDidLoad() {
        sections.removeAll(keepingCapacity: false)
        for option in admissionOptions {
            let type = (option["type"] as? Int) ?? 0
            var array = sections[type] ?? Array()
            array.append(option)
            sections[type] = array
        }
        sectionKeys = sections.keys.sorted(by: <)

        admissionOptionCollectionView.reloadData()

    }

    func attributedLabel(_ label: TTTAttributedLabel, didSelectLinkWith url: URL) {
        if (url.scheme?.hasPrefix("action"))! {
            if url.host!.hasPrefix("show-intercom") {
                self.messageButtonPressed()
            } else {
                /* deal with http links here */
                /* deal with http links here */
            }
        }
    }

    func messageButtonPressed() {
        if(THLUser.current()?.value(forKey: "image") == nil){
            let vc = THLProfilePicChooserViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.delegate?.didSelectHypeConnectForEvent(self.event!)
        }
    }
    /*
     ==========================================================================================
     UICollectionView protocol required methods
     ==========================================================================================
     */

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let array = sections[sectionKeys[section]]
        return array?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let admissionOption: PFObject! = objectAtIndexPath(indexPath)

        if ((admissionOption["type"] as AnyObject).intValue == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: admissionOptionCollectionViewIdentifier, for: indexPath) as!THLAdmissionOptionCell
                cell.titleLabel.text = admissionOption["name"] as? String

                if ((admissionOption["price"] as AnyObject).floatValue == 0.0) {
                    cell.priceLabel.text = "FREE"
                } else {
                    cell.priceLabel.text = NSString(format: "%.2f", (admissionOption["price"] as AnyObject).floatValue) as String
                }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tablePackageAdmissionCollectionViewIdentifier, for: indexPath) as!THLTablePackageAdmissionCell
            cell.titleLabel.text = admissionOption["name"] as? String
            cell.priceLabel.text = NSString(format: "%.f total", (admissionOption["price"] as AnyObject).floatValue) as String
            cell.partySizeLabel.text = NSString(format: "%.f people", (admissionOption["partySize"] as AnyObject).floatValue) as String
            cell.perPersonLabel.text = NSString(format: "%.f/person", (admissionOption["price"] as AnyObject).floatValue/(admissionOption["partySize"] as AnyObject).floatValue) as String

            return cell
        }
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = admissionOptionCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableViewIdentifier, for: indexPath) as! THLCollectionReusableView
        switch kind {
            case UICollectionElementKindSectionHeader:

                switch (sectionKeys[(indexPath as NSIndexPath).section]) {
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let admissionOption = objectAtIndexPath(indexPath)
        if ((admissionOption!["type"] as AnyObject).intValue == 0 && (admissionOption!["gender"] as AnyObject).intValue != THLUser.current()!.sex.rawValue) {
            return displayTicketGenderError()
        }

        delegate?.didSelectAdmissionOption(admissionOption!, event: event!)
    }


    func displayTicketGenderError() {
        let alert: UIAlertView = UIAlertView.init(title: "Error", message: "Please select the ticket that corresponds to your gender", delegate: self, cancelButtonTitle: "OK")
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

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "No Admission Options Available"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "Please check another event or contact your concierge for help"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
