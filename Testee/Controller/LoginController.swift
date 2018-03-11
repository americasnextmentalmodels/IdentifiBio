//
//  LoginController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 1/18/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

//find me 1124

import UIKit
import Firebase

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class LoginController: UIViewController {
    
    
    
    
    
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
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
 
        return button
    }()
    
    @objc func handleLogin() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if (error != nil) {
                self.errorLabel.text = "ERROR: " + (error?.localizedDescription)!
                return
            }
            //Else login successful
            self.switchToMainScreen();
        }
    }
    
    func switchToMainScreen() {
        print("switching to main screen")
        //present(viewController, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }

    let newAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New user? Create an account.", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(switchToRegisterScreen), for: .touchUpInside)
        
        return button
    }()
    
    @objc func switchToRegisterScreen() {
        //@objc is somehow required when usimg #selector
        let registrationController = RegistrationController()
        present(registrationController, animated: true, completion: nil)
    }
    
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
        
        //For testing purposes, remove for development build.
//        tf.text = "yuda@example.com"
        
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
        
//        //For testing purposes, remove for development build.
//        tf.text = "qqqqqq"
//
        return tf
    }()
    
    let welcomeLabel: UILabel = {
        let welcome = UILabel()
        welcome.translatesAutoresizingMaskIntoConstraints = false
        welcome.text = "Welcome"
        welcome.textColor = UIColor.white
        welcome.font = UIFont(name: welcome.font.fontName, size: 40)
        welcome.textAlignment = .center
        return welcome
    }()
    
    let errorLabel: UILabel = {
        let el = UILabel()
        el.translatesAutoresizingMaskIntoConstraints = false
        el.textColor = UIColor.white
        el.font = UIFont(name: el.font.fontName, size: 15)
        el.textAlignment = .center
        el.lineBreakMode = .byWordWrapping
        el.numberOfLines = 3
    
        return el
    }()
    
    

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(r: 180, g: 119, b: 206)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(newAccountButton)
        //view.addSubview(backgroundImage)
        
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupNewAccountButton()
        //setupLabel()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func setupInputsContainerView(){
        //need  x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        //inputsContainerView.addSubview(backgroundImage)
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 150).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/8).isActive = true
        
        inputsContainerView.addSubview(passwordTextField)
        //inputsContainerView.addSubview(backgroundImage)
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/8).isActive = true

        inputsContainerView.addSubview(welcomeLabel)
        welcomeLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -140).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputsContainerView.addSubview(errorLabel)
        errorLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        errorLabel.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 15).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupNewAccountButton() {
        newAccountButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        newAccountButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 90).isActive = true
        newAccountButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        newAccountButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupLabel(){
        welcomeLabel.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        welcomeLabel.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 15).isActive = true
//        welcomeLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        welcomeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)}
    
}

