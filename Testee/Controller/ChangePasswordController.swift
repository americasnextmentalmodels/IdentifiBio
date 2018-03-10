//
//  ChangePasswordController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 3/8/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase


class ChangePasswordController: UIViewController{
    //let purple = UIColor(r: 247, g: 247, b: 247)
    
    let inputsContainerView: UIView = {
    let inputsContainerView = UIView()
        
        inputsContainerView.backgroundColor = UIColor(r: 247, g: 247, b: 247)
    inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
    //inputsContainerView.layer.cornerRadius = 5
    inputsContainerView.layer.masksToBounds = true
    return inputsContainerView
    }()
    
    let ChangePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 247, g: 247, b: 247)
        button.backgroundColor = UIColor.purple
        button.setTitle("Change Password", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitleColor(UIColor(r: 145, g: 0, b: 123), for: .normal)
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        
        return button
    }()
    
    
    
    func comparePasswords(pw1: String, pw2: String) -> Bool{
        return pw1 == pw2
    }
    
    
    let currentPasswordTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.init(r: 230, g: 230, b: 230).cgColor
        tf.layer.borderWidth = 1
        tf.layer.backgroundColor = UIColor.white.cgColor
        tf.frame.size.width = tf.intrinsicContentSize.width + 10
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.textColor = UIColor.gray
        
        //For testing purposes, remove for development build.
        tf.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(r: 230, g: 230, b: 230)])
        
        return tf
    }()
    
    
    let newPasswordTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor(r: 230, g: 230, b: 230).cgColor
        tf.layer.borderWidth = 1
        tf.layer.backgroundColor = UIColor.white.cgColor
        tf.frame.size.width = tf.intrinsicContentSize.width + 10
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.textColor = UIColor.gray
        
        //For testing purposes, remove for development build.
        tf.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor(r: 230, g: 230, b: 230)])
        
        return tf
    }()
    
    let confirmNewPasswordTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor(r: 230, g: 230, b: 230).cgColor
        tf.layer.borderWidth = 1
        tf.layer.backgroundColor = UIColor.white.cgColor
        tf.frame.size.width = tf.intrinsicContentSize.width + 10
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.textColor = UIColor.gray
        
        //For testing purposes, remove for development build.
        tf.attributedPlaceholder = NSAttributedString(string: "ConfrimNew Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor(r: 230, g: 230, b: 230)])
        
        return tf
    }()
    

    
    let changePasswordLabel: UILabel = {
        let welcome = UILabel()
        welcome.translatesAutoresizingMaskIntoConstraints = false
        welcome.text = "Please enter the details \nbelow to reset your password"
        welcome.numberOfLines = 2
        welcome.textColor = UIColor(r: 230, g: 230, b: 230)
        welcome.font = UIFont(name: welcome.font.fontName, size: 15)
        welcome.textAlignment = .center
        return welcome
    }()
    
    let errorLabel: UILabel = {
        let el = UILabel()
        el.translatesAutoresizingMaskIntoConstraints = false
        el.textColor = UIColor.red
        el.font = UIFont(name: el.font.fontName, size: 15)
        el.textAlignment = .center
        el.lineBreakMode = .byWordWrapping
        el.numberOfLines = 3
        
        return el
    }()
    
    
    @objc func changePassword() {
        let user = Auth.auth().currentUser
        var credential: AuthCredential
        
        
        credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: currentPasswordTextField.text!)
        
        user?.reauthenticate(with: credential) { error in
            if error != nil {
                // An error happened.
                self.errorLabel.text = "ERROR: " + (error?.localizedDescription)!
                return
            } else {
                // User re-authenticated.
                if (self.comparePasswords(pw1: self.newPasswordTextField.text!, pw2: self.confirmNewPasswordTextField.text!)){
                    Auth.auth().currentUser?.updatePassword(to: self.newPasswordTextField.text!) { (error) in
                        if (error != nil) {
                            self.errorLabel.text = "ERROR: " + (error?.localizedDescription)!
                            return
                        }
                        // user changed password
                        self.newPasswordTextField.text = ""
                        self.currentPasswordTextField.text = ""
                        self.confirmNewPasswordTextField.text = ""
                        
                        self.errorLabel.textColor = UIColor(r: 145, g: 0, b: 123)
                        self.errorLabel.text = "Successfully changed password"
                        //self.navigationController?.popViewController(animated: true)
                        print("User changed password")
                    }
                }
                else{
                    self.errorLabel.text = "Passwords do not match. Try again"
                    return
                }
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 247, g: 247, b: 247)
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        view.addSubview(inputsContainerView)
        view.addSubview(ChangePasswordButton)
       
        //view.addSubview(backgroundImage)
        
        
        setupInputsContainerView()
        setupChangePasswordButton()
       
    }
    
    func setupInputsContainerView(){
        //need  x, y, width, height constraints
//        print(navigationController?.navigationBar.topAnchor)
//        var anch = (navigationController?.navigationBar.topAnchor)!
        inputsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.height)!).isActive = true
//        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        inputsContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: (self.navigationController?.navigationBar.frame.size.height)!).isActive = true
        //inputsContainerView.backgroundColor = UIColor.black
        inputsContainerView.addSubview(currentPasswordTextField)
        //inputsContainerView.addSubview(backgroundImage)
        currentPasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        currentPasswordTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 100).isActive = true
        currentPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        currentPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/16).isActive = true
        
        inputsContainerView.addSubview(newPasswordTextField)
        //inputsContainerView.addSubview(backgroundImage)
        newPasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 15).isActive = true
        newPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        newPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/16).isActive = true
        
        inputsContainerView.addSubview(confirmNewPasswordTextField)
        confirmNewPasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        confirmNewPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 15).isActive = true
        confirmNewPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        confirmNewPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/16).isActive = true
        
        
        inputsContainerView.addSubview(changePasswordLabel)
        changePasswordLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        changePasswordLabel.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: -120).isActive = true
        changePasswordLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        changePasswordLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    
        
        inputsContainerView.addSubview(errorLabel)
        errorLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        errorLabel.topAnchor.constraint(equalTo: ChangePasswordButton.bottomAnchor, constant: 15).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupChangePasswordButton(){
        ChangePasswordButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        ChangePasswordButton.topAnchor.constraint(equalTo: confirmNewPasswordTextField.bottomAnchor, constant: 30).isActive = true
        ChangePasswordButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/2).isActive = true
        ChangePasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
   
    
    func setupLabel(){
        changePasswordLabel.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true

    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}
