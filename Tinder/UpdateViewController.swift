//
//  UpdateViewController.swift
//  Tinder
//
//  Created by 刘任驰 on 11/20/17.
//  Copyright © 2017 lrc. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate ,UITextFieldDelegate{
    
    
    // MARK: - view
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var userGenderSwitch: UISwitch!
    
    @IBOutlet var interestedGenderSwitch: UISwitch!
    
    @IBOutlet var nameTextFiled: UITextField!
    
    @IBOutlet var addressTextFiled: UITextField!
    
    // MARK: - update func
    @IBAction func updateImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker,animated: true, completion: nil)
    }
    
    @IBAction func updateTapped(_ sender: UIButton) {
        
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWoman"] = interestedGenderSwitch.isOn
        PFUser.current()?["name"] = nameTextFiled.text
        PFUser.current()?["address"] = addressTextFiled.text
        
        if let image = profileImage.image{
            
            
            if let imageDate = UIImagePNGRepresentation(image){
                PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageDate)
                
                PFUser.current()?.saveInBackground(block: { (scuess, error) in
                    if error != nil {
                        
                        var defaultErrorMessage = " update Failed"
                        
                        if let newError = error as NSError?{
                            if let detailError = newError.userInfo["error"] as? String{
                                defaultErrorMessage = detailError
                            }
                        }
                        self.displayAlert(title: "Error", message:defaultErrorMessage )
                        
                    }else{
                        
                        print ("update scuessful")
//                         self.createWomenUser()
                        self.performSegue(withIdentifier: "updatetoSwipe", sender: nil)
                    }
                })
            }
            
            
            
        }
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        self.animateViewMoving(up: true,moveValue: 250)
        
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        
      
        self.view.frame.origin.y = movement ;
        
        // self.view.backgroundColor = UIColor.red
       
        
        UIView.commitAnimations()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        animateViewMoving(up: false, moveValue: 0)
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: -  seed data
    
    
    func createWomenUser(){
        let imageUrls = [
            "https://www.hollywoodreporter.com/sites/default/files/imagecache/Gallery_Portrait_720_1081/2016/07/selenagomez1SQ2016.jpg",
            "https://hips.hearstapps.com/hbz.h-cdn.co/assets/15/30/screen-shot-2015-07-22-at-114442-am.png",
            "https://media1.popsugar-assets.com/files/thumbor/vEYeIqBz1HEHWdSnqCyboCkowZg/fit-in/1024x1024/filters:format_auto-!!-:strip_icc-!!-/2016/04/11/840/n/2589278/c59b50e4_edit_img_cover_file_38336968_1459443600_Screen_Shot_2016-04-11_at_19.51.02/i/British-Celebrities-Instagram.png",
            "https://pbs.twimg.com/media/C_uP5UZXYAAAWp-.jpg",
            "http://asia.be.com/wp-content/uploads/sites/2/2016/09/jun-hasegawa-411x410.png",
            "https://hips.hearstapps.com/mac.h-cdn.co/assets/cm/14/49/320x320/54830dcce4a88_-_mcx-celebrity-instagram-8.png",
            "https://pbs.twimg.com/profile_images/744246249461784576/gCH7V4o6.jpg",
            "http://img.izismile.com/img/img9/20160920/640/the_most_beautiful_russian_girls_on_instagram_640_24.jpg",
            "http://informationng.com/wp-content/uploads/2014/08/Selfie-featured.jpg",
            "https://www.hellomagazine.com/imagenes/celebrities/2015081226699/top-celebrity-instagram-accounts/0-134-253/kim-k--a.jpg",
            "https://cdn-images-1.medium.com/max/1600/1*yGogdDhJY9gdT1I33tLbyQ.png"]
        
        var counter = -1
        
        let name = ["Emma",
                    "Olivia",
                    "Sophia",
                    "Ava",
                    "Isabella",
                    "Mia",
                    "Abigail",
                    "Emily",
                    "Taylor",
                    "Swift",
                    "Jane"]
        
        let address = ["3396 Rogers Street,Loveland,Ohio",
                       "1775 Sycamore Circle,Dallas,Texas",
                       "2858 Jerry Dove Drive,Wampee,South Carolina",
                       "3835 Romrog Way,Indianola",
                       "4915 Aaron Smith Drive,York,Pennsylvania",
                       "2149 Powder House Road,Lake Worth,Florida",
                       "1107 Roane Avenue,Houston,Texas",
                       "3427 Tuna Street,Pontiac,Michigan",
                       "2323 Rafe Lane,Memphis,Mississippi",
                       "877 Isaacs Creek Road,Springfield,Illinois",
                       "3204 Kowalewski,Dallas,Texas"]
        
        
        for imageUrl in imageUrls{
            counter += 1
            if let url = URL(string: imageUrl){
                if let data = try? Data(contentsOf: url){
                    let imageFile = PFFile(name: "photo.png", data: data)
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "abc123"
                    user["name"] = name[counter]
                    user["address"] = address[counter]
                    user["isFemale"] = true
                    user["isInterestedInWoman"] = false
                    
                    user.signUpInBackground(block: { (scuess, error) in
                        if scuess {
                            print("women user created")
                        }
                    })
                    
                }
            }
            
        }
        
    }
    
    
    
    
    
    // MARK: - logic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameTextFiled.delegate = self
        addressTextFiled.delegate = self
        
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool{
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        
        if let isInterestedWomen = PFUser.current()?["isInterestedInWoman"] as? Bool{
            interestedGenderSwitch.setOn(isInterestedWomen, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile{
            
            photo.getDataInBackground(block: { (data, error) in
                if let imageData =  data {
                    if let image = UIImage(data: imageData){
                        self.profileImage.image = image
                    }
                }
            })
        }
        
        
        
        
        
        
        
        
        
        
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
