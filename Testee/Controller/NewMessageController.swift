//
//  NewMessageController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 2/2/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var users = [User]() //I think let is immutable //^Nick
    var currentUser = User();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        //Hiding the default separators between table cells //^Nick
        tableView.separatorStyle = .none;
        intializeData()
    }
    
    func intializeData() {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.currentUser.firstName = value?["firstName"] as? String ?? ""
            self.currentUser.lastName = value?["lastName"] as? String ?? ""
            self.currentUser.referralCode = value?["referralCode"] as? String ?? ""
            self.currentUser.uid = snapshot.key
            
            print("snap key in intialize")
            print(snapshot.key)
            
            //Now we can begin to do the things we need to do
            //since our data is safely loaded into the variables
            self.fetchUsers()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //This function override is required to prevent a crash
        //I'm not sure why it is needed, but I need to work on
        //other things so I am moving on for now //^Nick
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        //not sure how this line works, or really what it does
        //but somehow it gets us a reference to a cell and
        //we use that cell reference to modify our table //^Nick
        print("tableView cell call")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.firstName

        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //since a user cannot start a message thread with themself
        return users.count
    }

    func fetchUsers() {
        print("Attempting to fetch user:");
      
        var userID = ""
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            //this is in the case the ID takes time to be assigned
            if (user?.uid == nil) {
                print("userID null failure")
                return;
            } else {
                print("USER ID OK")
                userID = (user?.uid)!
            }

        }
        

        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)


            let dictionary = snapshot.value as? [String : String] ?? [:]
            
            
            //Not sure why but this actually goes through every item
            //in the snapshot. Maybe it's because of the "in" earlier
            //^Nick
            
            print(">>>REFERRAL CODE")
            print(snapshot.key)
            
            if (self.currentUser.referralCode == dictionary["referralCode"] && self.currentUser.uid != snapshot.key) {
                print("-->adding a matching user")
                let user = User()
                user.firstName = dictionary["firstName"]
                user.lastName = dictionary["lastName"]
                user.email = dictionary["email"]
                user.referralCode = dictionary["referralCode"]
                self.users.append(user)
            }
            
            self.tableView.reloadData()

            print(self.users)
            
        }, withCancel: { (err) in
            print("Inside withCancel error handler: ")
            print(err);
        })
   }
    
    func updateTableView() {
        for user in users {
            print(user)
        }
        //so we can see the new changes in our table
        self.tableView.reloadData()
        
    }

    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

}
