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
    var chatMateId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.senderId = THLUser.current()?.phoneNumber;
        self.senderDisplayName = "My Name";
        // Set up navbar
        self.navigationItem.title = "CHAT";
    
        let barBack = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = barBack
        
        setupBubbles()
        setupAvatars()
        
        listenForMessages()
        
    
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String,
        senderDisplayName: String, date: Date) {
        addMessage(id: senderId, text: text);
        self.finishSendingMessage(animated: true)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        THLChatSocketManager.sharedInstance.sendMessageToServer(message: text, to: chatMateId!)
        
        
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
    
    private func listenForMessages() {
        THLChatSocketManager.sharedInstance.socket.on("gotNewMessage") { (dataArray, socketAck) -> Void in
            var map = dataArray[0] as! [String: String]
            if(map["from"] == self.chatMateId) {
                self.addMessage(id: map["from"]!, text: map["msg"]!)
            }
            self.finishReceivingMessage()
        }
    }
    
    private func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message!)
    }
    
  
  
}
