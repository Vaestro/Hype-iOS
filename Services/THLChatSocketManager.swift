//
//  THLChatSocketManager.swift
//  Hype
//
//  Created by Bilal Shahid on 10/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SocketIO

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
        listenForNotifications()
        //listenForMessages()
        
    }
    
    func stopListeningForMessages() {
        
    }
    
    func listenForNotifications() {
         socket.on("gotNewData") { (dataArray, socketAck) -> Void in
            print("Update menu item")
        }
    }
    
    func sendMessageToServer(message: String, to: String) {
        var usersPN = (THLUser.current()?.phoneNumber)!
        print(usersPN)
        print(to)
        let data = ["to": to,"msg":message, "from": usersPN]
        socket.emit("chat message", data)
    }
    
}
