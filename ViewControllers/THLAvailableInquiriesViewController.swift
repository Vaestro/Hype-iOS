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

class THLAvailableInquiriesViewController: PFQueryTableViewController {
    
    // MARK: Init
    
    convenience init() {
        self.init(style: .plain, className: "Inquiry")
        
        pullToRefreshEnabled = true
        paginationEnabled = false
    }
    
    // MARK: UIViewController
    override func loadView() {
        super.loadView()
        
        tableView?.register(THLInquiryTableViewCell.self, forCellReuseIdentifier: "THLInquiryTableViewCell")
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.backgroundColor = UIColor.black
    }
    
    // MARK: Data
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query: PFQuery = super.queryForTable()
        
        query.addAscendingOrder("date")
        query.includeKey("Offers")
        query.includeKey("Guestlist")
        query.includeKey("Guestlist.event")
        query.includeKey("Guestlist.event.location")
        query.includeKey("Guestlist.Owner")
        
        return query
    }
}

extension THLAvailableInquiriesViewController {

    // MARK: TableView
    
//    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inquiry: THLInquiry = super.object(at: indexPath) as! THLInquiry
    
        let cellIdentifier = "cell"
//        let guestlist:THLGuestlist = inquiry.value(forKey: "Guestlist") as! THLGuestlist
//        let owner:THLUser = guestlist.value(forKey: "Owner") as! THLUser
//        let senderFirstName:String = owner.value(forKey: "firstName") as! String
        
        let cell:THLInquiryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THLInquiryTableViewCell", for: indexPath) as! THLInquiryTableViewCell
        
//        cell.inquirySenderLabel.text = "\(senderFirstName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inquiry: PFObject? = super.object(at: indexPath)

        let inquiryMenuController = THLInquiryMenuViewController(inquiry:inquiry!)
        var navigationController = UINavigationController()
        navigationController.setViewControllers([inquiryMenuController], animated: false)
        self.present(navigationController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
}
