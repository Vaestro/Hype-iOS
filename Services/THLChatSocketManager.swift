//
//  THLChatSocketManager.swift
//  Hype
//
//  Created by Bilal Shahid on 10/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SocketIO
import Foundation
import Whisper

class THLChatSocketManager: NSObject {
    
    static let sharedInstance = THLChatSocketManager()
    
    let socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://hype-messenger-server.herokuapp.com/")! as URL)
    
    override init() {
        super.init()
        
        socket.on("connect") {(data, ack) -> Void in
            //Check for new messages in data
            
            self.connectUser();
        }
        
    }
    func establishConnection() {
        socket.connect()
        
    }
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectUser() {
        socket.emit("user connected", (THLUser.current()?.objectId)!)
        listenForOtherMessages()
        listenForYourMessageSend()
    }
    
    func stopListeningForMessages() {
        
    }
    
    func listenForOtherMessages() {
        socket.on("gotNewNotification") { (dataArray, socketAck) -> Void in
            //update icon
            var main =  UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            main.tabBar.items?[1].image = UIImage(named:"new_message")
            let murmur = Murmur(title: "You got a new message!")
            
            // Show and hide a message after delay
            show(whistle: murmur, action: .show(2.5))
            
            
        }
    }
    
    func listenForYourMessageSend() {
        socket.on("msgSuccess") { (dataArray, socketAck) -> Void in
            print("Your message was sent succesfully..!")
            
        }
    }
    
    func sendMessageToServer(message: String, to: String, roomId: String) {
        var usersID = (THLUser.current()?.objectId)!
        let data = ["to": to,"msg":message, "from": usersID, "roomId": roomId]
        socket.emit("chat message", data)
    }
    
    func getMessageHistory(roomId: String, user: String) {
        let data = ["roomId": roomId, "userPN": user]
        socket.emit("get messages", data)
    }
    
    func getChatRooms() {
        var userId = (THLUser.current()?.objectId)!
        let data = ["userId": userId]
        socket.emit("get rooms", data)
        
    }
    
    func createChatRoom(hostId: String) {
        var userId = (THLUser.current()?.objectId)!
        
        PFCloud.callFunction(inBackground: "createChatRoom",
                             withParameters: ["userId" : userId,
                                              "hostId": hostId]) {
                                                (something, error) in
                                                if error == nil {
                                                    
                                                } else {
                                                    
                                                    
                                                }
        }
    }
    
    func createSupportChatRoom() {
        var userId = (THLUser.current()?.objectId)!
        
        PFCloud.callFunction(inBackground: "createSupportChatRoom",
                             withParameters: ["userId" : userId]) {
                                                (something, error) in
                                                if error == nil {
                                                    
                                                } else {
                                                    
                                                    
                                                }
        }
    }
    
    
    
}
