//
//  LoginViewController.swift
//  Tinder
//
//  Created by 刘任驰 on 11/20/17.
//  Copyright © 2017 lrc. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

    // MARK: - view
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var login: UIButton!
    
    @IBOutlet var signup: UIButton!
    
    @IBAction func loginbtn(_ sender: UIButton) {
        if signUpMode {
           
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            
            user.signUpInBackground(block: { (scuess, error) in
                if error != nil {
                    
                    var defaultErrorMessage = " Sign up Failed"
                    
                    if let newError = error as NSError?{
                        if let detailError = newError.userInfo["error"] as? String{
                            defaultErrorMessage = detailError
                        }
                    }
                    self.displayAlert(title: "Error", message:defaultErrorMessage )
 
                }else{
                    
                    print ("sign up scuessful")
                    //should always go to update profile
                    self.performSegue(withIdentifier: "updatesegue", sender: nil)
                }
            })
            
            
            
        }else{
            
            if let userName = username.text{
                if let passWord = password.text{
                    PFUser.logInWithUsername(inBackground: userName, password: passWord, block: { (user, error) in
                        
                        if error != nil {
                            
                            var defaultErrorMessage = " Log in Failed"
                            
                            if let newError = error as NSError?{
                                if let detailError = newError.userInfo["error"] as? String{
                                    defaultErrorMessage = detailError
                                }
                            }
                            print(" Log in Failed")
                            self.displayAlert(title: "Error", message:defaultErrorMessage )
                            
                        }else{
                            
                            print ("Login scuessful")
                            // check is this user has profile or not
                            if user!["isFemale"] != nil{
                                self.performSegue(withIdentifier: "logintoSwipesegue", sender: nil)
                            }else{
                                self.performSegue(withIdentifier: "updatesegue", sender: nil)
                            }
                        }
                        
                    })
                }
            }
            
            
            
        }
        
        
        
        
        
    }
    
    
    @IBAction func signupbtn(_ sender: UIButton) {
        let loginImage = UIImage(named: "Login")
        let signImage = UIImage(named: "Sign up")
        
        if !signUpMode {
            login.setImage(signImage, for: .normal)
            signup.setImage(loginImage, for: .normal)
            signUpMode = true
        }else{
            login.setImage(loginImage, for: .normal)
            signup.setImage(signImage, for: .normal)
            signUpMode = false
        }
        
        
        
        
    }
    
    
    
    
    // MARK: - logic
    
    
    var signUpMode = false
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
            
            // check is this user has profile or not
            if PFUser.current()?["isFemale"] != nil{
                  self.performSegue(withIdentifier: "logintoSwipesegue", sender: nil)
                
            }else{
                 self.performSegue(withIdentifier: "updatesegue", sender: nil)
            }
          
          
           
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
