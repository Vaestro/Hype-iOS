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
    var chatRoomId: String?
    
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
        listenForMessageHistory()
        listenForMessages()
       
        
    
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        grabMessagesOnDisk()
        getMessageHistory()
        finishReceivingMessage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        THLChatSocketManager.sharedInstance.socket.off("send message history")
        THLChatSocketManager.sharedInstance.socket.off("gotNewMessage")
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
        THLChatSocketManager.sharedInstance.sendMessageToServer(message: text, to: chatMateId!, roomId: self.chatRoomId!)
        
        
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
    
    private func grabMessagesOnDisk() {
        let defaults = UserDefaults.standard
        if((defaults.array(forKey: self.chatRoomId!)) != nil) {
           let msgArray = defaults.array(forKey: self.chatRoomId!) as! [[String]]
            for ms in msgArray {
                addMessage(id: ms[0], text: ms[1])
            }
            self.finishReceivingMessage()
            
        }
    }
    private func listenForMessageHistory() {
        let defaults = UserDefaults.standard
        THLChatSocketManager.sharedInstance.socket.on("send message history") { (dataArray, socketAck) -> Void in
            var messages = dataArray[0] as! [String:[NSDictionary]]
            let messagesOnDisk = defaults.array(forKey: self.chatRoomId!)
            if(messagesOnDisk?.count != messages["messages"]?.count){
                var msgArray = [[String]]();
                for msg in messages["messages"]! {
                    let tuple = [msg.value(forKey: "owner"), msg.value(forKey:"msg")]
                    msgArray.append(tuple as! [String])
                    
                }
                defaults.set(msgArray, forKey:self.chatRoomId!)
                defaults.synchronize()
                self.messages.removeAll()
                self.grabMessagesOnDisk()
            }
        }
    }
        
    private func getMessageHistory() {
        let usersPN = (THLUser.current()?.phoneNumber)!
        THLChatSocketManager.sharedInstance.getMessageHistory(roomId: self.chatRoomId!, user: usersPN)
    
    }
  
}
