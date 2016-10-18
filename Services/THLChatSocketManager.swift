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

class THLChatSocketManager: NSObject {
    
    static let sharedInstance = THLChatSocketManager()
    
    let socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://hype-messenger-server.herokuapp.com")! as URL)
    
   override init() {
        super.init()
    
        socket.on("connect") {(data, ack) -> Void in
            //Check for new messages in data
            print(data)
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
        socket.emit("user connected", (THLUser.current()?.phoneNumber)!)
         listenForOtherMessages()
         listenForYourMessageSend()
    }
    
    func stopListeningForMessages() {
        
    }
    
    func listenForOtherMessages() {
         socket.on("gotNewNotification") { (dataArray, socketAck) -> Void in
           // TODO update icon
          
            
        }
    }
    
    func listenForYourMessageSend() {
        socket.on("msgSuccess") { (dataArray, socketAck) -> Void in
           print("Your message was sent succesfully..!")
            //UIApplication.shared.keyWindow?.rootViewController?.navigationItem.title = "TESTMSG"
         
            
        }
    }
    
    func sendMessageToServer(message: String, to: String, roomId: String) {
        var usersPN = (THLUser.current()?.phoneNumber)!
        let data = ["to": to,"msg":message, "from": usersPN, "roomId": roomId]
        socket.emit("chat message", data)
    }
    
    func getMessageHistory(roomId: String, user: String) {
        let data = ["roomId": roomId, "userPN": user]
        socket.emit("get messages", data)
    }
    
}
