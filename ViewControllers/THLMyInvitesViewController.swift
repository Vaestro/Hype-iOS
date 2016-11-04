//
//  THLMyInvitesViewController.swift
//  Hype
//
//  Created by Edgar Li on 11/3/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

import Parse
import ParseUI

protocol THLMyInvitesViewControllerDelegate: class {
    func didSelectViewInquiry(_ guestlistInvite: PFObject)
    func didSelectViewHostedEvent(_ guestlistInvite: PFObject)
    func didSelectViewEventTicket(_ guestlistInvite: PFObject)
    
}

class THLMyInvitesViewController: PFQueryTableViewController {
    
    // MARK: Init
    var delegate: THLMyInvitesViewControllerDelegate?
    
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
    }
    
    // MARK: Data
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query: PFQuery = super.queryForTable()
        
        let user:PFUser = PFUser.current()!
        let date = NSDate().subtractingHours(4) as NSDate
        
        query.whereKey("Guest", equalTo: user)
        query.whereKey("date", greaterThan: date)
        query.whereKey("response", equalTo: 2)

        query.includeKey("Guest")
        query.includeKey("Guest.event")
        query.includeKey("Guestlist.Owner")
        query.includeKey("Guestlist.Inquiry")
        query.includeKey("Guestlist.Inquiry.Offers")
        query.includeKey("Guestlist.Inquiry.Offers.Host")
        query.includeKey("Guestlist.admissionOption")
        query.includeKey("Guestlist.event.location")
        
        query.addAscendingOrder("date")
        
        return query
    }
}

extension THLMyInvitesViewController {
    
    // MARK: TableView
    
    //    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestlistInvite: PFObject = super.object(at: indexPath) as PFObject!
        
        let event:PFObject = guestlistInvite.value(forKey: "event") as! PFObject
        let venue:PFObject = event.value(forKey: "location") as! PFObject
        let venueName:String = venue.value(forKey: "name") as! String
        let partyType:String = guestlistInvite.value(forKey: "admissionDescription") as! String
        let sender:PFObject = guestlistInvite.value(forKey: "sender") as! PFObject
        let senderName:String = sender.value(forKey: "firstName") as! String
        
        let eventTitle:String = "\(senderName) INVITED YOU TO PARTY AT \(venueName)"
        let date = guestlistInvite.value(forKey: "date") as? Date
        
        let cell:THLMyEventsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLMyEventsTableViewCell", for: indexPath) as! THLMyEventsTableViewCell
        
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
            let inquiry = guestlist.value(forKey: "Inquiry") as! PFObject
            if ((inquiry.value(forKey: "connected") as! Bool) == true) {
                delegate?.didSelectViewHostedEvent(guestlistInvite!)
            } else {
                delegate?.didSelectViewInquiry(guestlistInvite!)
            }
        } else {
            delegate?.didSelectViewEventTicket(guestlistInvite!)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }
    
}
