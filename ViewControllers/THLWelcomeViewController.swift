//
//  THLWelcomeViewController.swift
//  Hype
//
//  Created by Edgar Li on 11/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import AVFoundation
import SnapKit
import Mixpanel
import Parse
import ParseFacebookUtilsV4


protocol THLWelcomeViewDelegate {
    func welcomeViewDidConnectWithFacebookAndReceivedUserData(userData:[String:AnyObject])
    func welcomeViewWantsToPresentLoginView()
    func welcomeViewDidLoginWithFacebookAndWantsToPresentGuestInterface()
}

class THLWelcomeViewController: UIViewController {
    var delegate: THLWelcomeViewDelegate?
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    override func viewDidLoad() {
        

        addBackgroundVideoToView(self.view)
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.frame = CGRect(x:0,y:view.frame.size.height - 200,width:view.frame.size.width, height: 200)
        view.addSubview(containerView)
        view.addSubview(logoLabel)
        view.addSubview(subtitleLabel)

        containerView.addSubview(titleLabel)
        containerView.addSubview(facebookButton)
        containerView.addSubview(emailButton)

        logoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(150)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoLabel.snp.bottom)
            make.width.equalTo(150)

            make.centerX.equalTo(view.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(25)
            make.right.equalTo(containerView.snp.right).offset(-25)

            make.top.equalTo(containerView.snp.top).offset(35)
        }
        
        facebookButton.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(25)
            make.right.equalTo(containerView.snp.right).offset(-25)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
            
        }
        
        emailButton.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(25)
            make.top.equalTo(facebookButton.snp.bottom).offset(20)
        }
    }
    
    func addBackgroundVideoToView(_ view: UIView) {
        let theURL = Bundle.main.url(forResource:"Lavo", withExtension: "mov")
        
        avPlayer = AVPlayer.init(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear;
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }

    
    func playerItemDidReachEnd(notification: NSNotification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    func handleFacebookConnect() {
        let mixpanel = Mixpanel.mainInstance()
        mixpanel.track(event:"Touched facebook signup button")
        
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "user_photos","email", "user_friends"], block: {(user: PFUser?, error: Error?) -> Void in
            if let user = user {
                if (user.email == nil) {
                    self.requestFacebookInformation()
                    print("New user signed up and logged in through Facebook!")
                } else {
                    self.delegate?.welcomeViewDidLoginWithFacebookAndWantsToPresentGuestInterface()
                    
                    print("Returning user logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
            
        })
    }
    
    func requestFacebookInformation() {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,first_name,last_name,name,gender,verified,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
            }
            else {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                self.delegate?.welcomeViewDidConnectWithFacebookAndReceivedUserData(userData: data)
            }
        })

    }
    
    func handleEmailConnect() {
        self.delegate?.welcomeViewWantsToPresentLoginView()

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Constructors
    
    lazy var logoLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"Raleway-BoldItalic",size:40)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "HYPE"
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"Raleway-Medium",size:18)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Your ultimate guide to nightlife"
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"Raleway-Regular",size:20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text = "Get to the party tonight"
        return label
    }()
    
    lazy var facebookButton: UIButton = {
        var button = UIButton()
        button.setTitle("Connect with Facebook", for: .normal)
        button.addTarget(self, action: #selector(handleFacebookConnect), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor(red:0.00, green:0.49, blue:0.90, alpha:1.0)
        return button
    }()
    

    lazy var emailButton: UIButton = {
        var button = UIButton()
        button.setTitle("or use your email", for: .normal)
        
        button.addTarget(self, action: #selector(handleEmailConnect), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    
}
