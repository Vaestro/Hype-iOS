//
//  THLChatEntryTableViewController.swift
//  Hype
//
//  Created by Bilal Shahid on 10/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLChatEntryTableViewController: UITableViewController {

    var roomData = [[String: String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MESSAGES";
        let barBack = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = barBack

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultId")
        //tableView.register(THLChatEntryCell.self, forCellReuseIdentifier: "chatEntry")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        
        tableView.register(THLChatEntryCell.self, forCellReuseIdentifier: "EntryCell")
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        var main =  UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        main.tabBar.items?[1].image = UIImage(named:"message")
        listenForRooms()
        THLChatSocketManager.sharedInstance.getChatRooms()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        THLChatSocketManager.sharedInstance.socket.off("send rooms")
        self.roomData.removeAll()
        self.tableView.reloadData()
        
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "chatEntry", for: indexPath)
        let cell = tableView.dequeueReusableCell( withIdentifier: "EntryCell", for: indexPath) as! THLChatEntryCell
        cell.priceLabel.text = roomData[indexPath.row]["roomTitle"]
        cell.priceLabel.backgroundColor = UIColor.black
        cell.priceLabel.alpha = 0.9
        cell.dateLabel.text = roomData[indexPath.row]["chatMateName"]
        if(roomData[indexPath.row]["chatMateImage"] != nil) {
            
            let url = NSURL(string:roomData[indexPath.row]["chatMateImage"]!)
            var components = NSURLComponents(url: url as! URL, resolvingAgainstBaseURL: true)! as NSURLComponents
            components.scheme = "https"
            
            var data = NSData(contentsOf:components.url!)
            if data != nil {
               cell.userImage.image = UIImage(data:data! as Data)
            }
        } else {
            cell.userImage.image = UIImage(named: "default_profile_image")
        }
       
        cell.backgroundColor = UIColor.black
        cell.alpha = 0.9
        
        
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
        print(indexPath.row)
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
                for room in rooms["rooms"]! {
                    
                    
                  
                    var curRoomInfo = [String: String]()
                    curRoomInfo["roomId"] = room["roomId"] as! String
                    curRoomInfo["roomTitle"] = room["roomTitle"] as! String
                    curRoomInfo["date"] = room["date"] as! String
                    curRoomInfo["chatMateName"] = room["chatMateName"] as! String
                    curRoomInfo["chatMateId"] = room["chatMateId"] as! String
                    if(room["chatMateImage"] != nil) {
                        curRoomInfo["chatMateImage"] = room["chatMateImage"] as! String
                    }
                    self.roomData.append(curRoomInfo)
                    
                    
                }
            
                self.tableView.reloadData()
            
            
        }
        
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
