//
//  THLSwiftLoginViewController.swift
//  Hype
//
//  Created by Edgar Li on 11/13/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import TPKeyboardAvoiding
import TextFieldEffects
import SnapKit
import PopupDialog
import PhoneNumberKit
import Parse
import TTTAttributedLabel
import Mixpanel

protocol THLSwiftLoginViewControllerDelegate {
    func loginViewDidLoginAndWantsToPresentGuestInterface()
    func loginViewWantsToPresentAccountRegistration()
}

class THLSwiftLoginViewController: UIViewController, TTTAttributedLabelDelegate {
    var delegate: THLSwiftLoginViewControllerDelegate?
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        
        let scrollView = TPKeyboardAvoidingScrollView()
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name:"Raleway-Bold",size:20)
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.white
        titleLabel.text = "LOGIN"
        
        emailTextField = constructTextField()
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress

        passwordTextField = constructTextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(attributedRegistrationLabel)
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top).offset(25)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        
        attributedRegistrationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(25)
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.snp.bottom).offset(-25)
            make.height.equalTo(50)
        }
    }
    
    
    func handleLoginButtonTapped() {
        validateFields() == true ? login() : presentErrorMessage("Error", message:"Please complete all fields")
    }
    
    func login() {
        let email:String = emailTextField.text!
        let password:String = passwordTextField.text!
        PFUser.logInWithUsername(inBackground: email, password: password, block: {(user: PFUser?, error: Error?) -> Void in
            if (user != nil) {
                let mixpanel = Mixpanel.mainInstance()
                mixpanel.track(event: "used logged in")
                self.delegate?.loginViewDidLoginAndWantsToPresentGuestInterface()
            } else {
                self.presentErrorMessage("Error", message: "The email or password you have entered does not match a valid account. Please check that you have entered your information correctly and try again")
            }
        })
    }
    
    func presentErrorMessage(_ title:String, message:String) {
        // Prepare the popup assets
        let title = title
        let message = message
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        let button = DefaultButton(title: "OK") {
            popup.dismiss()
        }
        
        popup.addButton(button)
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func validateFields() -> Bool {
        let isPasswordValid = (passwordTextField.text?.characters.count)! > 6
        
        if isPasswordValid == true && self.validateEmailAddress() {
            return true
        }
        else {
            return false
        }
    }
    
    func validateEmailAddress() -> Bool {
        if let email = emailTextField.text {
            return email.isValidEmailAddress()
        } else {
            return false
        }
    }

    func attributedLabel(_ label: TTTAttributedLabel, didSelectLinkWith url: URL) {
        if (url.scheme?.hasPrefix("action"))! {
            if url.host!.hasPrefix("present-registration") {
                self.delegate?.loginViewWantsToPresentAccountRegistration()
            }
        }
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
    
    lazy var attributedRegistrationLabel: TTTAttributedLabel = {
        var attirbutedLabel = TTTAttributedLabel.init(frame: CGRect.zero)
        attirbutedLabel.textColor = UIColor.white
        attirbutedLabel.font = UIFont(name: "Raleway-Regular", size: 16)
        attirbutedLabel.numberOfLines = 0
        attirbutedLabel.linkAttributes = [NSForegroundColorAttributeName: UIColor.white, NSUnderlineColorAttributeName: UIColor.customGoldColor(), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleThick.rawValue]
        attirbutedLabel.activeLinkAttributes = [NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue]
        attirbutedLabel.textAlignment = .left
        let labelText: NSString! = "Don’t have an account? Create one"
        attirbutedLabel.text = labelText as String
        let register: NSRange = labelText.range(of: "Create one")
        attirbutedLabel.addLink(to: URL(string: "action://present-registration")!, with: register)
        attirbutedLabel.delegate = self
        return attirbutedLabel
    }()
    
    lazy var loginButton: UIButton = {
        var button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleLoginButtonTapped), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.customGoldColor()
        return button
    }()
    
    func constructTextField() -> UITextField {
        let textField = HoshiTextField(frame: CGRect.zero)
        textField.placeholderColor = UIColor.lightGray
        textField.borderInactiveColor = UIColor.lightGray
        textField.borderActiveColor = UIColor.white
        textField.placeholderFontScale = 1.0
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        
        return textField
    }
}
