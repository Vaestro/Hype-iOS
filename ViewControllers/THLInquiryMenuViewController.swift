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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_button"), style: .plain, target: self, action: #selector(THLInquiryMenuViewController.dismiss as (THLInquiryMenuViewController) -> () -> ()))
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        
        let connectButton = UIButton()
        connectButton.titleLabel?.text = "CONNECT"
        connectButton.titleLabel?.textColor = UIColor.black
        connectButton.addTarget(self, action: #selector(handleConnect), for: UIControlEvents.touchUpInside)
        connectButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(connectButton)
    
        connectButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.center.equalTo(superview.snp.center)
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleConnect() {
        var submitInquiryView = THLSubmitInquiryOfferViewController(inquiry: self.inquiry!)
        self.navigationController?.pushViewController(submitInquiryView, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
