//
//  RegistrationController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 1/20/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

var handle: AuthStateDidChangeListenerHandle?

class RegistrationController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            print("Auth state changed");
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    let inputsContainerView: UIView = {
        let inputsContainerView = UIView()
        
        inputsContainerView.backgroundColor = UIColor(white: 1, alpha : 0)
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        //inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
        return inputsContainerView
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 112, g: 47, b: 139)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    let returnToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already have account? Login.", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(switchToLoginScreen), for: .touchUpInside)
        
        return button
    }()
    
    let agreeTosButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Agree to Terms of Service", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(switchToLoginScreen), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func handleRegistration() {
        //print("Attempting to handle registration")
        //the guard I don't this is required, but supposedly it's supposed to make the code cleaner
        guard let email = emailTextField.text, let password = passwordTextField.text, let referralCode = referralCodeTextField.text,
        let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else {
            print("PROBLEM (nick's): The fields are not present for some reason.");
            return //we can't do anything if this is true
        }

//        print(email)
//        print(password)
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if (error != nil) {
                print("Other failure, user account couldn't be created")
                return
            }
            //otherwise, user is created
            
                //adding our referral code / email into the Firebase database (see Firebase console)
                var ref: DatabaseReference!
                ref = Database.database().reference()
            print("UID: " + (user?.uid)!)
            ref.child("users").child((user?.uid)!).setValue(["referralCode": referralCode, "email": email, "firstName": firstName, "lastName": lastName],  withCompletionBlock: { (error, dbref) in
                print("In completion block for registration controller")
                if (error == nil) {
                    self.switchToLoginScreen()
                } else {
                    print(error)
                }
            })
            ref.child("user-referral-codes").child(referralCode).updateChildValues([user!.uid: 1])
            
            
        }

    }
    
    @objc func switchToLoginScreen() {
        //@objc is somehow required when usimg #selector
        //let loginController = LoginController()
        //present(loginController, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.attributedPlaceholder = NSAttributedString(string: "First name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
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
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.attributedPlaceholder = NSAttributedString(string: "Last name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
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
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
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
    
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.backgroundColor = UIColor.clear.cgColor
        tf.frame.size.width = tf.intrinsicContentSize.width + 10
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.textColor = UIColor.white
        
        return tf
    }()
    
    
    let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.backgroundColor = UIColor.clear.cgColor
        tf.frame.size.width = tf.intrinsicContentSize.width + 10
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.textColor = UIColor.white
        
        return tf
    }()
    
    let referralCodeTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Referral code", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
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
    
    let welcomeLabel: UILabel = {
        let welcome = UILabel()
        welcome.translatesAutoresizingMaskIntoConstraints = false
        welcome.text = "Register"
        welcome.textColor = UIColor.white
        welcome.font = UIFont(name: welcome.font.fontName, size: 40)
        welcome.textAlignment = .center
        return welcome
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(r: 180, g: 119, b: 206)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(returnToLoginButton)
        view.addSubview(agreeTosButton)
        //view.addSubview(backgroundImage)
        
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupReturnToLoginButton()
        setupTosButton()
        //setupLabel()
    }
    
    func setupInputsContainerView(){
        
        //this box is the main container box which we put other things inside of
        //sort of like a div in CSS
        
        //need  x, y, width, height constraints
        //this constraint stuff is more or less just a way to position things on the page.
        //you can get anchors relative to the view of some object for example
        //the view.centerXAnchor refers
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        inputsContainerView.addSubview(welcomeLabel)
        welcomeLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 0).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        inputsContainerView.addSubview(firstNameTextField)
        //inputsContainerView.addSubview(backgroundImage)
        firstNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 15).isActive = true
        firstNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: (1/2)*0.95).isActive = true
        firstNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/10).isActive = true
        
        
        inputsContainerView.addSubview(lastNameTextField)
        //inputsContainerView.addSubview(backgroundImage)
        lastNameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.topAnchor, constant: 0).isActive = true
        lastNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: (1/2)*0.95).isActive = true
        lastNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/10).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        //inputsContainerView.addSubview(backgroundImage)
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 15).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/10).isActive = true
        
        inputsContainerView.addSubview(passwordTextField)
        //inputsContainerView.addSubview(backgroundImage)
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/10).isActive = true
        
        
        inputsContainerView.addSubview(confirmPasswordTextField)
        //inputsContainerView.addSubview(backgroundImage)
        confirmPasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/10).isActive = true
        
        inputsContainerView.addSubview(referralCodeTextField)
        referralCodeTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        referralCodeTextField.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 15).isActive = true
        referralCodeTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        referralCodeTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/10).isActive = true
        

    }
    
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: referralCodeTextField.bottomAnchor, constant: 50).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupReturnToLoginButton(){
        returnToLoginButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        returnToLoginButton.topAnchor.constraint(equalTo: referralCodeTextField.bottomAnchor, constant: 90).isActive = true
        returnToLoginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        returnToLoginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupTosButton(){
        agreeTosButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        agreeTosButton.topAnchor.constraint(equalTo: referralCodeTextField.bottomAnchor, constant: 1).isActive = true
        agreeTosButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        agreeTosButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    func setupLabel(){
        welcomeLabel.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        //        welcomeLabel.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 15).isActive = true
        //        welcomeLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        //        welcomeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        //changes the UI bar in iOS to be light instead of dark
        return .lightContent
    }
}

