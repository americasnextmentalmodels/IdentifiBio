//
//  ViewController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 1/11/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                           action: #selector(handleLogout))
   
        
    }
    
    @objc func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
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
    }


}

