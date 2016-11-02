//
//  THLSubmitInquiryOfferViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import PopupDialog

class THLSubmitInquiryOfferViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var inquiry: PFObject!
    var messageTextField: UITextField!
    var dateTextField: UITextField!
    var venueTextField: UITextField!
    var datePlaceHolderLabel: UILabel!
    var venuePlaceHolderLabel: UILabel!
    var messagePlaceHolderLabel: UILabel!
    var inquiryOfferDate: Date?
    
    var availableVenues: [String]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry
        
        self.messageTextField = UITextField()
        self.dateTextField = UITextField()
        self.venueTextField = UITextField()
        self.availableVenues = [String]()
        self.inquiryOfferDate = Date()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        
        messageTextField?.backgroundColor = UIColor.gray
        superview.addSubview(messageTextField!)
        
        self.dateTextField?.delegate = self
        dateTextField?.backgroundColor = UIColor.gray
        superview.addSubview(dateTextField!)

        self.venueTextField?.delegate = self
        venueTextField?.backgroundColor = UIColor.gray
        superview.addSubview(venueTextField!)
        
        let submitButton = UIButton()
        submitButton.setTitle("CONNECT", for: UIControlState.normal)
        submitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(superview.snp.left).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.height.equalTo(60)
            make.bottom.equalTo(superview.snp.bottom).offset(-10)
        }
        
        messageTextField?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(superview.snp.left).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.height.equalTo(150)
            make.bottom.equalTo(submitButton.snp.top).offset(-10)
        }
        
        venueTextField?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(superview.snp.left).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.height.equalTo(60)
            make.bottom.equalTo((messageTextField?.snp.top)!).offset(-10)
        }
        
        dateTextField?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(superview.snp.left).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.height.equalTo(60)
            make.bottom.equalTo((venueTextField?.snp.top)!).offset(-10)
        }
        
        datePlaceHolderLabel = UILabel()
        datePlaceHolderLabel.text = "Pick a date & time"
        datePlaceHolderLabel.font = UIFont.italicSystemFont(ofSize: (dateTextField.font?.pointSize)!)
        datePlaceHolderLabel.sizeToFit()
        dateTextField.addSubview(datePlaceHolderLabel)
        datePlaceHolderLabel.frame.origin = CGPoint(x: 5, y: (dateTextField.font?.pointSize)! / 2)
        datePlaceHolderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        datePlaceHolderLabel.isHidden = !(dateTextField.text?.isEmpty)!
        
        venuePlaceHolderLabel = UILabel()
        venuePlaceHolderLabel.text = "Pick a venue"
        venuePlaceHolderLabel.font = UIFont.italicSystemFont(ofSize: (venueTextField.font?.pointSize)!)
        venuePlaceHolderLabel.sizeToFit()
        venueTextField.addSubview(venuePlaceHolderLabel)
        venuePlaceHolderLabel.frame.origin = CGPoint(x: 5, y: (venueTextField.font?.pointSize)! / 2)
        venuePlaceHolderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        venuePlaceHolderLabel.isHidden = !(venueTextField.text?.isEmpty)!
        
        messagePlaceHolderLabel = UILabel()
        messagePlaceHolderLabel.text = "Add a message"
        messagePlaceHolderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextField.font?.pointSize)!)
        messagePlaceHolderLabel.sizeToFit()
        messageTextField.addSubview(messagePlaceHolderLabel)
        messagePlaceHolderLabel.frame.origin = CGPoint(x: 5, y: (messageTextField.font?.pointSize)! / 2)
        messagePlaceHolderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        messagePlaceHolderLabel.isHidden = !(messageTextField.text?.isEmpty)!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == dateTextField) {
            let datePickerView:UIDatePicker = UIDatePicker()
            
            datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            
            textField.inputView = datePickerView
            
            datePickerView.addTarget(self, action: #selector(THLSubmitInquiryOfferViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.black
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(THLSubmitInquiryOfferViewController.datePickerFinished))
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(THLSubmitInquiryOfferViewController.datePickerFinished))
            
            toolBar.setItems([cancelButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            textField.inputAccessoryView = toolBar
        } else if (textField == venueTextField) {
            if (self.availableVenues.isEmpty) {
                let venueQuery = PFQuery(className:"Location")
                venueQuery.addAscendingOrder("name")
                venueQuery.findObjectsInBackground(block: { (objects:[PFObject]?, error: Error?) in
                    
                    if error == nil {
                        // The find succeeded.
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                let venueName = object.value(forKey: "name") as! String
                                self.availableVenues.append(venueName)
                            }
                            let venuePickerView = UIPickerView()
                            venuePickerView.delegate = self
                            self.venueTextField?.inputView = venuePickerView
                        }
                    } else {
                        // Log details of the failure
                    }
                })

            } else {
                let venuePickerView = UIPickerView()
                venuePickerView.delegate = self
                self.venueTextField?.inputView = venuePickerView
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == dateTextField) {
            datePlaceHolderLabel.isHidden = !(textField.text?.isEmpty)!
        } else if (textField == venueTextField) {
            venuePlaceHolderLabel.isHidden = !(textField.text?.isEmpty)!
        } else if (textField == messageTextField) {
            messagePlaceHolderLabel.isHidden = !(textField.text?.isEmpty)!
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateTextField?.text = dateFormatter.string(from: sender.date)
        
        inquiryOfferDate = sender.date
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
    }

    
    func datePickerFinished(sender:UIDatePicker) {
        
        dateTextField?.resignFirstResponder()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableVenues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableVenues[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        venueTextField?.text = availableVenues[row]
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleSubmit() {
        if (!(dateTextField.text?.isEmpty)! && !(venueTextField.text?.isEmpty)! && !(messageTextField.text?.isEmpty)!) {
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
        let messageText:String = self.messageTextField.text!
        let venueName:String = self.venueTextField.text!
        let inquiryId:String = self.inquiry.objectId!
        let dateTime:Date = self.inquiryOfferDate!

        PFCloud.callFunction(inBackground: "submitOfferForInquiry", withParameters: ["message": messageText,
                                                                                    "venueName": venueName,
                                                                                    "dateTime": dateTime,
                                                                                    "inquiryId": inquiryId]) {
                (inquiryOffer, error) in
            if (!(error != nil)) {
                var offers:[PFObject]? = self.inquiry?.value(forKey: "Offers") as? [PFObject]
                if (offers == nil) {
                    offers = [PFObject]()
                    offers?.append(inquiryOffer as! PFObject)
                } else {
                    offers?.insert(inquiryOffer as! PFObject, at: 0)
                }
                self.inquiry?["Offers"] = offers
                self.inquiry?.saveInBackground()
                let title = "SUCCESS"
                let message = "Your offer was submitted!"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                // Create buttons
                let buttonOne = CancelButton(title: "OK") {
                    print("You canceled the car dialog.")
                }
                
                popup.addButton(buttonOne)
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
            } else {
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
