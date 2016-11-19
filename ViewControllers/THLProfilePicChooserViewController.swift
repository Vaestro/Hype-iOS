//
//  THLProfilePicChooserViewController.swift
//  Hype
//
//  Created by Bilal Shahid on 11/1/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit

class THLProfilePicChooserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let imagePicker = UIImagePickerController()
     let logo = UIImageView(image: UIImage(named: "default_profile_image"))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "ADD PROFILE PICTURE";
        imagePicker.delegate = self
        
        let topView = UIView()
        topView.backgroundColor = UIColor.black
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.black
        
        if ((THLUser.current()?.image) != nil) {
            let imageFile = THLUser.current()?.image as PFFile!
            let url = URL(string: imageFile!.url as String!)
            logo.kf.setImage(with: url)
        }
        
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        
        
        topView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.5)
        }
        
        bottomView.snp.makeConstraints { (make) -> Void in
            make.left.bottom.equalTo(0)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.5)
             make.width.equalTo(self.view.snp_width)
           
        }
        
       
        topView.addSubview(logo)
        logo.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(topView)
            make.centerY.equalTo(topView)
            make.width.equalTo(100)
            make.height.equalTo(110)
        }
        
        
        
        
        var tutorialsBtn = UIButton()
        
        tutorialsBtn.setTitle("Upload A Picture", for: UIControlState.normal)
        tutorialsBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        tutorialsBtn.backgroundColor = UIColor.customGoldColor()
        tutorialsBtn.addTarget(self, action: #selector(THLProfilePicChooserViewController.ratingButtonTapped(_:)), for: .touchUpInside)
        
        
        
        bottomView.addSubview(tutorialsBtn)
        
        tutorialsBtn.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(bottomView)
            make.centerY.equalTo(bottomView)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Action
    func ratingButtonTapped(_ button: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("GOT IMAGE")
            
            let imageData = UIImagePNGRepresentation(pickedImage);
            let imageFile = PFFile(name:"image.png", data:imageData!)
            var userPhoto = PFObject(className:"UserPhoto")
            var query = PFUser.query()
            query?.getObjectInBackground(withId: (THLUser.current()?.objectId)!) {
                (curUser: PFObject?, error: Error?) -> Void in
                if error != nil {
                    print(error)
                } else if let curUser = curUser {
                    curUser["image"] = imageFile
                    curUser.saveInBackground {
                        (success, error) -> Void in
                        if (success) {
                            // The object has been saved.
                            self.logo.image = pickedImage
                            THLUser.current()?.image = imageFile
                        } else {
                            // There was a problem, check error.description
                        }
                    }
                    THLUser.current()?.setValue(imageFile, forKey: "image")
                    //self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   
    
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
