//
//  DateViewController.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/7/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

/*
extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from Date
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}*/

class DateViewController: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?
    
    let picker = UIDatePicker()
    
    let inputsContainerView: UIView = {
        let inputsContainerView = UIView()
        
        inputsContainerView.backgroundColor = UIColor(white: 1, alpha : 0)
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        //inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
        return inputsContainerView
    }()
    
    let dateField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.attributedPlaceholder = NSAttributedString(string: "Click Here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.backgroundColor = UIColor.clear.cgColor
        tf.frame.size.width = tf.intrinsicContentSize.width + 10
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.textColor = UIColor.white
        
        //disable autocapitalization and autocorrect for this text field
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNavigationBar()
        self.title = "Schedule"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        view.addSubview(inputsContainerView)
        
        setupInputsContainerView()
        createDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView =  picker
        
        //format picker date
        picker.datePickerMode = .date
        
        toolbar.tintColor = UIColor(r: 145, g: 0, b: 123)
    }
    
    @objc func donePressed(){
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateEpoch: Int = Int(picker.date.timeIntervalSince1970)
        print(dateEpoch)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //Prevent the code from running if Firebase connection is unavailable
            return
        }
        
        let values = ["nextAppointment": dateEpoch] as [String : Any]
        Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
            print("Successful data uploaded")
        }
        
        
        //let today: Int = Int(Date().timeIntervalSince1970)
        //print(today)
        //let diff = Int((dateEpoch - today)/86400)
        //print(diff)
        let dateString = formatter.string(from: picker.date)
        
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    /*func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 40, width: screenSize.width, height: 300))
        let navItem = UINavigationItem(title: "")
        /*let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(handleLogout))
         let messagesItem = UIBarButtonItem(title: "Messages", style: .plain, target: nil, action: #selector(handleMessages))
         let profileItem = UIBarButtonItem(title: "Profile", style: .plain, target: nil, action: #selector(handleProfile))
         navItem.rightBarButtonItem = logoutItem
         navItem.leftBarButtonItem = messagesItem*/
        
        let logoutImage = UIImage(named: "logoutBtn.png")!
        let messagesImage = UIImage(named: "chatBtn.png")!
        let profileImage = UIImage(named: "profileBtn.png")!
        let dateImage = UIImage(named: "dateBtn.png")!
        let homeImage = UIImage(named: "homeBtn.png")!
        
        let logoutButton = UIBarButtonItem(image: logoutImage,  style: .plain, target: nil, action: #selector(handleLogout))
        let messagesButton = UIBarButtonItem(image: messagesImage,  style: .plain, target: nil, action: #selector(handleMessages))
        let dateButton = UIBarButtonItem(image: dateImage,  style: .plain, target: nil, action: nil)
        let profileButton = UIBarButtonItem(image: profileImage,  style: .plain, target: nil, action: #selector(handleProfile))
        let homeButton = UIBarButtonItem(image: homeImage, style: .plain, target: nil, action: #selector(handleHome))
        
        navItem.rightBarButtonItems = [logoutButton, messagesButton, homeButton]
        navItem.leftBarButtonItems = [profileButton, dateButton]
        
        //navItem.setRightBarButtonItems(buttons, animated: true)
        navBar.setItems([navItem], animated: false)
        navBar.tintColor = UIColor(r: 145, g: 0, b: 123)
        self.view.addSubview(navBar)
    }*/
    
    @objc func handleMessages() {
        //dismiss(animated: true, completion: nil)
        let megController = MessagesController();
        present(megController, animated: true, completion: nil)
    }
    
    @objc func handleDate() {
        let dateController = DateViewController()
        present(dateController, animated: true, completion: nil)
    }
    
    @objc func handleProfile() {
        let proController = ProfileController();
        present(proController, animated: true, completion: nil)
    }
    
    @objc func handleHome() {
        //dismiss(animated: true, completion: nil)
        let homeController = HomeViewController();
        present(homeController, animated: true, completion: nil)
    }
    
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
    
    func setupInputsContainerView(){
        //need  x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        inputsContainerView.addSubview(dateField)
        dateField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        dateField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 0).isActive = true
        dateField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        dateField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

}
