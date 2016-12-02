//
//  THLInquiryMenuViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import PopupDialog

class THLInquiryMenuViewController: UIViewController {
    
    var inquiry: PFObject?
    var guestlistTableView: THLGuestlistTableViewController!
    var connectButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry
        self.connectButton = UIButton()
        
        let guestlistId = inquiry["guestlistId"] as! String
        self.guestlistTableView = THLGuestlistTableViewController(guestlistId: guestlistId)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sender = inquiry?.value(forKey: "Sender") as! PFObject
        let senderName = sender.value(forKey: "firstName") as! String
        let event = inquiry?.value(forKey: "Event") as! PFObject
        let location = event.value(forKey: "location") as! PFObject
        let locationName = location.value(forKey: "name") as! String
        let title = "\(senderName)'s inquiry for \(locationName)"
        let date = event.value(forKey: "date") as! Date
        let subtitle = (date as NSDate).thl_weekdayString
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "\(title.uppercased())"
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = "\(subtitle?.uppercased())"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_button"), style: .plain, target: self, action: #selector(THLInquiryMenuViewController.dismiss as (THLInquiryMenuViewController) -> () -> ()))
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        
        superview.addSubview(guestlistTableView.tableView)
        
        connectButton.setTitle("CONNECT", for: UIControlState.normal)
        connectButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        connectButton.addTarget(self, action: #selector(handleConnect), for: UIControlEvents.touchUpInside)
        connectButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(connectButton)
    

    }
    
    override func viewDidLayoutSubviews() {
        guestlistTableView.tableView!.frame = CGRect(x:0,y:0,width:view.frame.size.width, height:view.frame.size.height - 60)
        connectButton.frame = CGRect(x:0,y:guestlistTableView.tableView!.frame.size.height,width:view.frame.size.width, height:60)

    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleConnect() {
        
        let venueQuery = PFQuery(className:"Location")
        venueQuery.addAscendingOrder("name")
        venueQuery.findObjectsInBackground(block: { (objects:[PFObject]?, error: Error?) in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                var availableVenues = [String]()
                if let objects = objects {
                    for object in objects {
                        let venueName = object.value(forKey: "name") as! String
                        availableVenues.append(venueName)
                    }
                }
                
                let submitInquiryView = THLSubmitInquiryOfferViewController(inquiry: self.inquiry!, availableVenues:availableVenues)
                self.navigationController?.pushViewController(submitInquiryView, animated: true)
            } else {
                // Log details of the failure
            }
        })
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
