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
        let submitInquiryView = THLSubmitInquiryOfferViewController(inquiry: self.inquiry!)
        self.navigationController?.pushViewController(submitInquiryView, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
