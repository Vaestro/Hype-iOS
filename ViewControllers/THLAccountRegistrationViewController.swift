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

protocol THLAccountRegistrationViewControllerDelegate {
    func didCompleteRegistration()
}

class THLAccountRegistrationViewController: UIViewController, THLPhoneNumberVerificationViewControllerDelegate {
    var delegate: THLAccountRegistrationViewControllerDelegate?
    
    var userData: [String:AnyObject]?
    
    var firstNameTextField = UITextField()
    var lastNameTextField = UITextField()
    var emailTextField = UITextField()
    var phoneNumberTextField = UITextField()

    var maleRadioButton = UIButton()
    var femaleRadioButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ userData: [String:AnyObject]?) {
        self.userData = userData
        
        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black

        let backButton = UIBarButtonItem(image: UIImage(named:"back_button"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
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
        titleLabel.text = "CONFIRM INFORMATION"
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name:"Raleway-Bold",size:16)
        subtitleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        subtitleLabel.numberOfLines = 3
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.text = "We use your email and phone number to send you alerts from friends and receipts"
        
        firstNameTextField = constructTextField()
        firstNameTextField.placeholder = "First Name"
        if let firstName = userData?["first_name"] {
            firstNameTextField.text =  firstName as! String
        }
        
        lastNameTextField = constructTextField()
        lastNameTextField.placeholder = "Last Name"
        if let lastName = userData?["last_name"] {
            lastNameTextField.text =  lastName as! String
        }
        
        let genderRadioButtonLabel = label()
        genderRadioButtonLabel.text = "Gender"
        
        let maleTextButton = textButton()
        maleTextButton.setTitle("Male", for: .normal)
        maleTextButton.addTarget(self, action: #selector(maleRadioButtonToggle), for: .touchUpInside)
        
        let femaleTextButton = textButton()
        femaleTextButton.setTitle("Female", for: .normal)
        femaleTextButton.addTarget(self, action: #selector(maleRadioButtonToggle), for: .touchUpInside)
        
        maleRadioButton = radioButton()
        maleRadioButton.addTarget(self, action: #selector(maleRadioButtonToggle), for: .touchUpInside)
        
        femaleRadioButton = radioButton()
        femaleRadioButton.addTarget(self, action: #selector(femaleRadioButtonToggle), for: .touchUpInside)
        
        emailTextField = constructTextField()
        emailTextField.placeholder = "Email"
        if let email = userData?["email"] {
            emailTextField.text = email as! String
        }
        
        phoneNumberTextField = constructTextField()
        phoneNumberTextField.textColor = UIColor.gray
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.keyboardType = .numberPad
        
        if let phoneNumber = userData?["phone_number"] {
            phoneNumberTextField.text = phoneNumber as! String
        }
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subtitleLabel)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(phoneNumberTextField)

        scrollView.addSubview(genderRadioButtonLabel)
        scrollView.addSubview(maleTextButton)
        scrollView.addSubview(femaleTextButton)
        scrollView.addSubview(femaleRadioButton)
        scrollView.addSubview(maleRadioButton)
        scrollView.addSubview(continueButton)
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        subtitleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        firstNameTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.centerX).offset(-20)
            make.height.equalTo(50)
        }
        
        lastNameTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(50)

        }
        
        femaleRadioButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.right.equalTo(femaleTextButton.snp.left).offset(-10)
        }
        
        femaleTextButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(view.snp.right).offset(-20)
            make.centerY.equalTo(femaleRadioButton.snp.centerY)
        }

        maleRadioButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.right.equalTo(maleTextButton.snp.left).offset(-10)
            make.centerY.equalTo(femaleRadioButton.snp.centerY)
        }
        
        maleTextButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(femaleRadioButton.snp.left).offset(-15)
            make.centerY.equalTo(femaleRadioButton.snp.centerY)
        }
        
        genderRadioButtonLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(femaleRadioButton)
            make.left.equalTo(view.snp.left).offset(20)
        }

        emailTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(femaleRadioButton.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(25)
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.snp.bottom).offset(-25)
            make.height.equalTo(50)
        }
    }
    
    func maleRadioButtonToggle(_ sender: Any) {
        self.maleRadioButton.isSelected = true
        self.femaleRadioButton.isSelected = false
        
    }
    
    func femaleRadioButtonToggle(_ sender: Any) {
        self.femaleRadioButton.isSelected = true
        self.maleRadioButton.isSelected = false

    }
    
    func backButtonTapped() {
        
        // Prepare the popup assets
        let title = "Cancel account creation?"
        let message = "Your information will not be saved"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            popup.dismiss()
        }
        
        let buttonTwo = DefaultButton(title: "CONFIRM") {
            let currentUser = THLUser.current()
            self.navigationController?.popViewController(animated: true)
        }

        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    func handleContinueButtonTapped() {
        validateFields() == true ? presentValidatePhoneNumberViewController() : presentErrorMessage("Error", message:"Please complete all fields")
    }
    
    func presentValidatePhoneNumberViewController() {
        let phoneNumberVerificationViewController = THLPhoneNumberVerificationViewController()
        phoneNumberVerificationViewController.delegate = self
        self.navigationController?.pushViewController(phoneNumberVerificationViewController, animated: true)
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
        if firstNameTextField.text?.isEmpty ?? false && lastNameTextField.text?.isEmpty ?? false && self.checkGenderSelected() && self.validateEmailAddress() {
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
    
    func checkGenderSelected() -> Bool {
        return (femaleRadioButton.isSelected || maleRadioButton.isSelected)
    }
    
    func didVerifyPhoneNumber() {
        let currentUser = THLUser.current()
        currentUser?.fbId = userData?["id"] as! String
        currentUser?.firstName = firstNameTextField.text
        currentUser?.lastName = lastNameTextField.text
        currentUser?.email = emailTextField.text
        currentUser?.sex = maleRadioButton.isSelected == true ? THLSex.male : THLSex.female
        
        let picture:[String : AnyObject] = userData?["picture"] as! [String : AnyObject]
        let pictureData:[String : AnyObject] = picture["data"] as! [String : AnyObject]
        let url = pictureData["url"] as! String
    
        let imageData = NSData(contentsOf: URL(string: url)!)
        let profilePicture = PFFile(name: "profile_picture.png", data: imageData as! Data)
        
        currentUser?.image = profilePicture
        
        if ((userData?["verified"] as! Bool) == true) {
            currentUser?.fbVerified = true
        }
        else {
            currentUser?.fbVerified = false
        }
        currentUser?.type = THLUserType.guest
        currentUser?.saveInBackground{(success, error) in
            self.delegate?.didCompleteRegistration()
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
    
    func radioButton() -> UIButton {
        let radioButton = UIButton(type: .custom)
        radioButton.setImage(UIImage(named: "unchecked_box")!, for: .normal)
        radioButton.setImage(UIImage(named: "checked_box")!, for: .selected)
        return radioButton

    }
    
    lazy var continueButton: UIButton = {
        var button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleContinueButtonTapped), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.customGoldColor()
        return button
    }()
    
    func constructTextField() -> UITextField {
        let textField = HoshiTextField(frame: CGRect.zero)
        textField.placeholderColor = UIColor.lightGray
        textField.borderInactiveColor = UIColor.lightGray
        textField.borderActiveColor = UIColor.white

        textField.placeholderFontScale = 1.0

        return textField
    }
}
