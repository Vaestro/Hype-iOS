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
    
    // MARK: Data
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query: PFQuery = super.queryForTable()
        
        query.addAscendingOrder("date")
        query.includeKey("guestlist")
        query.includeKey("guestlist.owner")
        
        return query
    }
}

extension THLAvailableInquiriesViewController {

    // MARK: TableView
    
//    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = super.object(at: indexPath)
    
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell()
            
        }
        cell?.backgroundColor = UIColor.blue
//        cell?.textLabel?.text = (object?["Guestlist"] as! PFObject).value(forKey: "owner").value(forKey: "firstName") as? String
        
        return cell!
    }
    
}
