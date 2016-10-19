//
//  THLInquiryOffersViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/12/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLInquiryOffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    //  MARK: -
    //  MARK: Init
    
    var offersTableView: UITableView
    
    var inquiry: PFObject
    
    var offers: [PFObject]
    
    let offersTableViewIdentifier = "offersTableViewIdentifier"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry
        self.offers = Array()
        offersTableView = UITableView.init(frame: CGRect.zero)
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(THLInquiryOffersViewController.dismiss as (THLInquiryOffersViewController) -> () -> ()))
        offersTableView.delegate = self
    }
    
    
    //  MARK: -
    //  MARK: UIViewController
    
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
        
        offersTableView.rowHeight = 60.0
        
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
        let inquiry: PFObject = self.offers[indexPath.row] as! PFObject
        
        let cellIdentifier = "cell"
        
        let cell:THLInquiryOfferTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLInquiryOfferTableViewCell", for: indexPath) as! THLInquiryOfferTableViewCell
        cell.hostNameLabel.text = "Offer"
        cell.locationAndDateLabel.text = "Poop"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        let inquiryOfferDetailsView = THLInquiryOfferDetailsView(inquiry: inquiry, offer: offer)
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
