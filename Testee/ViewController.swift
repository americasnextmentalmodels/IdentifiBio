//
//  ViewController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 1/11/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
        }
        
        Auth.auth().createUser(withEmail: "emombay@uci.edu", password: "password") {(user, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }


}

