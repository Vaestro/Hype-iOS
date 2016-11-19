//
//  THLChatEntryTableViewController.swift
//  Hype
//
//  Created by Bilal Shahid on 10/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import PermissionScope

class THLChatEntryTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // The data for all the rooms retrieved from the server
    var roomData = [[String: String]]()
    // The images dictionary
    var userImages = [[String: UIImage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultId")
        //tableView.register(THLChatEntryCell.self, forCellReuseIdentifier: "chatEntry")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.backgroundColor = UIColor.black
        tableView.register(THLChatEntryCell.self, forCellReuseIdentifier: "EntryCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultId")
        
        let permissionScope = PermissionScope()
        // Set up permissions
        permissionScope.headerLabel.text = "Don't miss out"
        permissionScope.bodyLabel.text = "We'll notify you know when someone messages you"
        permissionScope.addPermission(NotificationsPermission(notificationCategories: nil),
                                      message: "Enabling notifications makes sure you never miss a beat")
        
        // Show dialog with callbacks
        permissionScope.show({ finished, results in
            print("got results \(results)")
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
        })

        listenForRooms()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        var main =  UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        main.tabBar.items?[1].image = UIImage(named:"message")
        THLChatSocketManager.sharedInstance.getChatRooms()
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "MESSAGES"
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = ""

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        THLChatSocketManager.sharedInstance.socket.off("send rooms")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roomData.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "EntryCell", for: indexPath) as! THLChatEntryCell
        cell.titleLabel.text = roomData[indexPath.row]["roomTitle"]
        cell.titleLabel.backgroundColor = UIColor.black
        cell.titleLabel.alpha = 0.9
        cell.dateLabel.text = roomData[indexPath.row]["dateString"]
        
        if(roomData[indexPath.row]["chatMateImage"] != nil) {
            
            let url = URL(string:roomData[indexPath.row]["chatMateImage"]!)
            
            
            let image = UIImage(named: "default_profile_iamge")
            cell.userImage.kf.setImage(with: url , placeholder:image)
            
            
        } else {
            
            cell.userImage.image = UIImage(named: "default_profile_image")
        }
        
        
        if(roomData[indexPath.row]["hasNew"] == "true") {
            
            cell.newImage.alpha = 1
        } else {
            cell.newImage.alpha = 0
        }
        
        
        
        cell.backgroundColor = UIColor.black
        cell.alpha = 0.9
        
        cell.msgLabel.text = roomData[indexPath.row]["lastMessage"]
        
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
         cell.textLabel?.text = roomData[indexPath.row]["roomTitle"]*/
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chatViewController = THLChatViewController()
        
        chatViewController.chatMateId = roomData[indexPath.row]["chatMateId"]
        chatViewController.chatRoomId = roomData[indexPath.row]["roomId"];
        chatViewController.chatMateName = roomData[indexPath.row]["chatMateName"]
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    func back() {
        dismiss(animated: true, completion: nil)
    }
    
    func listenForRooms() {
        THLChatSocketManager.sharedInstance.socket.on("send rooms") { (dataArray, socketAck) -> Void in
            
            
            var rooms = dataArray[0] as! [String:[NSDictionary]]
            var roomsArray = [[String]]();
            
            self.roomData.removeAll()
                for room in rooms["rooms"]! {
                    var curRoomInfo = [String: String]()
                    curRoomInfo["roomId"] = room["roomId"] as! String
                    curRoomInfo["roomTitle"] = room["roomTitle"] as! String
                    // CHECK IF DATES MATCH(MESSAGE IS NEW)
                    if(room["lastMessage"] != nil) {
                        curRoomInfo["lastMessage"] = room["lastMessage"] as! String
                        curRoomInfo["lastMsgOwner"] = room["lastMsgOwner"] as! String
                        let hasNew = room["hasNew"] as! Bool
                        if(hasNew) {
                            curRoomInfo["hasNew"] = "true";
                        } else {
                            curRoomInfo["hasNew"] = "false";
                        }
                    } else {
                        curRoomInfo["lastMessage"] = "Start a conversation.."
                        curRoomInfo["lastMsgOwner"] = THLUser.current()?.objectId
                        curRoomInfo["hasNew"] = "true"
                    }
                    curRoomInfo["date"] = room["date"] as! String
                    curRoomInfo["dateString"] = room["dateString"] as! String
                    if(room["chatMateName"] != nil)
                    {
                        curRoomInfo["chatMateName"] = room["chatMateName"] as! String
                    } else {
                        curRoomInfo["chatMateName"] = "No Name Provided"
                    }
                    
                    curRoomInfo["chatMateId"] = room["chatMateId"] as! String
                    if(room["chatMateImage"] != nil) {
                        curRoomInfo["chatMateImage"] = room["chatMateImage"] as! String
                    } else {
                        curRoomInfo["chatMateImage"] = nil
                    }
                    
                    self.roomData.append(curRoomInfo)
                    
                    
                }
                
                
                self.tableView.performSelector(onMainThread:Selector("reloadData"), with: nil, waitUntilDone: true)
                
            
            
            
        }
        
        
        func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
            let str = "No Messages"
            let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
        
        func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
            let str = "When you receive a message, it will show here"
            let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
            return NSAttributedString(string: str, attributes: attrs)
        }
        
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("CALLED")
        THLChatSocketManager.sharedInstance.getChatRooms()
        refreshControl.endRefreshing()
    }
    
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
