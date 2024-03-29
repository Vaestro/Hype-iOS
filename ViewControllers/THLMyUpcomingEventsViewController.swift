//
//  THLMyUpcomingEventsViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/21/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

import Parse
import ParseUI

protocol THLMyUpcomingEventsViewControllerDelegate: class {
    func didSelectViewInquiry(_ guestlistInvite: PFObject)
    func didSelectViewHostedEvent(_ guestlistInvite: PFObject)
    func didSelectViewEventTicket(_ guestlistInvite: PFObject)
    func didSelectViewTableReservation(_ guestlistInvite: PFObject)
}

class THLMyUpcomingEventsViewController: PFQueryTableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: Init
    var delegate: THLMyUpcomingEventsViewControllerDelegate?

    convenience init() {
        self.init(style: .plain, className: "GuestlistInvite")
        
        pullToRefreshEnabled = true
        paginationEnabled = false
    }
    
    // MARK: UIViewController
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
        let query: PFQuery = super.queryForTable()
        
        let user:PFUser = PFUser.current()!
        let date = NSDate().subtractingHours(4) as NSDate

        query.whereKey("Guest", equalTo: user)
        query.whereKey("date", greaterThan: date)
        query.whereKey("response", equalTo: 1)

        query.includeKey("Guest")
        query.includeKey("Guest.event")
        query.includeKey("Guestlist.Owner")
        query.includeKey("Guestlist.Inquiry")
        query.includeKey("Guestlist.Inquiry.Offers")
        query.includeKey("Guestlist.Inquiry.Offers.Venue")
        query.includeKey("Guestlist.Inquiry.AcceptedOffer")
        query.includeKey("Guestlist.Inquiry.AcceptedOffer.Venue")
        query.includeKey("Guestlist.Inquiry.Offers.Host")
        query.includeKey("Guestlist.admissionOption")
        query.includeKey("Guestlist.event.location")
        
        query.addAscendingOrder("date")

        return query
    }
}

extension THLMyUpcomingEventsViewController {
    
    // MARK: TableView
    
    //    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:THLMyEventsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLMyEventsTableViewCell", for: indexPath) as! THLMyEventsTableViewCell

        let guestlistInvite: PFObject = super.object(at: indexPath) as PFObject!
        
        let event:PFObject = guestlistInvite.value(forKey: "event") as! PFObject
        let partyType:String = guestlistInvite.value(forKey: "admissionDescription") as! String
        var venue:PFObject = event.value(forKey: "location") as! PFObject
        var venueName:String = venue.value(forKey: "name") as! String

        var date = guestlistInvite.value(forKey: "date") as? Date
        
        let guestlist = guestlistInvite.value(forKey: "Guestlist") as! PFObject
        let admissionOption = guestlist.value(forKey: "admissionOption") as! PFObject
        let admissionType:Int = admissionOption.value(forKey: "type") as! Int
        if (admissionType == 2) {
            let inquiry = guestlist.value(forKey: "Inquiry") as! PFObject
            
            if ((inquiry.value(forKey: "connected") as! Bool) == true) {
                let acceptedOffer:PFObject = inquiry.value(forKey: "AcceptedOffer") as! PFObject
                venue = acceptedOffer.value(forKey: "Venue") as! PFObject
                venueName = venue.value(forKey: "name") as! String
                date = acceptedOffer.value(forKey: "date") as? Date

            }
        }
        let eventTitle:String = "\(partyType) AT \(venueName)"
        
        cell.eventTitleLabel.text = eventTitle.uppercased()
        cell.dateTimeLabel.text = (date! as NSDate).thl_weekdayString
        cell.venueImageView.file = venue["image"] as! PFFile?
        cell.venueImageView.loadInBackground()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let guestlistInvite = object(at: indexPath) as PFObject!
        let guestlist = guestlistInvite?.value(forKey: "Guestlist") as! PFObject

        let admissionOption = guestlist.value(forKey: "admissionOption") as! PFObject
        let admissionType:Int = admissionOption.value(forKey: "type") as! Int
        
        if (admissionType == 2) {
 
            
            
        
            delegate?.didSelectViewInquiry(guestlistInvite!)
            
        } else if (admissionType == 1) {
            delegate?.didSelectViewTableReservation(guestlistInvite!)
        } else {
            delegate?.didSelectViewEventTicket(guestlistInvite!)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "No Upcoming Events"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let str = "Your upcoming tickets/reservations will show here"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
