//
//  UpdatedProfileView.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/13/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit

class UpdatedProfileView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        let bottomView = createBottomView()
        drawBottomBorder(inView: bottomView)
        let circleView = drawAndCreateImageView(viewToAlignTo: bottomView)
        let inputsViewContainer = drawAndCreateMainInputsContainer(inView: bottomView, circleView: circleView)
        let numberOfContainersForAutomaticSizing: CGFloat = 3
        let accountView = addContainerToView(toView: inputsViewContainer, underneathAnchor: inputsViewContainer.topAnchor, numberOfContainers: numberOfContainersForAutomaticSizing)
        setupAccountView(accountView: accountView)
        let signatureView = addContainerToView(toView: inputsViewContainer, underneathAnchor: accountView.bottomAnchor, numberOfContainers: numberOfContainersForAutomaticSizing)
        setupSignatureView(signatureView: signatureView)
        let documentsView = addContainerToView(toView: inputsViewContainer, underneathAnchor: signatureView.bottomAnchor, numberOfContainers: numberOfContainersForAutomaticSizing)
        setupDocumentsView(documentsView: documentsView)
        drawNameLabel(view: circleView)
        drawSettingsButton()

        
    }

    
    func createBottomView() -> UIView {
        let containerView: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white
            containerView.translatesAutoresizingMaskIntoConstraints = false
            return containerView
        }()
        view.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height/3).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return containerView
    }
    
    func drawBottomBorder(inView: UIView) {
        let containerView: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.orange
            containerView.translatesAutoresizingMaskIntoConstraints = false
            return containerView
        }()
        
        inView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: inView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: inView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: inView.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
    }
    
    func drawAndCreateImageView(viewToAlignTo: UIView) -> UIView {
        
        let height: CGFloat = 110
        let width: CGFloat = 110
        
        let imageView: UIImageView = {
            let theImageView = UIImageView()
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            theImageView.image = UIImage.init(named: "documentPlus.png")
            
            //Using height/2 to assure it still looks like a circle
            //even if we increase the height and width
            theImageView.layer.cornerRadius = CGFloat(height/2)
            theImageView.layer.masksToBounds = true
            theImageView.layer.borderWidth = 5
            theImageView.layer.borderColor = UIColor.orange.cgColor
            return theImageView
        }()
        
        view.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: viewToAlignTo.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: viewToAlignTo.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return imageView

    }
    
    func drawAndCreateMainInputsContainer(inView: UIView, circleView: UIView) -> UIView {
        let containerView: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white
            containerView.translatesAutoresizingMaskIntoConstraints = false
            return containerView
        }()
        inView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 20).isActive = true
        containerView.leftAnchor.constraint(equalTo: inView.leftAnchor, constant: 25).isActive = true
        containerView.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: -25).isActive = true
        containerView.bottomAnchor.constraint(equalTo: inView.bottomAnchor, constant: -50).isActive = true
        
        return containerView
    }
    
    func drawNameLabel(view: UIView){
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Yuda"
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 30)
            label.textAlignment = .center
            return label
        }()
        
        self.view.addSubview(title)
        title.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -35).isActive = true
        //title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        title.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        //title.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        //title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
    }
    
    func drawSettingsButton(){
        let imageView: UIImageView = {
            let theImageView = UIImageView()
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            theImageView.image = UIImage.init(named: "settingsButton.png")
            theImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAccountButton)))
            theImageView.isUserInteractionEnabled = true
            
            return theImageView
        }()
        
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    @objc func handleAccountButton(){
        self.navigationController?.pushViewController(ProfileController(), animated: true)
    }
    
    func addContainerToView(toView: UIView, underneathAnchor: NSLayoutYAxisAnchor, numberOfContainers: CGFloat) -> UIView{
        let containerView: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white
            //containerView.layer.borderWidth = 1
            //containerView.layer.borderColor = UIColor.black.cgColor
            containerView.translatesAutoresizingMaskIntoConstraints = false
            return containerView
        }()
        
        
        toView.addSubview(containerView)
        

        containerView.topAnchor.constraint(equalTo: underneathAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: toView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: toView.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: toView.heightAnchor, multiplier: (1/numberOfContainers)).isActive = true
        
        return containerView
    }
    
    
    func createActionBar(forContainer: UIView, leftItem: UIView, rightButton: UIButton, topAnchor: NSLayoutYAxisAnchor, height: CGFloat, subtractFromButton: CGFloat, spacingBetweenTitle: CGFloat) -> UIView {
        let bar = UIView()
        //bar.backgroundColor = UIColor.red
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor.white
        bar.addSubview(leftItem)
        bar.addSubview(rightButton)
        forContainer.addSubview(bar)
        
        bar.topAnchor.constraint(equalTo: topAnchor, constant: spacingBetweenTitle).isActive = true
        bar.heightAnchor.constraint(equalToConstant: height).isActive = true
        bar.leftAnchor.constraint(equalTo: forContainer.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: forContainer.rightAnchor).isActive = true

        leftItem.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
        leftItem.leftAnchor.constraint(equalTo: bar.leftAnchor).isActive = true
        leftItem.heightAnchor.constraint(equalTo: bar.heightAnchor).isActive = true
        leftItem.widthAnchor.constraint(equalTo: bar.widthAnchor, multiplier: (2/3)*0.95).isActive = true

        rightButton.rightAnchor.constraint(equalTo: bar.rightAnchor).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
        rightButton.heightAnchor.constraint(equalTo: bar.heightAnchor, constant: -7 + subtractFromButton).isActive = true
        rightButton.widthAnchor.constraint(equalTo: bar.widthAnchor, multiplier: (1/3)*0.95).isActive = true
        
        return bar
    }
    
    func setupAccountView(accountView: UIView) {
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Account"
            label.textColor = UIColor.orange
            label.font = UIFont(name: label.font.fontName, size: 23)
            label.textAlignment = .left
            return label
        }()
        
        let emailLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Email adfskjdsafmdsjafkldadkjsf"
            label.textColor = UIColor.black
            label.font = UIFont(name: label.font.fontName, size: 14)
            label.textAlignment = .left
            return label
        }()
        
        let changeEmailButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(r: 112, g: 47, b: 139)
            button.setTitle("Change", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            //button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
            return button
        }()
        
        let passwordLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Password"
            label.textColor = UIColor.black
            label.font = UIFont(name: label.font.fontName, size: 14)
            label.textAlignment = .left
            return label
        }()
        
        let changePasswordButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(r: 112, g: 47, b: 139)
            button.setTitle("Change", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(handlePasswordButton), for: .touchUpInside)
            return button
        }()
        
        accountView.addSubview(title)
        
        title.topAnchor.constraint(equalTo: accountView.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: accountView.leftAnchor).isActive = true
        
        let emailBar = createActionBar(forContainer: accountView, leftItem: emailLabel, rightButton: changeEmailButton, topAnchor: title.bottomAnchor, height: 30, subtractFromButton: 0, spacingBetweenTitle: 10)
        
        let passwordBar = createActionBar(forContainer: accountView, leftItem: passwordLabel, rightButton: changePasswordButton, topAnchor: emailBar.bottomAnchor, height: 30, subtractFromButton: 0, spacingBetweenTitle: 0)
    }
    
    @objc func handlePasswordButton(){
        self.navigationController?.pushViewController(ChangePasswordController(), animated: true)
    }
    
    func setupSignatureView(signatureView: UIView) {
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Signature"
            label.textColor = UIColor.orange
            label.font = UIFont(name: label.font.fontName, size: 23)
            label.textAlignment = .left
            return label
        }()
    
        let signatureImageView: UIImageView = {
            let theImageView = UIImageView()
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            theImageView.image = UIImage.init(named: "documentPlus.png")
            return theImageView
        }()
        
        let changeSignatureButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(r: 112, g: 47, b: 139)
            button.setTitle("Change", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(handleSignatureButton), for: .touchUpInside)
            return button
        }()
        

        
        signatureView.addSubview(title)
        
        title.topAnchor.constraint(equalTo: signatureView.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: signatureView.leftAnchor).isActive = true
        
        let signatureBar = createActionBar(forContainer: signatureView, leftItem: signatureImageView, rightButton: changeSignatureButton, topAnchor: title.bottomAnchor, height: 60, subtractFromButton: -28, spacingBetweenTitle: 10)

    }
    
    @objc func handleSignatureButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignatureViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setupDocumentsView(documentsView: UIView) {
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Documents"
            label.textColor = UIColor.orange
            label.font = UIFont(name: label.font.fontName, size: 23)
            label.textAlignment = .left
            return label
        }()
        
        let changeDocumentButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(r: 112, g: 47, b: 139)
            button.setTitle("Change", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(handleChangeDocument), for: .touchUpInside)
            return button
        }()
        
        
        documentsView.addSubview(title)
        
        title.topAnchor.constraint(equalTo: documentsView.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: documentsView.leftAnchor).isActive = true
        
        documentsView.addSubview(changeDocumentButton)
        changeDocumentButton.leftAnchor.constraint(equalTo: documentsView.leftAnchor).isActive = true
        changeDocumentButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        changeDocumentButton.widthAnchor.constraint(equalTo: documentsView.widthAnchor).isActive = true
        changeDocumentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func handleChangeDocument(){
        self.navigationController?.pushViewController(UploadImagesController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }


}
