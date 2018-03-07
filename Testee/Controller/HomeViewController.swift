//
//  HomeViewController.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/7/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            //print(logoutError)
        }
        //loginController.messagesController = self
        let loginController = LoginController()
        //dismiss(animated: false, completion: nil)
        present(loginController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
        //                                                    action: #selector(handleLogout))
        
        //self.navigationController?.navigationBar.tintColor = UIColor(r: 145, g: 0, b: 123)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 40, width: screenSize.width, height: 300))
        let navItem = UINavigationItem(title: "")
        let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(handleLogout))
        let messagesItem = UIBarButtonItem(title: "Messages", style: .plain, target: nil, action: #selector(handleMessages))
        let homeItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: #selector(handleHome))
        navItem.rightBarButtonItem = logoutItem
        navItem.leftBarButtonItem = messagesItem
        //navItem.setRightBarButtonItems(buttons, animated: true)
        navBar.setItems([navItem], animated: false)
        navBar.tintColor = UIColor(r: 145, g: 0, b: 123)
        self.view.addSubview(navBar)
    }
    
    @objc func handleMessages() {
        dismiss(animated: true, completion: nil)
        //let megController = MessagesController();
        //present(megController, animated: true, completion: nil)
    }
    
    @objc func handleHome() {
        //        Stuff
        let megController = MessagesController();
        present(megController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
