//
//  THLPendingInquiryOffersViewController.swift
//  Hype
//
//  Created by Edgar Li on 12/3/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

import Parse
import ParseUI

protocol THLPendingInquiryOffersViewControllerDelegate: class {
    func didSelectViewInquiryMenuView(_ inquiry: PFObject)
}

class THLPendingInquiryOffersViewController: PFQueryTableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: Init
    var delegate: THLPendingInquiryOffersViewControllerDelegate?
    
    convenience init() {
        self.init(style: .plain, className: "InquiryOffer")
        
        pullToRefreshEnabled = true
        paginationEnabled = false
    }
    
    override func loadView() {
        super.loadView()
        
        tableView?.register(THLMyEventsTableViewCell.self, forCellReuseIdentifier: "THLMyEventsTableViewCell")
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.backgroundColor = UIColor.black
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
    }
    // MARK: Data
    
    override func queryForTable() -> PFQuery<PFObject> {
        let date = NSDate().subtractingHours(4) as NSDate
        let currentUser = THLUser.current()!
        let query: PFQuery = super.queryForTable()
        
        query.addAscendingOrder("date")
        query.whereKey("Host", equalTo: currentUser)
        query.whereKey("accepted", equalTo: false)
        query.whereKey("date", greaterThan: date)

        query.includeKey("Venue")
    
        
        return query
    }
}

extension THLPendingInquiryOffersViewController {
    
    // MARK: TableView
    
    //    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inquiryOffer: PFObject = super.object(at: indexPath) as PFObject!
        let venue:PFObject = inquiryOffer.value(forKey: "Venue") as! PFObject
        let venueName:String = venue.value(forKey: "name") as! String
        
        let eventTitle:String = "PENDING GUEST RESPONSE FOR \(venueName)"
        let date = inquiryOffer.value(forKey: "date") as? Date
        
        let cell:THLMyEventsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLMyEventsTableViewCell", for: indexPath) as! THLMyEventsTableViewCell
        
        cell.eventTitleLabel.text = eventTitle.uppercased()
        cell.dateTimeLabel.text = (date! as NSDate).thl_weekdayString
        cell.venueImageView.file = venue["image"] as! PFFile?
        cell.venueImageView.loadInBackground()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inquiryOffer: PFObject = super.object(at: indexPath)!
        let inquiryId = inquiryOffer.value(forKey:"inquiryId") as! String
        let query = PFQuery(className:"Inquiry")
        query.getObjectInBackground(withId: inquiryId) {(inquiry: PFObject?, error: Error?) -> Void in
            if error == nil && inquiry != nil {
                self.delegate?.didSelectViewInquiryMenuView(inquiry!)
            } else {
                print("error")
            }
        }
  
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "No Pending Inquiry Offers"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "Any Hype Connect inquiry offers you've sent will be shown here"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}
