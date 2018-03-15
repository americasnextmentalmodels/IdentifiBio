////
////  RegistrationController.swift
////  Testee
////
////  Created by Mental ModelsTwo on 1/20/18.
////  Copyright © 2018 Mental ModelsTwo. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//
//class TOSController: UIViewController {
//
//    var handle: AuthStateDidChangeListenerHandle?
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
//            print("Auth state changed");
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        Auth.auth().removeStateDidChangeListener(handle!)
//    }
//
//
//    let inputsContainerView: UIView = {
//        let inputsContainerView = UIView()
//
//        inputsContainerView.backgroundColor = UIColor(white: 1, alpha : 0)
//        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
//        //inputsContainerView.layer.cornerRadius = 5
//        inputsContainerView.layer.masksToBounds = true
//        return inputsContainerView
//    }()
//
//    let loginRegisterButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor(r: 112, g: 47, b: 139)
//        button.setTitle("Register", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//
//        button.addTarget(self, action: #selector(switchToLoginScreen), for: .touchUpInside)
//        return button
//    }()
//
//
//    @objc func switchToLoginScreen() {
//        //@objc is somehow required when usimg #selector
//        //let loginController = LoginController()
//        //present(loginController, animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
//    }
//
//    let titleView: UILabel = {
//        let welcome = UILabel()
//        welcome.translatesAutoresizingMaskIntoConstraints = false
//        welcome.text = "Register"
//        welcome.textColor = UIColor.white
//        welcome.font = UIFont(name: welcome.font.fontName, size: 40)
//        welcome.textAlignment = .center
//        return welcome
//    }()
//
//    let termsAndConditions: UILabel = {
//        let welcome = UILabel()
//        welcome.translatesAutoresizingMaskIntoConstraints = false
//        welcome.text = ""
//        welcome.textColor = UIColor.white
//        welcome.font = UIFont(name: welcome.font.fontName, size: 14)
//        welcome.textAlignment = .center
//        welcome.numberOfLines = 2
//        return welcome
//    }()
//
//    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
//
//    override func viewDidLoad(){
//        super.viewDidLoad()
//
//
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)
//        scrollView.alwaysBounceVertical = true
//
//        //view.backgroundColor = UIColor(r: 180, g: 119, b: 206)
//        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
//        scrollView.addSubview(inputsContainerView)
//        view.addSubview(scrollView)
//        setupInputsContainerView()
//    }
//
//    @objc func endEditing(){
//        self.view.endEditing(true)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    func setupInputsContainerView(){
//
//        //this box is the main container box which we put other things inside of
//        //sort of like a div in CSS
//
//        //need  x, y, width, height constraints
//        //this constraint stuff is more or less just a way to position things on the page.
//        //you can get anchors relative to the view of some object for example
//        //the view.centerXAnchor refers
//
//        inputsContainerView.backgroundColor = UIColor.red
//        inputsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        inputsContainerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -10).isActive = true
//        inputsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -80).isActive = true
//        inputsContainerView.heightAnchor.constraint(equalTo: 600).isActive = true
//
//        inputsContainerView.addSubview(titleView)
//        setupTitle()
//
//        inputsContainerView.addSubview(loginRegisterButton)
//        setupLoginRegisterButton()
//
//        inputsContainerView.addSubview(termsAndConditions)
//        setupTermsAndConditions()
//
//    }
//
//    func setupTitle() {
//        titleView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        titleView.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 0).isActive = true
//        titleView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        titleView.heightAnchor.constraint(equalToConstant: 45).isActive = true
//
//    }
//
//    func setupLoginRegisterButton(){
//        loginRegisterButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 50).isActive = true
//    }
//
//    func setupTermsAndConditions(){
//        termsAndConditions.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        termsAndConditions.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 15).isActive = true
//        termsAndConditions.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        termsAndConditions.heightAnchor.constraint(equalToConstant: 45).isActive = true
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        //changes the UI bar in iOS to be light instead of dark
//        return .lightContent
//    }
//}
//
//
