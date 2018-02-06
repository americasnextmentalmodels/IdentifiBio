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
    var tableRowSize = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        //Hiding the default separators between table cells //^Nick
        tableView.separatorStyle = .none;

        fetchUsers()
        
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
        
        if (currentUser.referralCode == user.referralCode && currentUser != user) {
            //we only want to add new cells that have
            //a matching referral code, also people
            //cannot message themselves that's the
            //other condition in the if statement
            print(">>>>>>>>>>>>ref code match!!" + String(indexPath.row))
            cell.textLabel?.text = user.firstName
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //since a user cannot start a message thread with themself
        return tableRowSize
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
            
            
            let user = User()
            user.firstName = dictionary["firstName"]
            user.lastName = dictionary["lastName"]
            user.email = dictionary["email"]
            user.referralCode = dictionary["referralCode"]
            self.users.append(user)
            
            if (snapshot.key == Auth.auth().currentUser?.uid) {
                self.currentUser = user;
            }
            
            self.tableRowSize += 1
            
            self.tableView.reloadData()
            
            
            print("The users: " )
            print(self.users)
            print(self.currentUser)
            
            
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
