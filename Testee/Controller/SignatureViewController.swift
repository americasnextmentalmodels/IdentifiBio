//
//  SignatureViewController.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/9/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class SignatureViewController: UIViewController, YPSignatureDelegate {

    @IBOutlet var signatureView: YPDrawSignatureView!
    //var signatureView: YPDrawSignatureView!
    
    let inputsContainerView: UIView = {
        let inputsContainerView = UIView()
        
        inputsContainerView.backgroundColor = UIColor(white: 1, alpha : 0)
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        //inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
        return inputsContainerView
    }()
    
    let welcomeLabel: UILabel = {
        let welcome = UILabel()
        welcome.translatesAutoresizingMaskIntoConstraints = false
        welcome.text = "Please sign below"
        welcome.textColor = UIColor.orange
        welcome.font = UIFont(name: welcome.font.fontName, size: 14)
        welcome.textAlignment = .center
        return welcome
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.purple
        button.setTitle("Save & Finish", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        button.addTarget(self, action: #selector(saveFunc), for: .touchUpInside)
        
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.purple, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.purple.cgColor
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        button.addTarget(self, action: #selector(clearFunc), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 247, g: 247, b: 247)
        view.addSubview(inputsContainerView)
        view.addSubview(signatureView)
        setupSaveButton()
        
        signatureView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveFunc(){
        if let signatureImage = self.signatureView.getSignature(scale: 10) {
            
            // Saving signatureImage from the line above to the Photo Roll.
            // The first time you do this, the app asks for access to your pictures.
            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            uploadImage(signatureImage: signatureImage)
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
            self.signatureView.clear()
            //Make it go back to profile/account screen
            //dismiss(animated: true, completion: nil)
        }
    }
    
    func uploadImage(signatureImage: UIImage) {
        print("ui image: ", terminator: "")
        print(signatureImage)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //Handle error here if save failure (also add error handling in uploadTask below uid)
            return
        }

        //Eamon not able to load, trying to figure out why
        let storageRef = Storage.storage().reference()
        // Data in memory
        var data = Data()
        data = UIImagePNGRepresentation(signatureImage)!

        // Create a reference to the file you want to upload
        let databaseSaveRef = storageRef.child("signatures/" + uid + ".png")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = databaseSaveRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                //Handle error here if save failure (also add error handling in guard uid)
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
        }
        
        //Possible to monitor the progress using Firebase if time permits
        
    }
    @objc func clearFunc(){
        signatureView.clear()
    }
    
    func setupSaveButton() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 550).isActive = true
        
        inputsContainerView.addSubview(clearButton)
        //inputsContainerView.addSubview(backgroundImage)
        clearButton.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        clearButton.topAnchor.constraint(equalTo: signatureView.bottomAnchor, constant: 20).isActive = true
        clearButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/3).isActive = true
        clearButton.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/12).isActive = true
        clearButton.centerXAnchor.constraint(equalTo: signatureView.centerXAnchor).isActive = true
        
        inputsContainerView.addSubview(welcomeLabel)
        welcomeLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: signatureView.topAnchor, constant: -20).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        inputsContainerView.addSubview(saveButton)
        //inputsContainerView.addSubview(backgroundImage)
        saveButton.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 0).isActive = true
        saveButton.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        saveButton.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 20).isActive = true
        saveButton.widthAnchor.constraint(equalTo: clearButton.widthAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/12).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: signatureView.centerXAnchor).isActive = true
        
    }
    
    func didStart() {
        print("Started Drawing")
    }
    
    // didFinish() is called rigth after the last touch of a gesture is registered in the view.
    // Can be used to enabe scrolling in a scroll view if it has previous been disabled.
    func didFinish() {
        print("Finished Drawing")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
