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
import SnapKit

protocol THLGuestlistTableViewControllerDelegate {
    func guestlistTableViewWantsToPresentInvitationController(for event: PFObject!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!)
}

class THLGuestlistTableViewController: PFQueryTableViewController {
    var guestlistId: String!
    var delegate: THLGuestlistTableViewControllerDelegate?
    var event: PFObject!
    var inviteFriendsButton = UIButton()
    // MARK: Init
    convenience init(guestlistId: String, event: PFObject) {
        
        self.init(style: .plain, className: "GuestlistInvite")
        self.guestlistId = guestlistId
        self.event = event
        pullToRefreshEnabled = false
        paginationEnabled = false
    }
    
    // MARK: UIViewController
    override func loadView() {
        super.loadView()
        
        tableView?.register(THLMyEventsTableViewCell.self, forCellReuseIdentifier: "THLMyEventsTableViewCell")
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.backgroundColor = UIColor.black
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0)
        inviteFriendsButton.setTitle("INVITE FRIENDS", for: UIControlState.normal)
        inviteFriendsButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        inviteFriendsButton.addTarget(self, action: #selector(handleInviteFriends), for: UIControlEvents.touchUpInside)
        inviteFriendsButton.backgroundColor = UIColor.customGoldColor()
        self.view.addSubview(inviteFriendsButton)
        

    }

    override func viewDidLayoutSubviews() {
        inviteFriendsButton.frame = CGRect(x:0,y:self.view.frame.size.height - 60, width:self.view.frame.size.width,height:60)
    }
    
    
    // MARK: Data
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query: PFQuery = super.queryForTable()
        
        let guestlist = PFObject(withoutDataWithClassName: "Guestlist", objectId: guestlistId)
        
        query.whereKey("Guestlist", equalTo: guestlist)
        query.includeKey("Guest")
        return query
    }
    
    func handleInviteFriends() {
        self.delegate?.guestlistTableViewWantsToPresentInvitationController(for: self.event, guestlistId: self.guestlistId, currentGuestsPhoneNumbers: nil)
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
