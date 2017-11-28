//
//  ViewController.swift
//  Tinder
//
//  Created by 刘任驰 on 11/20/17.
//  Copyright © 2017 lrc. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {
    
    // show the current user ID in the swipe area
    var displayuserID = ""
    
    
    
    @IBOutlet var swipView: UIView!
    
    @IBOutlet var SignimgeView: UIImageView!
    //log out
   
    @IBAction func logoutbtn(_ sender: UIBarButtonItem) {
        PFUser.logOut()
    
      
        self.performSegue(withIdentifier: "logoutsegue", sender: nil)
    }
    
    @IBOutlet var userAddress: UILabel!
    @IBOutlet var UserName: UILabel!
    @IBOutlet var swipeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // taeget , send infomation to who ? - > self
        let gestrue = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer: )))
        
        swipView.addGestureRecognizer(gestrue)
        
        updateImage()
        
        
        
        
        // get geo location and save
        // this geo location function  wouldn't be use in app, since the seed data is too small
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let point = geoPoint {
                
                PFUser.current()?["location"] = point
                PFUser.current()?.saveInBackground()
            }
        }
        
        
        
        
        
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
        
        let labelPoint =  gestureRecognizer.translation(in: view)
        
        swipView.center = CGPoint(x: view.bounds.width/2 + labelPoint.x , y:  view.bounds.height/2 + labelPoint.y)
        
        // set up the the positon and the CGAffineTransform
        let xFromCenter = view.bounds.width / 2 - swipView.center.x
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/200)
        
        let scale = min(100/abs(xFromCenter), 1)
        
        var scaleAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        swipView.transform = scaleAndRotated
        
        
        
        if gestureRecognizer.state == .ended{
            
            
            // deal with the accpeted and rejected
            var acceptedORrejected = ""
            
            
            
            
            
            if swipView.center.x < (view.bounds.width / 2 - 100) {
                print("no Interested")
                self.SignimgeView.isHidden = false
                SignimgeView.image = UIImage(named: "NopeSign")
                acceptedORrejected = "rejected"
            }
            if swipView.center.x > (view.bounds.width / 2 + 100) {
                print("Interested")
                self.SignimgeView.isHidden = false
                SignimgeView.image = UIImage(named: "LikeSign")
                acceptedORrejected = "accepted"
            }
            
            
            
            
            if acceptedORrejected != "" && displayuserID != "" {
                // add displayuserID to the accepted OR rejected column
                PFUser.current()?.addUniqueObject(displayuserID, forKey: acceptedORrejected)
                PFUser.current()?.saveInBackground(block: { (scuess, error) in
                    if scuess {
                        // if save scuessfully ,means get another user to swipe areazz
                        self.updateImage()
                        //after scueess , need update the query
                    }
                })
                
            }
            
            
            
            
            
            // resume the positon and the CGAffineTransform
            rotation = CGAffineTransform(rotationAngle: 0)
            
            scaleAndRotated = rotation.scaledBy(x: 1, y: 1)
            
            swipView.transform = scaleAndRotated
            
            swipView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        }
        
    }
    
    // update the info in the parse server  to show in the swipe UI area
    func updateImage(){
        // update name and address
        
        
       
       
        
        
        
        
        
        self.SignimgeView.isHidden = true
        
        
        
        if let query = PFUser.query() {
            
            
            // user match logic
            
            // find all target user
            if let isInterestedInWoman = PFUser.current()?["isInterestedInWoman"]{
                query.whereKey("isFemale", equalTo:isInterestedInWoman )
            }
            
            // form target user find if they also prefer this gender kind
            if let isFemale = PFUser.current()?["isFemale"]{
                query.whereKey("isInterestedInWoman", equalTo:isFemale )
            }
            
            
            
            // when update the image for next
            //get the accepted and rejected array
            var ignoreUser: [String] = []
            if let accpetedUsers = PFUser.current()?["accepted"] as? [String]{
                ignoreUser += accpetedUsers
            }
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String]{
                ignoreUser += rejectedUsers
            }
         
            query.whereKey("objectId", notContainedIn: ignoreUser)

            
           // filter the geo point in the same place
//            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint {
//                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1))
//            }
            
            
            
            
            
            query.limit = 1
            
            query.findObjectsInBackground { (objects, error) in
                if let users = objects{
                    for object in users{
                        if let user = object as? PFUser {
                            
                            // update name , address
                            if let name =  user["name"] as? String{
                                self.UserName.text  = name
                            }else{
                                self.UserName.text  = "uknow name"
                            }
                            
                            if let address =  user["address"] as? String{
                                self.userAddress.text = address
                            }else{
                                self.userAddress.text = "unknown address"
                            }
                            
                            
                            
                            
                            
                            if let imageFile = user["photo"] as? PFFile{
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data{
                                        
                                        self.swipeImage.image = UIImage(data: imageData)
                                        if let objectID = object.objectId{
                                            self.displayuserID = objectID
                                        }
                                        
                                    }
                                })
                                
                                
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

