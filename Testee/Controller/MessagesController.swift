//
//  ViewController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 1/11/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase
//#import "BEMCheckBox.h"


class MessagesController: UITableViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    let cellId = "cellIdMessages"
    var messages = [Message]()
    var messagesDictionary = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("VC load")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                           action: #selector(handleLogout))
       
        
    
        tableView.separatorStyle = .none;
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user?.uid != nil) {
                self.observeMessages()
            }
        }
        
    
        
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let postDict = snapshot.value as? [String : AnyObject] {
                let message = Message()
                
                //Needs timestamp -- I don't know how to typecast it correctly
                //sorry. //^Nick
                //message.timestamp = NSNumber(value: Int(String(describing: dictionary["timestamp"]))!)

                message.timestamp = 1000
                message.text = postDict["text"] as? String
                message.toId = postDict["toId"] as? String
                message.fromId = postDict["fromId"] as? String
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                }
                self.tableView.reloadData()

            }
        })
        
        
//        let message = Message()
//        ref.observe(.childAdded, with: { (snapshot) in
//        print(snapshot)
//        let dictionary = snapshot.value as? [String : String] ?? [:]
//        message.fromId = dictionary[]
//        message.toId = ""
//        message.timestamp = ""
//        message.text = ""
        
//            if let dictionary = snapshot.value as? [String: AnyObject] ?? [:] {
//                let message = Message()
//                print(dictionary)
//
//                //The tutorial wants to use this
//                //but it causes a crash because
//                //of potentially a key-value
//                //mismatch
//                //^Nick
//                message.setValuesForKeys(dictionary)
//                //Therefore I am using the standard dictionary
//                //setter instead
//
////                message.fromId = dictionary["fromId"]
////                message.toId = dictionary["toId"]
//
//                //Needs timestamp -- I don't know how to typecast it correctly
//                //sorry. //^Nick
//                //message.timestamp = NSNumber(value: Int(String(describing: dictionary["timestamp"]))!)
////                message.timestamp = 1000
////                message.text = dictionary["text"]
//
//                self.messages.append(message)
//                print("In observe messages")
//                print(self.messages)
//                self.tableView.reloadData()
//            }
        
    }
    
    
    
//    func getUserId() {
//        print("current auth")
//
//        if (Auth.auth().currentUser?.uid == nil) {
//            //Check if our currentUser is not uid is not yet available if
//            //not then let's wait for it before continuing
//
//            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//                //this is in the   the ID takes time to be assigned
//                if (user?.uid == nil) {
//                    print("userID null failure")
//                    return;
//                } else {
//                    print("USER ID OK")
//                    self.currentUser.uid = (user?.uid)!
//                }
//                self.getCurrentUser()
//            }
//        } else {
//            self.getCurrentUser()
//        }
//    }
//
//    func getCurrentUser() {
//        if (Auth.auth().currentUser?.uid != nil) {
//            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
//                // Get user value
//                let value = snapshot.value as? NSDictionary
//                self.currentUser.firstName = value?["firstName"] as? String ?? ""
//                self.currentUser.lastName = value?["lastName"] as? String ?? ""
//                self.currentUser.referralCode = value?["referralCode"] as? String ?? ""
//                self.currentUser.uid = snapshot.key
//
//                //Now we can begin to do the things we need to do
//                //since our data is safely loaded into the variables
//                self.fetchUsers()
//                // ...
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//        } else {
//            print(">>>>>>There was a failure to obtain the currentUser")
//        }
//    }
    
//    func fetchUsers() {
//        users.removeAll()
//
//        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
//
//
//            let dictionary = snapshot.value as? [String : String] ?? [:]
//
//
//            //Not sure why but this actually goes through every item
//            //in the snapshot. Maybe it's because of the "in" earlier
//            //^Nick
//
//
//            if (self.currentUser.referralCode == dictionary["referralCode"] && self.currentUser.uid != snapshot.key) {
//                print("-->adding a matching user")
//                let user = User()
//                //I do this a little different from this video
//                //because this is a little more clear
//                //^Nick
//                user.firstName = dictionary["firstName"]
//                user.lastName = dictionary["lastName"]
//                user.email = dictionary["email"]
//                user.referralCode = dictionary["referralCode"]
//                user.uid = snapshot.key
//                self.users.append(user)
//            }
//
//            self.tableView.reloadData()
//
//            print(">>>>>>>>>>users array:")
//            print(self.users)
//
//
//
//
//        }, withCancel: { (err) in
//            print("Inside withCancel error handler: ")
//            print(err);
//        })
//
//
//    }
    
    
    func showChatControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func checkIfUserIsLoggedIn() -> Bool {
        //I didn't follow the tutorial for this exactly
        //Since I think Firebase has changed since then ^Nick
        
        if Auth.auth().currentUser?.uid == nil {
            print(">>>>>ERROR USER NOT SIGNED IN")
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            return false
        } else {
            print("+++++OK USER IS SIGNED IN")
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
                let value = snapshot.value as? NSDictionary
                let username = value?["firstName"] as? String ?? "" //?? "" means if nil default the variable to ""
                
                print("username: " + username)
                
            }) { (error) in
                print("There was some error and the data you are attempting to access could not be read.")
                print(error.localizedDescription)
            }
            return true
        }
    }
    
    
    @objc func handleLogout() {
        print("!!!!!!!!HANDLE LOGOUT CALLED")
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
                print(logoutError)
        }
        
        let loginController = LoginController();
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleMenu() {
        //        Stuff
        //        let regController = RegistrationController();
        //        present(regController, animated: true, completion: nil)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {


    }
    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
         print("view disappeared")
    }
    
    class UserCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super .init(style: .subtitle , reuseIdentifier: reuseIdentifier)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    /////////////Table view control methods//////////////////
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let message = messages[indexPath.row]
        
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: ({ (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.textLabel?.text = dictionary["firstName"] as? String
                }
            }))
        }
        cell.detailTextLabel?.text = message.text
        print("in table view")
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        method handles a table view row is clicked
//        using IndexPath instead of NSIndexPath used in video
//        otherwise the override will fail //^Nick
        
        if let userToMessageID = messages[indexPath.row].toId {
        Database.database().reference().child("users").child(userToMessageID).observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User()
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    user.firstName = dictionary["firstName"] as? String
                    user.lastName = dictionary["lastName"] as? String
                    user.email = dictionary["email"] as? String
                    user.referralCode = dictionary["referralCode"] as? String
                    
                    //The reason this is snapshot.key is because there is no
                    //uid item in a user object JSON. So we get the key of the
                    //JSON in users since that refers to the user ID
                    user.uid = snapshot.key
                }
                self.showChatControllerForUser(user: user)

          })
        }
        //showChatControllerForUser(user: )

    }
    
    //////////////////////////////////////////////////////////


}

