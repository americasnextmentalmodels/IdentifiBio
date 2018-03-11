//
//  TabBarController.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/8/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var handle: AuthStateDidChangeListenerHandle?
    var freshLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
        //handleLogout()
        
        self.delegate = self
        
        UITabBar.appearance().tintColor = UIColor(r: 145, g: 0, b: 123)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if freshLaunch == true {
            freshLaunch = false
            self.selectedIndex = 2
            handleLogout()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tabOne = MessagesController()
        let tabOneBarItem = UITabBarItem(title: "Messages",image: UIImage(named: "chatBtn.png"), selectedImage: UIImage(named: "chatBtn.png"))
        tabOne.tabBarItem = tabOneBarItem
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabTwo = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        //self.present(controller, animated: true, completion: nil)
        //let tabTwo = ProfileController()
        let tabTwoBarItem = UITabBarItem(title: "Profile",image: UIImage(named: "profileBtn.png"), selectedImage: UIImage(named: "profileBtn.png"))
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = HomeViewController()
        let tabThreeBarItem = UITabBarItem(title: "Home",image: UIImage(named: "homeBtn.png"), selectedImage: UIImage(named: "homeBtn.png"))
        tabThree.tabBarItem = tabThreeBarItem
        
        let tabFour = DateViewController()
        let tabFourBarItem = UITabBarItem(title: "Schedule",image: UIImage(named: "dateBtn.png"), selectedImage: UIImage(named: "dateBtn.png"))
        tabFour.tabBarItem = tabFourBarItem
        
        let tabFive = LogoutViewController()
        let tabFiveBarItem = UITabBarItem(title: "Logout",image: UIImage(named: "logoutBtn.png"), selectedImage: UIImage(named: "logoutBtn.png"))
        tabFive.tabBarItem = tabFiveBarItem
        
        self.viewControllers = [tabTwo, tabFour, tabThree, tabOne, tabFive]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLogout() {
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
    

}
