//
//  THLSwiftCheckoutViewController.swift
//  Hype
//
//  Created by Edgar Li on 11/20/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//



class THLSwiftCheckoutViewController: UIViewController {
    var scrollView: UIScrollView = UIScrollView()
    var event: PFObject
    var admissionOption: PFObject
    var guestlistInvite: PFObject?
    
    var subtotalAmount:Float
    var totalAmount:Float
    var serviceFeeAmount:Float
    var taxAmount:Float?
    var tipAmount:Float?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(event: PFObject, admissionOption: PFObject, guestlistInvite: PFObject?) {
        self.event = event
        self.admissionOption = admissionOption
        self.guestlistInvite = guestlistInvite
        
        self.subtotalAmount = admissionOption.value(forKey: "price") as! Float
        self.serviceFeeAmount = (subtotalAmount * 0.029) + 0.30
        self.totalAmount = subtotalAmount + serviceFeeAmount
        
        if (admissionOption.value(forKey: "type") as! Int) == 1 {
            self.taxAmount = subtotalAmount * 0.0865
            self.tipAmount = subtotalAmount * 0.2
            self.totalAmount = subtotalAmount + taxAmount! + tipAmount!
        }

        super.init(nibName: nil, bundle: nil)

    }
    
    override func viewDidLoad() {
        scrollView.frame = CGRect(x:0,y:0,width:view.frame.size.width,height:view.frame.size.height - 60)
        self.view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.frame = scrollView.frame
        self.scrollView.addSubview(contentView)
        
    }
}
