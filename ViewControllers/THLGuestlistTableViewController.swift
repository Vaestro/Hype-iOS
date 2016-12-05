//
//  THLGuestlistTableViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class THLGuestlistTableViewController: PFQueryTableViewController {
    var guestlistId: String!
    
    // MARK: Init
    convenience init(guestlistId: String) {
        
        self.init(style: .plain, className: "GuestlistInvite")
        self.guestlistId = guestlistId
        
        pullToRefreshEnabled = false
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
        
        let guestlist = PFObject(withoutDataWithClassName: "Guestlist", objectId: guestlistId)
        
        query.whereKey("Guestlist", equalTo: guestlist)
        query.includeKey("Guest")
        return query
    }
}

extension THLGuestlistTableViewController {
    
    // MARK: TableView
    
    //    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestlistInvite: PFObject = super.object(at: indexPath) as PFObject!
        
//        let guest:PFObject? = guestlistInvite.value(forKey: "Guest") as? PFObject
        let cell:THLMyEventsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLMyEventsTableViewCell", for: indexPath) as! THLMyEventsTableViewCell

        if let guest = guestlistInvite.value(forKey: "Guest") as? PFObject {
            let guestName:String? = guest.value(forKey: "firstName") as? String
            cell.eventTitleLabel.text = guestName?.uppercased()
            cell.venueImageView.file = guest["image"] as! PFFile?
            cell.venueImageView.loadInBackground()
        } else {
            cell.eventTitleLabel.text = "Pending Signup"
            cell.venueImageView.image = UIImage.init(named: "default_profile_image")
        }
        
        
     
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0;//Choose your custom row height
    }
}
