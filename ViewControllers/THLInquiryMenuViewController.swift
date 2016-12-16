//
//  THLInquiryMenuViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import PopupDialog

protocol THLInquiryMenuViewControllerDelegate: class {
    func didWantToPresentSubmitInquiryOfferView(inquiry: PFObject, availableVenues:[String])
}

public enum InquiryStatus {
    case available
    case submittedOffer
    case connected
}

class THLInquiryMenuViewController: UIViewController {
    var delegate: THLInquiryMenuViewControllerDelegate?
    var inquiry: PFObject?
    
    var guestlistTableView: THLGuestlistTableViewController!
    var connectButton: UIButton!
    var inquiryStatus:InquiryStatus = .available
    var inquiryOffer: PFObject?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry

        self.connectButton = UIButton()
        
        let guestlistId = inquiry["guestlistId"] as! String
        let event:PFObject = inquiry.value(forKey: "Event") as! PFObject
        self.guestlistTableView = THLGuestlistTableViewController(guestlistId: guestlistId, event:event)
        super.init(nibName: nil, bundle: nil)
        self.inquiryStatus = getInquiryStatus()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sender = inquiry?.value(forKey: "Sender") as! PFObject
        let senderName = sender.value(forKey: "firstName") as! String
        if inquiryStatus == .available {
            let event:PFObject = inquiry?.value(forKey: "Event") as! PFObject
            let venue:PFObject = event.value(forKey: "location") as! PFObject
            let venueName:String = venue.value(forKey: "name") as! String
            let title = "\(senderName)'s inquiry for \(venueName)"
            let date = event.value(forKey: "date") as! Date
            let subtitle = (date as NSDate).thl_weekdayString
            (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "\(title.uppercased())"
            (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = "\(subtitle?.uppercased())"
            
        } else if (inquiryStatus == .submittedOffer) {
            let venue:PFObject = inquiryOffer!.value(forKey: "Venue") as! PFObject
            let venueName:String = venue.value(forKey: "name") as! String
            let title = "Pending response from \(senderName) for \(venueName)"
            let date = inquiryOffer?.value(forKey: "date") as! Date
            let subtitle = (date as NSDate).thl_weekdayString
            (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "\(title.uppercased())"
            (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = "\(subtitle?.uppercased())"
        } else {
            let inquiryOffer:PFObject = inquiry?.value(forKey:"AcceptedOffer") as! PFObject
            let venue:PFObject = inquiryOffer.value(forKey: "Venue") as! PFObject
            let venueName:String = venue.value(forKey: "name") as! String
            let title = "\(senderName)'s party for \(venueName)"
            let date = inquiryOffer.value(forKey: "date") as! Date
            let subtitle = (date as NSDate).thl_weekdayString
            (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "\(title.uppercased())"
            (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = "\(subtitle?.uppercased())"
        }


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_button"), style: .plain, target: self, action: #selector(THLInquiryMenuViewController.dismiss as (THLInquiryMenuViewController) -> () -> ()))
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        
        superview.addSubview(guestlistTableView.tableView)
        if inquiryStatus == .connected {
            connectButton.setTitle("MESSAGE", for: UIControlState.normal)
        } else if (inquiryStatus == .submittedOffer) {
            connectButton.isHidden = true
        } else {
            connectButton.setTitle("CONNECT", for: UIControlState.normal)
        }
        connectButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        connectButton.addTarget(self, action: #selector(handleButtonTapped), for: UIControlEvents.touchUpInside)
        connectButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(connectButton)
        
        listenHandlerForChatRoom()
    

    }
    
    override func viewDidLayoutSubviews() {
        guestlistTableView.tableView!.frame = CGRect(x:0,y:0,width:view.frame.size.width, height:view.frame.size.height - 60)
        connectButton.frame = CGRect(x:0,y:guestlistTableView.tableView!.frame.size.height,width:view.frame.size.width, height:60)

    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleButtonTapped() {
        if inquiryStatus == .connected {
            handleMessage()
        } else {
            handleConnect()
        }
    }
    
    func handleMessage() {
        let sender = inquiry?.value(forKey: "Sender") as! PFObject
        THLChatSocketManager.sharedInstance.getSpecificChatRoom(hostId: (THLUser.current()?.objectId)!, guestId: sender.objectId!)
    }
    
    func listenHandlerForChatRoom() {
        THLChatSocketManager.sharedInstance.socket.on("send specific room") { (dataArray, socketAck) -> Void in
            let chatRoomDict = dataArray[0] as! NSDictionary
            var chatRoomId = chatRoomDict["room"]
            //let navigationConroller = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
            let chatViewController = THLChatViewController()
            let sender = self.inquiry?.value(forKey: "Sender") as! PFObject
            chatViewController.chatMateId = sender.objectId
            chatViewController.chatRoomId = chatRoomId as! String?
            chatViewController.chatMateName = "Guest"
            self.navigationController?.pushViewController(chatViewController, animated: false)
            //self.present(navigationConroller, animated: true, completion: nil)
            
        }
    }
    
    func handleConnect() {
        if(THLUser.current()?.value(forKey: "image") == nil){
            let vc = THLProfilePicChooserViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
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
                    
                    self.delegate?.didWantToPresentSubmitInquiryOfferView(inquiry: self.inquiry!, availableVenues:availableVenues)

                } else {
                    // Log details of the failure
                }
            })
        }
    }
    
    func getInquiryStatus() -> InquiryStatus {
        let status = inquiry?.value(forKey: "connected") as! Bool
        if status == true {
            return .connected
        } else {
            let currentHostId:String = THLUser.current()!.objectId!
            var hostIds = [String]()
            if let inquiryOffers:[PFObject] = inquiry?.value(forKey:"Offers") as! [PFObject]? {
                for offer in inquiryOffers {
                    let host = offer.value(forKey: "Host") as! PFObject
                    let hostId = host.objectId
                    hostIds.append(hostId!)
                    self.inquiryOffer = offer
                }
                if (hostIds.contains(currentHostId)) {
                    return .submittedOffer
                } else {
                    return .available
                }
            } else  {
                return .available
            }
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
