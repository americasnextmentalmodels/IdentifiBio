//
//  ProfileViewController.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/9/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var documentLabel: UILabel!

    let inputsContainerView: UIView = {
        let inputsContainerView = UIView()
        
        inputsContainerView.backgroundColor = UIColor(white: 1, alpha : 0)
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        //inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
        return inputsContainerView
    }()
    
    let updateSigButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Signature", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(updateSig), for: .touchUpInside)
        
        return button
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Password", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        
        return button
    }()
    
    let updateDocButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Documents", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(updateDoc), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        view.addSubview(welcomeLabel)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(nameLabel)
        view.addSubview(image)
        view.addSubview(accountLabel)
        view.addSubview(documentLabel)
        view.addSubview(inputsContainerView)
        
        setupSaveButton()
        // Do any additional setup after loading the view.
    }
    
    @objc func updateSig(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignatureViewController")
        self.present(controller, animated: true, completion: nil)
    }

    @objc func updateDoc(){
        self.navigationController?.pushViewController(UploadImagesController(), animated: true)
    }
    
    @objc func changePassword(){
        self.navigationController?.pushViewController(ChangePasswordController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //called every time the view appears
        super.viewWillAppear(animated)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //This is called is a fail safe which causes
            //nothing to happen if the uid is not pulled
            //from Firebase
            return
        }
        
        var name = "Test"
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String :  AnyObject] {
                let firstName = (dict["firstName"] as? String)!
                let lastName = (dict["lastName"] as? String)!
                let email = (dict["email"] as? String)!
                print(firstName + " " + lastName)
                name = firstName + " " + lastName
                self.nameLabel.text = "Name: " + name
                self.emailLabel.text = "Email: " + email
                
            }
        })
    }
    
    func setupSaveButton() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        inputsContainerView.addSubview(updateSigButton)
        //inputsContainerView.addSubview(backgroundImage)
        updateSigButton.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        updateSigButton.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        updateSigButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        updateSigButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/2).isActive = true
        updateSigButton.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/8).isActive = true
        updateSigButton.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        
        inputsContainerView.addSubview(updateDocButton)
        //inputsContainerView.addSubview(backgroundImage)
        updateDocButton.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        updateDocButton.topAnchor.constraint(equalTo: updateSigButton.bottomAnchor, constant: 20).isActive = true
        updateDocButton.widthAnchor.constraint(equalTo: updateSigButton.widthAnchor).isActive = true
        updateDocButton.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/8).isActive = true
        updateDocButton.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        
        inputsContainerView.addSubview(changePasswordButton)
        //inputsContainerView.addSubview(backgroundImage)
        changePasswordButton.leftAnchor.constraint(equalTo: passwordLabel.rightAnchor, constant: 40).isActive = true
        changePasswordButton.topAnchor.constraint(equalTo: passwordLabel.topAnchor).isActive = true
        changePasswordButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 5/12).isActive = true
        changePasswordButton.heightAnchor.constraint(equalTo: passwordLabel.heightAnchor).isActive = true
    }

}
