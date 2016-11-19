//
//  THLPhoneNumberVerificationViewController.swift
//  Hype
//
//  Created by Edgar Li on 11/13/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

//
//  THLAccountRegistrationView.swift
//  Hype
//
//  Created by Edgar Li on 11/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import TPKeyboardAvoiding
import TextFieldEffects
import SnapKit
import PopupDialog
import PhoneNumberKit

protocol THLPhoneNumberVerificationViewControllerDelegate {
    func didVerifyPhoneNumber(enteredCode: String)
}

class THLPhoneNumberVerificationViewController: UIViewController {
    var delegate: THLPhoneNumberVerificationViewControllerDelegate?
    var verificationCodeTextField = UITextField()
    var userPN = ""
    var code = ""
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        
        let scrollView = TPKeyboardAvoidingScrollView()
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name:"Raleway-Regular",size:20)
        subtitleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        subtitleLabel.numberOfLines = 3
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.text = "Enter the 4-digit code sent to you"
        
        
        verificationCodeTextField.placeholder = "Verification Code"
        verificationCodeTextField = constructTextField()
        scrollView.addSubview(subtitleLabel)
      
        scrollView.addSubview(verificationCodeTextField)

        scrollView.addSubview(verifyButton)

        
        subtitleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top).offset(25)
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
        }
        
        verificationCodeTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.height.equalTo(50)
        }
        
        verifyButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(25)
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.snp.bottom).offset(-25)
            make.height.equalTo(50)
        }
    }
    
    
    func handleVerifyButtonTapped() {
        self.delegate?.didVerifyPhoneNumber(enteredCode: self.verificationCodeTextField.text!)
    }
    
    func label() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .left
        
        return label
    }
    
    func textButton() -> UIButton {
        let textButton = UIButton()
        textButton.titleLabel!.font = UIFont(name: "Raleway-Bold", size: 16)
        textButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        return textButton
    }

    lazy var verifyButton: UIButton = {
        var button = UIButton()
        button.setTitle("Verify", for: .normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleVerifyButtonTapped), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.customGoldColor()
        return button
    }()
    
    func constructTextField() -> UITextField {
        let textField = HoshiTextField(frame: CGRect.zero)
        textField.placeholderColor = UIColor.lightGray
        textField.borderInactiveColor = UIColor.lightGray
        textField.borderActiveColor = UIColor.white
        textField.keyboardType = .numberPad
        textField.placeholderFontScale = 1.0
        
        return textField
    }
   
    
  
}
