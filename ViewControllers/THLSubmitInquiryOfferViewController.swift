//
//  THLSubmitInquiryOfferViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import PopupDialog
import Eureka
import NVActivityIndicatorView

protocol THLSubmitInquiryOfferViewControllerDelegate: class {
    func didSubmitInquiryOffer()
}

class THLSubmitInquiryOfferViewController: FormViewController, NVActivityIndicatorViewable {
    
    var delegate: THLSubmitInquiryOfferViewControllerDelegate?
    var inquiry: PFObject!
    
    var availableVenues: [String]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject, availableVenues: [String]) {
        self.inquiry = inquiry
        

        self.availableVenues = availableVenues
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = ""
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationAccessoryView = NavigationAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black

        form = Section("Which venue?")
            <<< ActionSheetRow<String>("venueField") {
                $0.title = "Select a venue"
                $0.selectorTitle = "Pick a venue"
                $0.add(rule: RuleRequired())
                $0.options = availableVenues
//                $0.value = "Two"    // initially selected
            }
        +++ Section("When?")
            <<< DateTimeRow("dateField"){
                $0.title = "Select a Date"
                $0.add(rule: RuleRequired())

                $0.minimumDate = Date()
        }
        +++ Section("Include a message")
            <<< TextAreaRow("messageField"){
                $0.title = "Message"
                $0.placeholder = "ex. Hey Jess, come join me for drinks at 1Oak. Just meet me 11:50pm in front of Artichoke."
                $0.add(rule: RuleRequired())
        }
        

        let submitButton = UIButton()
        submitButton.setTitle("CONNECT", for: UIControlState.normal)
        submitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(submitButton)
        
        tableView?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(superview.snp.left)
            make.right.equalTo(superview.snp.right)
            make.bottom.equalTo(submitButton.snp.top)
            make.top.equalTo(superview.snp.top)
        }
        
        submitButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(superview.snp.left)
            make.right.equalTo(superview.snp.right)
            make.height.equalTo(60)
            make.bottom.equalTo(superview.snp.bottom)
        }
        
        
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleSubmit() {
        if form.validate().isEmpty {
            submitOffer()
        } else {
            // Prepare the popup assets
            let title = "ERROR"
            let message = "Please fill in all fields!"
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message)
            
            // Create buttons
            let buttonOne = CancelButton(title: "OK") {
            }
            
            popup.addButton(buttonOne)
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }

    }
    
    func submitOffer() {
        let valuesDictionary = form.values()

        let messageText:String = valuesDictionary["messageField"] as! String
        let venueName:String = valuesDictionary["venueField"] as! String
        let dateTime:Date = valuesDictionary["dateField"] as! Date
        let inquiryId:String = self.inquiry.objectId!
        let guestlistId:String = self.inquiry.value(forKey: "guestlistId") as! String
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 0) )
        PFCloud.callFunction(inBackground: "submitOfferForInquiry", withParameters: ["message": messageText,
                                                                                    "venueName": venueName,
                                                                                    "dateTime": dateTime,
                                                                                    "inquiryId": inquiryId,
                                                                                    "guestlistId":guestlistId]) {
                (inquiryOffer, error) in
            if (!(error != nil)) {
//                var offers:[PFObject]? = self.inquiry?.value(forKey: "Offers") as? [PFObject]
//                if (offers == nil) {
//                    offers = [PFObject]()
//                    offers?.append(inquiryOffer as! PFObject)
//                } else {
//                    offers?.insert(inquiryOffer as! PFObject, at: 0)
//                }
//                self.inquiry?["Offers"] = offers
//                self.inquiry?.saveInBackground()
                self.stopAnimating()
                let title = "SUCCESS"
                let message = "Your offer was submitted!"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                // Create buttons
                
                let buttonOne = CancelButton(title: "OK") {
                    self.delegate?.didSubmitInquiryOffer()
                }
                
                popup.addButton(buttonOne)
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
            } else {
                self.stopAnimating()
                print(error ?? "Server error when submitting offer")

                // Prepare the popup assets
                let title = "ERROR"
                let message = "There was an issue with creating your inquiry. Please try again later!"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                // Create buttons
                let buttonOne = CancelButton(title: "OK") {
                }
                
                popup.addButton(buttonOne)
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
