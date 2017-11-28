//
//  MatchesViewController.swift
//  Tinder
//
//  Created by 刘任驰 on 11/23/17.
//  Copyright © 2017 lrc. All rights reserved.
//

import UIKit
import Parse
class MatchesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CellInfoDelegate {
   
    @IBAction func backbtnTapped(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    var images : [UIImage] = []
    var userIds : [String] = []
    var messages : [String] = []
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        
        
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: acceptedPeeps)
                
                query.findObjectsInBackground(block: { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFile {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = UIImage(data: imageData) {
                                                
                                                if let objectId = theUser.objectId {
                                                    
                                                    
                                                    let messagesQuery = PFQuery(className: "Message")
                                                    
                                                    messagesQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                    messagesQuery.whereKey("sender", equalTo: theUser.objectId as Any)
                                                    
                                                    messagesQuery.findObjectsInBackground(block: { (objects, error) in
                                                        var messagetext = "No message from this user."
                                                        if let objects = objects {
                                                            for message in objects {
                                                                if let content = message["content"] as? String {
                                                                    messagetext = content
                                                                }
                                                            }
                                                        }
                                                        self.messages.append(messagetext)
                                                        self.userIds.append(objectId)
                                                        self.images.append(image)
                                                        self.tableView.reloadData()
                                                    })
                                                    
                                                    
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                })
            }
        }
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? MatchTableViewCell {
            cell.textView.text = "You haven't received a message yet"
            cell.profileImage.image = images[indexPath.row]
            cell.recipientObjectId = userIds[indexPath.row]
            cell.textView.text = messages[indexPath.row]
            
            cell.delegate = self  // <-- Set the delegate.
            return cell
        }
        return UITableViewCell()
    }
    
    
    // cell delegate method
    func processBtnTap() {
        
        self.displayAlert(title: "Info", message: "Message Sent!")
    }
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
