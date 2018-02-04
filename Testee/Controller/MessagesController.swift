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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("VC load")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                           action: #selector(handleLogout))
        //This is still broken and needs to be fixed.
        let image = UIImage(named: "newMessageIcon")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self,
                                                           action: #selector(handleNewMessage))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        

        
    
        checkIfUserIsLoggedIn()
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        //I didn't follow the tutorial for this exactly
        //Since I think Firebase has changed since then ^Nick
        if Auth.auth().currentUser?.uid == nil {
        perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                print("Snapshot result:")
                print(snapshot)
                
                let value = snapshot.value as? NSDictionary
                let username = value?["firstName"] as? String ?? "" //?? "" means if nil default the variable to ""
                
                print("username: " + username)
                
            }) { (error) in
                print("There was some error and the data you are attempting to access could not be read.")
                print(error.localizedDescription)
            }
        }
    }
    
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
                print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: false, completion: nil)
//        let regController = RegistrationController();
//        present(regController, animated: true, completion: nil)
    }
    
    @objc func handleMenu() {
        //        Stuff
        //        let regController = RegistrationController();
        //        present(regController, animated: true, completion: nil)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
//        }
//
//        Auth.auth().createUser(withEmail: "emombay@uci.edu", password: "password") {(user, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
         print("view disappeared")
    }
    
    


}

