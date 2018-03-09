//
//  UploadImagesController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 3/8/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase


class UploadImageController: UIViewController{
    
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
        
        //button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
//    @objc func handleLogin() {
//        //Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
//            if (error != nil) {
//                self.errorLabel.text = "ERROR: " + (error?.localizedDescription)!
//                return
//            }
//
//            //Else login successful
//            self.switchToMainScreen();
//        }
    
    
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
        
        
      
        
        //setupLabel()
    }
}
   
extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)}
}
    
    

