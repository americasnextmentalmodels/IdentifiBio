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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("VC load")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                           action: #selector(handleLogout))
       
        //This is still broken and needs to be fixed with an image added
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Message", style: .plain, target: self,
                                                           action: #selector(handleNewMessage))
        

        view.addSubview(chatTextField)
        chatTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chatTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 260).isActive = true
        chatTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        chatTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
        tableView.separatorStyle = .none;
        
        checkIfUserIsLoggedIn()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
        cell.textLabel?.text = "Hello"
        
        return cell
    }
    
    
    
    /////TEMP PLEASE DELETE////////////
    
    let chatTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1
        //tf.layer.backgroundColor = UIColor.clear.cgColor
        tf.frame.size.width = tf.intrinsicContentSize.width + 10
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.textColor = UIColor.black
        
        //For testing purposes, remove for development build.
        tf.text = "ndigeron@uci.edu"
        
        //disable autocapitalization and autocorrect for this text field
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        
        return tf
    }()
    
    //////////
    
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

