//
//  ProfileController.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/7/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase



class ProfileController: UITableViewController {
    


    var handle: AuthStateDidChangeListenerHandle?
    var cells = [ProfileViewCell]()
    let cellId = "profileViewCellID"
    let headerId = "profileViewHeaderID"
    var names = ["Signature": ["Edit signature"], "Official Documents": ["Upload ID", "Upload Insurance"], "Account": ["Change Password"]]
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()

    @objc func handleLogout() {
        //////print("!!!!!!!!HANDLE LOGOUT CALLED")
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
        //            ////print("attempt dismissal")
        //           //present(loginController, animated: true, completion: nil)
        //        })
    }

    class UserCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super .init(style: .subtitle , reuseIdentifier: reuseIdentifier)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    class HeaderCell: UITableViewHeaderFooterView {
        
        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
        }
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "Sample Question"
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNavigationBar()
        self.title = "Profile"
        // Do any additional setup after loading the view in viewDidLoad
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.register(HeaderCell.self, forHeaderFooterViewReuseIdentifier: headerId)
        for (key, value) in names {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        self.tableView.tableFooterView = UIView()


        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
        //                                                    action: #selector(handleLogout))

        //self.navigationController?.navigationBar.tintColor = UIColor(r: 145, g: 0, b: 123)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*func setNavigationBar() {
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
    }*/

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

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .left
        label.backgroundColor = UIColor.init(r: 247, g: 247, b: 247)
        label.text = "  " + objectArray[section].sectionName
        

        label.textColor = UIColor(r: 145, g: 0, b: 123)
        label.font = UIFont(name: "Avenir", size: 18)
        return label

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath) as! UserCell
        // Configure the cell...
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }

//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !objectArray.indices.contains(indexPath.section) {
            //safeguard to prevent multiple row selection
            //crash bug
            print("Row click could not be processed, index out of range.")
            return
        }
        let screenString = objectArray[indexPath.section].sectionObjects[indexPath.row]
        print("ss: " + screenString)
        switch screenString {
        case "Edit signature":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SignatureViewController")
            self.present(controller, animated: true, completion: nil)
            //present(SignatureViewController(), animated: true)
        case "Upload ID":
            present(HomeViewController(), animated: true)
        case "Upload Insurance":
            present(HomeViewController(), animated: true)
        case "Change Password":
            self.navigationController?.pushViewController(ChangePasswordController(), animated: true)
        default:
            print("Table cell not recognized. Is the string correct?")
        }


    }

}



 


/////////////Table view control stuff methods//////////////////





