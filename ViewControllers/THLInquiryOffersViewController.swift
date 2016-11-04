//
//  THLInquiryOffersViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/12/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

@objc protocol THLInquiryOffersViewControllerDelegate {
    func didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(_ guestlistInvite: PFObject)
}

class THLInquiryOffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, THLInquiryOfferDetailsViewDelegate {
    public func didAcceptInquiryOffer() {
        self.delegate?.didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(guestlistInvite)
    }
    
    //  MARK: -
    //  MARK: Init
    var delegate: THLInquiryOffersViewControllerDelegate?
    
    var offersTableView: UITableView
    
    var guestlistInvite: PFObject
    var guestlist: PFObject
    var inquiry: PFObject
    
    var offers: [PFObject]
    
    let offersTableViewIdentifier = "offersTableViewIdentifier"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(guestlistInvite: PFObject) {
        self.guestlistInvite = guestlistInvite
        self.guestlist = guestlistInvite.value(forKey: "Guestlist") as! PFObject
        self.inquiry = guestlist.value(forKey: "Inquiry") as! PFObject
        

        
        self.offers = Array()
        offersTableView = UITableView.init(frame: CGRect.zero)
        super.init(nibName: nil, bundle: nil)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .plain, target: self, action: #selector(THLInquiryOffersViewController.dismiss as (THLInquiryOffersViewController) -> () -> ()))
        offersTableView.delegate = self
    }
    
    
    //  MARK: -
    //  MARK: UIViewController
    override func viewWillAppear(_ animated: Bool) {
        let event = inquiry.value(forKey: "Event") as! PFObject
        let venueName = event.value(forKey: "venueName") as! String
        
        let date = inquiry.value(forKey: "date") as! Date
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "INQUIRY FOR \(venueName.uppercased())"
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = (date as! NSDate).thl_weekdayString
    }
    
    override func loadView() {
        super.loadView()



        offersTableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        offersTableView.backgroundColor = UIColor.black
        offersTableView.delegate = self
        offersTableView.dataSource = self
        offersTableView.emptyDataSetSource = self
        offersTableView.emptyDataSetDelegate = self
        
        offersTableView.register(THLInquiryOfferTableViewCell.self, forCellReuseIdentifier: "THLInquiryOfferTableViewCell")
        offersTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        offersTableView.rowHeight = 125.0
        
        if let inquiryOffers = inquiry["Offers"] as! [PFObject]? {
            offers = inquiryOffers
        }
        
        self.view.addSubview(offersTableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        layout.itemSize = CGSize(width: self.view.frame.size.width - 25, height: 55)
//        layout.headerReferenceSize = CGSize(width: admissionOptionCollectionView.bounds.width, height: 70.0)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    //  MARK: -
    //  MARK: Responding to events

    
    /*
     ==========================================================================================
     UICollectionView protocol required methods
     ==========================================================================================
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inquiryOffer: PFObject = self.offers[indexPath.row] as PFObject
        let host:PFObject = inquiryOffer["Host"] as! PFObject
        let hostName = host["firstName"] as! String?
        let venue = inquiryOffer.value(forKey: "Venue") as! PFObject
        let venueName = venue.value(forKey: "name") as! String
        let offerDateTime = inquiryOffer.value(forKey: "date") as! NSDate
        
        let cell:THLInquiryOfferTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLInquiryOfferTableViewCell", for: indexPath) as! THLInquiryOfferTableViewCell
        cell.hostNameLabel.text = hostName?.uppercased()
        cell.eventTitleLabel.text = venueName.uppercased()
        cell.dateTimeLabel.text = offerDateTime.thl_weekdayString
        cell.messagePreviewLabel.text = inquiryOffer.value(forKey: "message") as! String?

        cell.hostImageView.file = host["image"] as! PFFile?
        cell.hostImageView.loadInBackground()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        let inquiryOfferDetailsView = THLInquiryOfferDetailsView(inquiry: inquiry, offer: offer)
        inquiryOfferDetailsView.delegate = self
        self.navigationController?.pushViewController(inquiryOfferDetailsView, animated: true)
        
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
        let str = "HANG TIGHT, YOUR CONNECT IS IN PROGRESS. WE’LL LET YOU KONW WHEN WE FIND HOSTS THAT WOULD BE A GOOD MATCH FOR YOU"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
//    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
//        let str = "Please check another event or contact your concierge for help"
//        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
}
