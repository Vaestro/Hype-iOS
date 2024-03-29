//
//  THLAvailableInquiriesViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

import Parse
import ParseUI

protocol THLAvailableInquiriesViewControllerDelegate: class {
    func didWantToPresentInquiryMenuFor(inquiry: PFObject)
}


class THLAvailableInquiriesViewController: PFQueryTableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    // MARK: Init
    var delegate:THLAvailableInquiriesViewControllerDelegate?
    
    convenience init() {
        self.init(style: .plain, className: "Inquiry")
        
        pullToRefreshEnabled = true
        paginationEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
    }
    
    // MARK: UIViewController
    override func loadView() {
        super.loadView()
        
        tableView?.register(THLInquiryTableViewCell.self, forCellReuseIdentifier: "THLInquiryTableViewCell")
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.backgroundColor = UIColor.black
        
        tableView?.emptyDataSetSource = self
        tableView?.emptyDataSetDelegate = self
        
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "INQUIRIES"
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = ""
    }
    
    // MARK: Data
    
    override func queryForTable() -> PFQuery<PFObject> {
        let date = NSDate().subtractingHours(4) as NSDate

        let query: PFQuery = super.queryForTable()
        
        query.addAscendingOrder("date")
        query.whereKey("connected", notEqualTo: true)
        query.whereKey("date", greaterThan: date)
        query.includeKey("Offers")
        query.includeKey("Event")
        query.includeKey("Event.location")
        query.includeKey("Sender")
        
        return query
    }
}

extension THLAvailableInquiriesViewController {

    // MARK: TableView
    
//    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inquiry: THLInquiry = super.object(at: indexPath) as! THLInquiry
    
        let event:PFObject = inquiry.value(forKey: "Event") as! PFObject
        let venue:PFObject = event.value(forKey: "location") as! PFObject
        let venueName:String = venue.value(forKey: "name") as! String

        let sender:PFObject = inquiry.value(forKey: "Sender") as! PFObject
        let senderFirstName:String = sender.value(forKey: "firstName") as! String
        let date = inquiry.value(forKey: "date") as? Date
        
        let cell:THLInquiryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLInquiryTableViewCell", for: indexPath) as! THLInquiryTableViewCell
        
        cell.inquirySenderLabel.text = "\(senderFirstName) is interested in going to"
        cell.venueNameLabel.text = venueName
        cell.dateLabel.text = (date! as NSDate).thl_weekdayString

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inquiry: PFObject? = super.object(at: indexPath)
        self.delegate?.didWantToPresentInquiryMenuFor(inquiry: inquiry!)

        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "No Available Hype Connect Inquiries"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "Any Hype Connect inquiries will be shown here"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
}
