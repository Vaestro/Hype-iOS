//
//  THLChatViewController.swift
//  Hype
//
//  Created by Bilal Shahid on 10/3/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import JSQMessagesViewController


class THLChatViewController : JSQMessagesViewController {
    
    // MARK: Properties
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "TESTID";
        self.senderDisplayName = "Drake";
        // Set up navbar
        self.navigationItem.title = "CHAT";
    
        let barBack = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = barBack
        
        setupBubbles()
        setupAvatars();
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addMessage(id:"Promoter", text: "Hey are you coming?")
        
        addMessage(id: senderId, text: "Yea I will be there!")
        addMessage(id: senderId, text: "Where is it exactly?")
      
        finishReceivingMessage()
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[(indexPath as NSIndexPath).item]
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView,
                                 avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource {
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "default_profile_image"), diameter: 20)
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        addMessage(id: senderId, text: text);
        addMessage(id: "Promoter", text: "Turn Up!!");
        self.finishSendingMessage(animated: true)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
    }
    
    func back() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupBubbles() {
        
        outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.black)
        incomingBubbleImageView =  JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.customGoldColor())
    }
    
    private func setupAvatars() {
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
    }
    
    private func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message!)
    }
    
  
  
}
