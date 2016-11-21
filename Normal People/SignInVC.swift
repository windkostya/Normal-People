//
//  ViewController.swift
//  Normal People
//
//  Created by Kostya Yaremtso on 11/18/16.
//  Copyright © 2016 Kostya Yaremtso. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pawdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            
            performSegue(withIdentifier: "gotoFeed", sender: nil)
        }
    }


    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error != nil) {
            
                print("Kostya: Unable to login to facebook")
            }
            else if result?.isCancelled == true {
            
            print ("Kostya canceled authantification")
            } else {
            
                print("Sucessfully login")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(_credential: credential)
            
            }
        }
    }
    
    func firebaseAuth(_credential: FIRAuthCredential) {
    
        FIRAuth.auth()?.signIn(with: _credential, completion: { (user, error) in
            if (error != nil) {
            print("Kostya trying to login but its not working \(error)")
            
            } else {
            
                print("Login is working")
                if let user = user {
                self.completeSign(id: user.uid)
                
                
                }
                
            }
        })
    
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pawdField.text {
        
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if (error == nil) {
                
                print("Email user authenticated with firebase")
                    if let user = user {
                        self.completeSign(id: user.uid)
                        
                        
                    }

                } else {
                
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if (error != nil) {
                    print("unable to authenticated with Firebase \(error)")
                    
                    } else {
                    
                        print("Sucessfully authanticated with Firebase")
                        if let user = user {
                            self.completeSign(id: user.uid)
                            
                            
                        }

                    
                    }
                })
                
                }
                
                
            })
        }
        
        
    }
    
    func completeSign(id: String) {
        
        let keyChainResults = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "gotoFeed", sender: nil)
        print("New Controller User is signed in")
    }
    
}

