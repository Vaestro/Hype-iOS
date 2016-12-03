//
//  THLHostUpcomingEventsViewController.swift
//  Hype
//
//  Created by Edgar Li on 12/3/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

import Parse
import ParseUI
protocol THLHostUpcomingEventsViewControllerDelegate: class {
    func didSelectViewConnectedInquiry(_ inquiry: PFObject)
}

class THLHostUpcomingEventsViewController: PFQueryTableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: Init
    var delegate: THLHostUpcomingEventsViewControllerDelegate?
    
    convenience init() {
        self.init(style: .plain, className: "Inquiry")
        
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
        let currentUserId = THLUser.current()!.objectId
        let query: PFQuery = super.queryForTable()
        
        query.addAscendingOrder("date")
        query.whereKey("acceptedHostId", equalTo: currentUserId!)
        query.whereKey("connected", equalTo: true)
        query.whereKey("date", greaterThan: date)
        query.includeKey("Sender")
        query.includeKey("AcceptedOffer")
        query.includeKey("AcceptedOffer.Venue")

        return query
    }
}

extension THLHostUpcomingEventsViewController {
    
    // MARK: TableView
    
    //    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inquiry: PFObject = super.object(at: indexPath) as PFObject!
        let acceptedOffer: PFObject = inquiry.value(forKey:"AcceptedOffer") as! PFObject
        let venue:PFObject = acceptedOffer.value(forKey: "Venue") as! PFObject
        let venueName:String = venue.value(forKey: "name") as! String
        let sender:PFObject = inquiry.value(forKey: "Sender") as! PFObject
        let senderName:String = sender.value(forKey: "firstName") as! String

        let eventTitle:String = "\(senderName) IS COMING TO \(venueName)"
        let date = acceptedOffer.value(forKey: "date") as? Date
        
        let cell:THLMyEventsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLMyEventsTableViewCell", for: indexPath) as! THLMyEventsTableViewCell
        
        cell.eventTitleLabel.text = eventTitle.uppercased()
        cell.dateTimeLabel.text = (date! as NSDate).thl_weekdayString
        cell.venueImageView.file = venue["image"] as! PFFile?
        cell.venueImageView.loadInBackground()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inquiry: PFObject? = super.object(at: indexPath)
        
        self.delegate?.didSelectViewConnectedInquiry(inquiry!)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "No Upcoming Events"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "Any parties you're hosting will show up here"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}
