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
    var chatMateName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = THLUser.current()?.objectId;
        self.senderDisplayName = "My Name";
        self.collectionView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        
        // Set up navbar
<<<<<<< HEAD
            
=======
        self.navigationItem.title = "CHAT WITH " + chatMateName!;
>>>>>>> 850514c76a0760347b4c663bc0a4aa9092d5645c
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        setupBubbles()
        setupAvatars()
        listenForMessageHistory()
        listenForMessages()
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = ""
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = "CHAT WITH " + chatMateName!

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.messages.removeAll()
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView?.textColor = UIColor.black
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView,
                                 avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource {
        
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage() , diameter: 1)
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String,
                               senderDisplayName: String, date: Date) {
        addMessage(id: senderId, text: text);
        self.finishSendingMessage(animated: true)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        THLChatSocketManager.sharedInstance.sendMessageToServer(message: text, to: chatMateId!, roomId: self.chatRoomId!)
        
        
    }
    
    func back() {
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupBubbles() {
        
        outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.white)
        incomingBubbleImageView =  JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.customGoldColor())
    }
    
    private func setupAvatars() {
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
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
        let usersID = (THLUser.current()?.objectId)!
        THLChatSocketManager.sharedInstance.getMessageHistory(roomId: self.chatRoomId!, user: usersID)
        
    }
    
}
