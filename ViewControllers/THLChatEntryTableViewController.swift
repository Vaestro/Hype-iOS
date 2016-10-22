//
//  THLChatEntryTableViewController.swift
//  Hype
//
//  Created by Bilal Shahid on 10/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLChatEntryTableViewController: UITableViewController {

    var promoters = [String]()
    var roomIds = [String]()
    var mateIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hard coded stuff for testing
        var usersPN = (THLUser.current()?.phoneNumber)!
        if(usersPN == "+15715502992") {
            promoters.append("Your Inquiry")
            roomIds.append("tjP5OTYg6w");
            roomIds.append("U593pjlBNl");
            mateIds.append("+19178686312")
            mateIds.append("+17038151183")
        } else if(usersPN == "+19178686312") {
            roomIds.append("tjP5OTYg6w");
            mateIds.append("+15715502992")
        } else if(usersPN == "+17038151183") {
            roomIds.append("U593pjlBNl");
            mateIds.append("+15715502992")
        }
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
        return roomIds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "chatEntry", for: indexPath)
        let cell = tableView.dequeueReusableCell( withIdentifier: "EntryCell", for: indexPath) as! THLChatEntryCell
        cell.priceLabel.text = "Your Inquiry"
        cell.priceLabel.backgroundColor = UIColor.black
        cell.priceLabel.alpha = 0.9
        cell.dateLabel.text = "1 Week Ago"
        
       
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
       
        var usersPN = (THLUser.current()?.phoneNumber)!
        
        var chatViewController = THLChatViewController()
        chatViewController.chatMateId = mateIds[indexPath.row];
        chatViewController.chatRoomId = roomIds[indexPath.row];
        print("The Chat room id being passed is: ")
        print(roomIds[indexPath.row])
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    func back() {
        dismiss(animated: true, completion: nil)
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
