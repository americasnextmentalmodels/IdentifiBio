//
//  ViewController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 1/11/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

// fix chat partner messages to show
//
//

import UIKit
import Firebase
//#import "BEMCheckBox.h"


class MessagesController: UITableViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    let cellId = "cellIdMessages"
    var messages = [Message]()
    var users = [User]()
    var messagesDictionary = [String: Message?]()
    var recentMessageCells = [RecentMessageCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ////print("VC load")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                           action: #selector(handleLogout))
       
        
    
        tableView.separatorStyle = .none;
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

        checkIfUserIsLoggedIn()
     
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ////print("cleaning up the existing Auth handle...")
        //Auth.auth().removeStateDidChangeListener(handle!)
    }
    
//    func observeMessages() {
//        let ref = Database.database().reference().child("messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            if let postDict = snapshot.value as? [String : AnyObject] {
//                let message = Message()
//                
//                //Needs timestamp -- I don't know how to typecast it correctly
//                //sorry. //^Nick
//                //message.timestamp = NSNumber(value: Int(String(describing: dictionary["timestamp"]))!)
//
//                message.timestamp = 1000
//                message.text = postDict["text"] as? String
//                message.toId = postDict["toId"] as? String
//                message.fromId = postDict["fromId"] as? String
//                
//                if let toId = message.toId {
//                    self.messagesDictionary[toId] = message
//                    self.messages = Array(self.messagesDictionary.values)
//                }
//                self.tableView.reloadData()
//
//            }
//        })
        
    
        
        
//        let message = Message()
//        ref.observe(.childAdded, with: { (snapshot) in
//        ////print(snapshot)
//        let dictionary = snapshot.value as? [String : String] ?? [:]
//        message.fromId = dictionary[]
//        message.toId = ""
//        message.timestamp = ""
//        message.text = ""
        
//            if let dictionary = snapshot.value as? [String: AnyObject] ?? [:] {
//                let message = Message()
//                ////print(dictionary)
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
//                ////print("In observe messages")
//                ////print(self.messages)
//                self.tableView.reloadData()
//            }
        
    
    func observeUserMessages() {
        //print("In observeUserMessages")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //print("user id not available")
            return
        }
        
        
        //Don't loser be a oner
        
        ////print("observeUserMessages uid: " + uid)
        
        Database.database().reference().child("users").child(uid).child("referralCode").observeSingleEvent(of: .value, with: { (snapshot) in
            let currentUserReferralCode = snapshot.value as! String
            Database.database().reference().child("user-referral-codes").child(currentUserReferralCode).observeSingleEvent(of: .value, with: { (snapshot) in
                if let potentialChatPartnersDictionary = snapshot.value as? [String :  AnyObject] {
                    for kv in potentialChatPartnersDictionary {
                        //hack to allow adding nil values
                        let v : Message? = nil
                        self.messagesDictionary[kv.key] = v
                    }
                    //print("RESULT: ")
                    //print(self.messagesDictionary)
                    //print("--------")
                    //copy the potential chat users dictionary into
                    
                    //ALL CODE NEEDED AFTER DICTIONARY GOES IN HERE
                    //////////////////
                    //print("Uid")
                    //print(uid)
                    let ref = Database.database().reference().child("user-messages").child(uid)
                    //let ref = Database.database().reference().child("users").child(uid)
                    ref.observe(.childAdded, with: {(snapshot) in
                        
                        
                        let messageId = snapshot.key
                        ////print("messageId: " + messageId)
                        let messagesReference = Database.database().reference().child("messages").child(messageId)
                        
                        //HIPPA
                        //How is privacy practically avoided?
                        
                        //let userId = snapshot.key
                        //let usersReference = Database.database().reference().child("users")
                        
                        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                            //                //print(snapshot)
                            //usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
                            ////print("this block was executed, when the message controller is blank")
                            
                            // loop through all the users from the database, then, locate the message that belongs in the thread
                            
                            if let dictionary = snapshot.value as? [String : AnyObject] {
                                let message = Message(dictionary: dictionary)
                                ////print("Text: '" + message.text! + "' ID of message: " + snapshot.key)
                                
                                
                                //////print("message")
                                //////print(message)
                                //let user = User(dictionary: dictionary)
                                
                                
                                //user.uid = snapshot.key
                                //self.users.append(user)
                                //
                                //print("chatId")
                                //print(message.chatPartnerId())
                                if let chatPartnerId = message.chatPartnerId() {
                                    //print("chat partner id")
                                    //print(chatPartnerId)
                                    self.messagesDictionary[chatPartnerId] = message
                                    //print("mdict after cpi update")
                                    //print(self.messagesDictionary)
                                    ////print("the message dict - size " + String(self.messagesDictionary.count))
                                    ////print(self.messagesDictionary)
                                } else {
                                    print(">>>>nil problem")
                                }
                                //
                                
                                DispatchQueue.main.async (execute: {
                                    var messagesDictionaryCopy = self.messagesDictionary
                                    self.messages.removeAll()
                                    while (messagesDictionaryCopy.count >= 1) {
                                        let result = messagesDictionaryCopy.popFirst()
                                        //print(result!)
                                       if result?.value != nil {
                                        self.messages.append((result?.value)!)
                                        } else {
                                            //print("A nil was found")
                                        self.messages.append(Message(dictionary: ["toId": result?.key, "fromId": uid, "timestamp": -100, "text": "-", "referralCode": -100]))
                                        }
                                        
                                    }
                                    print("final dict")
                                    for message in self.messages {
                                        print("fromId: " + message.fromId!)
                                    }
                                    self.tableView.reloadData()
                                })
                                
                            }
                            
                        }, withCancel: nil)
                        ////print("Messages array:")
                        ////print(self.messages)
                    }, withCancel: nil)
                    
                    /////////////////////
                    //print("obtained chat partner dictionary")
                    
                }
                
            })
        })
        
    
    }
    
    
    //Needs timestamp -- I don't know how to typecast it correctly
    //sorry. //^Nick
    //message.timestamp = NSNumber(value: Int(String(describing: dictionary["timestamp"]))!)
    
    //                    message.timestamp = 1000
    //                    message.text = postDict["text"] as? String
    //                    message.toId = postDict["toId"] as? String
    //                    message.fromId = postDict["fromId"] as? String
    //
    //                    if let toId = message.toId {
    //                        self.messagesDictionary[toId] = message
    //                        self.messages = Array(self.messagesDictionary.values)
    //                    }
    //                    self.tableView.reloadData()
    
    
    
    
    
    //    func getUserId() {
    //        ////print("current auth")
    //
    //        if (Auth.auth().currentUser?.uid == nil) {
    //            //Check if our currentUser is not uid is not yet available if
    //            //not then let's wait for it before continuing
    //
    //            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
    //                //this is in the   the ID takes time to be assigned
    //                if (user?.uid == nil) {
    //                    ////print("userID null failure")
    //                    return;
    //                } else {
    //                    ////print("USER ID OK")
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
    //                ////print(error.localizedDescription)
    //            }
    //        } else {
    //            ////print(">>>>>>There was a failure to obtain the currentUser")
    //        }
    //    }
    
    //    func fetchUsers() {
    //        users.removeAll()
    //
    //        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
    //            ////print(snapshot)
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
    //                ////print("-->adding a matching user")
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
    //            ////print(">>>>>>>>>>users array:")
    //            ////print(self.users)
    //
    //
    //
    //
    //        }, withCancel: { (err) in
    //            ////print("Inside withCancel error handler: ")
    //            ////print(err);
    //        })
    //
    //
    //    }
    
    
    func showChatControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func checkIfUserIsLoggedIn() {
        //I didn't follow the tutorial for this exactly
        //Since I think Firebase has changed since then ^Nick
        ////print("checking if user is logged in:")
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            ////print(user?.uid)
            if (user?.uid != nil) {
                ////print("+++++OK USER IS SIGNED IN")
                //self.observeMessages()
                
                self.observeUserMessages()
                //self.getMessageableUsers()
                
            } else {
                //print(">>>>>ERROR USER NOT SIGNED IN")
                self.perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
            }
        }
    }
    
    
    @objc func handleLogout() {
        ////print("!!!!!!!!HANDLE LOGOUT CALLED")
        do {
            try Auth.auth().signOut()
            //print("Sign out probably OK")
        } catch let logoutError {
            //print(logoutError)
        }
        
        
        //loginController.messagesController = self
        let loginController = LoginController()
        //dismiss(animated: false, completion: nil)
        present(loginController, animated: true, completion: nil)
        
        
//        dismiss(animated: true, completion: {
//            //print("attempt dismissal")
//           //present(loginController, animated: true, completion: nil)
//        })
    }
    
    func handleMenu() {
        //        Stuff
        //        let regController = RegistrationController();
        //        present(regController, animated: true, completion: nil)
    }
    
    func getMessageableUsers() {
        guard let uid = Auth.auth().currentUser?.uid else {
            ////print("user id not available")
            return
        }
        var allUsersReference = Database.database().reference().child("users")
        allUsersReference.observe(.childAdded, with: { (snapshot) in
                //second observation
                // get all messageids in the user-messages, find the message that correspond to those messageids
                        if let bigDict = snapshot.value as? [String :  AnyObject] {
                            var userMessageIDList = [String]()
                            Database.database().reference().child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
                                
                                
                                    //userMessageIDList.append(snapshot.key)
                                    //////print(userMessageIDList)
                                Database.database().reference().child("messages").child(snapshot.key).observeSingleEvent(of: .childAdded, with: { (subtitle) in
                                    ////print("Subtitle")
                                    ////print(subtitle)
                                    if let littleDict = subtitle.value as? [String: AnyObject] {
                                        Database.database().reference().child("users").child(uid).child("referralCode").observeSingleEvent(of: .value, with: { (snapshot) in
                                        ////print("Refcode: ")
                                        ////print(snapshot)
                                        if bigDict["referralCode"] as? String == snapshot.value as? String {
                                            var argumentDictionary = [String: String]()
                                            argumentDictionary["cellTitle"] = bigDict["firstName"] as? String
                                            argumentDictionary["cellSubtitle"] = littleDict["text"] as? String
                                            let cell = RecentMessageCell(dictionary: argumentDictionary)
                                            ////print("cell to append")
                                            ////print(cell.cellSubtitle)
                                            self.recentMessageCells.append(cell)
                                            self.tableView.reloadData()
                                        }
                                        
                                    })
                                    }
                                })
                            })
                            
                        }
                    })
        }

    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        //        Auth.auth().removeStateDidChangeListener(handle!)
        ////print("view disappeared")
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
//        let data = recentMessageCells[indexPath.row]
//        cell.textLabel?.text = data.cellTitle
//        cell.detailTextLabel?.text = data.cellSubtitle
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let message = messages[indexPath.row]
        ////print(message?.toId)
        ////print(message?.text)
        
        // find the

        if let chatPartnerId = message.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(chatPartnerId)
            ref.observeSingleEvent(of: .value, with: ({ (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.textLabel?.text = dictionary["firstName"] as? String
                    cell.detailTextLabel?.text = message.text
                    
//                    ////print("cell title: " + dictionary["firstName"] as? String)
//                    ////print("cell subtitle: " + message?.text)
                }
            }))
        }

        ////print("Executed myself times: ")
        ////print(messagesDictionary.count)
        
        return cell
//
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        method handles a table view row is clicked
        //        using IndexPath instead of NSIndexPath used in video
        //        otherwise the override will fail //^Nick
        print("row clicked")
        
        if let userToMessageID = messages[indexPath.row].chatPartnerId() {
            Database.database().reference().child("users").child(userToMessageID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let user = User(dictionary: dictionary)
                //if let dictionary = snapshot.value as? [String: AnyObject] {
                user.firstName = dictionary["firstName"] as? String
                user.lastName = dictionary["lastName"] as? String
                user.email = dictionary["email"] as? String
                user.referralCode = dictionary["referralCode"] as? String
                
                //The reason this is snapshot.key is because there is no
                //uid item in a user object JSON. So we get the key of the
                //JSON in users since that refers to the user ID
                user.uid = snapshot.key
                //}
                
                print("displaying this user when row is clicked: ")
                print(user.firstName)
                self.showChatControllerForUser(user: user)
                
            })
        }
        //showChatControllerForUser(user: )
        
        //
        //        let message = messages[indexPath.row]
        //
        //        guard let chatPartnerId = message.chatPartnerId() else {
        //            return
        //        }
        //
        //        let ref = Database.database().reference().child("users").child(chatPartnerId)
        //        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        //            guard let dictionary = snapshot.value as? [String: AnyObject] else {
        //                return
        //            }
        //
        //            let user = User(dictionary: dictionary)
        //            user.uid = chatPartnerId
        //            self.showChatControllerForUser(user)
        //
        //        }, withCancel: nil)
        
    }
    
    //////////////////////////////////////////////////////////
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

