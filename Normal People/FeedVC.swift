//
//  FeedVC.swift
//  Normal People
//
//  Created by Kostya Yaremtso on 11/20/16.
//  Copyright © 2016 Kostya Yaremtso. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableview.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }

    @IBAction func signOut(_ sender: Any) {
        
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)
        print("Sign out to the main controller")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "gotoSignVC", sender: nil)
    }

}
