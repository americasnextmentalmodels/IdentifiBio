//
//  UpdatedProfileView.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/13/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class UpdatedProfileView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let emailLabel = UILabel()
    let nameLabel = UILabel()
    let theImageView = UIImageView()
    let profilePictureView = UIImageView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        let bottomView = createBottomView()
        drawBottomBorder(inView: bottomView)
        let circleView = drawAndCreateImageView(viewToAlignTo: bottomView)
        let inputsViewContainer = drawAndCreateMainInputsContainer(inView: bottomView, circleView: circleView)
        let numberOfContainersForAutomaticSizing: CGFloat = 3
        let accountView = addContainerToView(toView: inputsViewContainer, underneathAnchor: inputsViewContainer.topAnchor, numberOfContainers: numberOfContainersForAutomaticSizing)
        setupAccountView(accountView: accountView, emailLabel: emailLabel)
        let signatureView = addContainerToView(toView: inputsViewContainer, underneathAnchor: accountView.bottomAnchor, numberOfContainers: numberOfContainersForAutomaticSizing)
        setupSignatureView(signatureView: signatureView, theImageView: theImageView)
        let documentsView = addContainerToView(toView: inputsViewContainer, underneathAnchor: signatureView.bottomAnchor, numberOfContainers: numberOfContainersForAutomaticSizing)
        setupDocumentsView(documentsView: documentsView)
        drawNameLabel(view: circleView, nameLabel: nameLabel)
        drawSettingsButton()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadImageFromFirebase(imageView: profilePictureView)
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
        
        let size: CGFloat = 110
        let height: CGFloat = size
        let width: CGFloat = size
        
            
            profilePictureView.translatesAutoresizingMaskIntoConstraints = false
            profilePictureView.image = UIImage.init(named: "profileNew.png")
            
        
            profilePictureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage)))
            profilePictureView.isUserInteractionEnabled = true
            
            
            
            //Using height/2 to assure it still looks like a circle
            //even if we increase the height and width
            profilePictureView.layer.cornerRadius = CGFloat(height/2)
            profilePictureView.layer.masksToBounds = true
            profilePictureView.layer.borderWidth = 5
            profilePictureView.layer.borderColor = UIColor.orange.cgColor
        
        view.addSubview(profilePictureView)
        
        profilePictureView.centerXAnchor.constraint(equalTo: viewToAlignTo.centerXAnchor).isActive = true
        profilePictureView.centerYAnchor.constraint(equalTo: viewToAlignTo.topAnchor).isActive = true
        profilePictureView.widthAnchor.constraint(equalToConstant: width).isActive = true
        profilePictureView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return profilePictureView

    }
    
    @objc func handleSelectImage() {
        print("handl sell called")
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
//            print("Previous Image: ")
//            print(profilePictureView.image)
//            profilePictureView.image = UIImage.init(named: "documentPlus.png")
//            print("AFTER CHANGE: ", terminator: "")
//            print(profilePictureView.image)
//            //uploadViews[0].imageView.image = selectedImage
//            //uploadAndDisplayImage(imageview: )
            
            uploadImageToFirebaseAndDisplayNewImage(uploadImage: selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImageToFirebaseAndDisplayNewImage(uploadImage: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("UID safeguard, UID is not available.")
            return
        }
        
        let storageRef = Storage.storage().reference()
        // Data in memory
        var data = Data()
        data = UIImagePNGRepresentation(uploadImage)!
        
        // Create a reference to the file you want to upload
        let databaseSaveRef = storageRef.child("profile/" + uid + ".png")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = databaseSaveRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                //Handle error here if save failure (also add error handling in guard uid)
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("Upload progress: " + String(percentComplete))
        }
        
       
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    self.uploadImageToFirebaseAndDisplayNewImage(uploadImage: uploadImage)
                    break
                }
            }
        }
        
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("Upload done!")
            self.profilePictureView.image = uploadImage
    
        }
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
    
    func drawNameLabel(view: UIView, nameLabel: UILabel){
        
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = "Yuda"
            nameLabel.textColor = UIColor.white
            nameLabel.font = UIFont(name: nameLabel.font.fontName, size: 30)
            nameLabel.textAlignment = .center
        
    
        
        self.view.addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -35).isActive = true
        //title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        //title.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        //title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
    }
    
    func drawSettingsButton(){
        let imageView: UIImageView = {
            let theImageView = UIImageView()
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            theImageView.image = UIImage.init(named: "geary_settings_icon.png")
            theImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAccountButton)))
            theImageView.isUserInteractionEnabled = true
            
            return theImageView
        }()
        
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
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
    
    func setupAccountView(accountView: UIView, emailLabel: UILabel) {
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Account"
            label.textColor = UIColor.orange
            label.font = UIFont(name: label.font.fontName, size: 23)
            label.textAlignment = .left
            return label
        }()

        
            emailLabel.translatesAutoresizingMaskIntoConstraints = false
            emailLabel.text = "Email: "
            emailLabel.textColor = UIColor.black
            emailLabel.font = UIFont(name: emailLabel.font.fontName, size: 14)
            emailLabel.textAlignment = .left
        
        

        let changeEmailButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(r: 112, g: 47, b: 139)
            button.setTitle("Change", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(handleEmailButton), for: .touchUpInside)
            return button
        }()

        let passwordLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Password: ********"
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
    
    @objc func handleEmailButton(){
        self.navigationController?.pushViewController(ChangeEmailController(), animated: true)
    }

    func setupSignatureView(signatureView: UIView, theImageView: UIImageView) {
        let title: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Signature"
            label.textColor = UIColor.orange
            label.font = UIFont(name: label.font.fontName, size: 23)
            label.textAlignment = .left
            return label
        }()

        
        
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            theImageView.image = UIImage.init(named: "documentPlus.png")
        

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
        
        let signatureBar = createActionBar(forContainer: signatureView, leftItem: theImageView, rightButton: changeSignatureButton, topAnchor: title.bottomAnchor, height: 60, subtractFromButton: -28, spacingBetweenTitle: 10)

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
    
    override func viewWillAppear(_ animated: Bool) {
        //called every time the view appears
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
                self.nameLabel.text = name
                self.emailLabel.text = "Email: " + email
                
            }
        })
        downloadSignature()
    }
    
    func downloadSignature(){
        guard let uid = Auth.auth().currentUser?.uid else {
            print("UID safeguard, UID is not available.")
            return
        }
        
        let ref = Storage.storage().reference().child("signatures/" + uid + ".png")
        
        //10 * 1024 * 1024 bytes = 10 megabytes
        
        let downloadTask = ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Download failure, filesize may be too big or another issue.")
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                print("Download should now be complete and we can load in the image.")
                self.theImageView.image = UIImage(data: data!)
                self.theImageView.contentMode = .scaleAspectFit
            }
        }
        
        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("Current download progress: " + String(percentComplete))
            
        }
        
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
            print("Download complete")
        }
    }

    func downloadImageFromFirebase(imageView: UIImageView) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("UID safeguard, UID is not available.")
            return
        }
        
        let ref = Storage.storage().reference().child("profile/" + uid + ".png")
        
        //10 * 1024 * 1024 bytes = 10 megabytes
        
        let downloadTask = ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Download failure, filesize may be too big or another issue.")
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                print("Download should now be complete and we can load in the image.")
                imageView.image = UIImage(data: data!)
            }
        }
        
        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("Current download progress: " + String(percentComplete))
            //self.progressLabel.text! = String(format: "%.2f", arguments: percentComplete)
            if !percentComplete.isNaN {
                //self.progressLabel.text = String(Int(percentComplete)) + "%"
            } else {
                //self.progressLabel.text = "0%"
            }
            
        }
        
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
            print("Download complete")
            //self.progressLabel.text = ""
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

}
