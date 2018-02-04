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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        //Hiding the default separators between table cells //^Nick
        tableView.separatorStyle = .none;

        fetchUser()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //This function override is required to prevent a crash
        //I'm not sure why it is needed, but I need to work on
        //other things so I am moving on for now //^Nick
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        //not sure how this line works, or really what it does
        //but somehow it gets us a reference to a cell and
        //we use that cell reference to modify our table //^Nick
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.firstName
        return cell
    }

    func fetchUser() {
        print("Attempting to fetch user:");
        
        let userID = Auth.auth().currentUser?.uid
        print(userID)
        
        let recentPostsQuery = Database.database().reference().child("users")
        
//        Database.database().reference().child("users").child(userID!).child("firstName").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            print("Result new data:")
//            print(snapshot)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        
//        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
//
//
////            let dictionary = snapshot.value as? [String : String] ?? [:]
////
////            let user = User()
////
////            user.firstName = dictionary["firstName"]
////            user.lastName = dictionary["lastName"]
////            user.email = dictionary["email"]
////
////            self.users.append(user)
////            self.tableView.reloadData()
//
//        }, withCancel: { (err) in
//            print("Inside withCancel error handler: ")
//            print(err);
//        })
   }

    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

}
