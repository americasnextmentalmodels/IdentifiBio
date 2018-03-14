//  ChangePasswordController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 3/8/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase


class UploadImagesController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //let purple = UIColor(r: 247, g: 247, b: 247)
    
    struct UploadImageData {
        var anchor: NSLayoutYAxisAnchor
        var imageView: UIImageView
        var header: UILabel
        var container: UIView
    }
    var currentlyTappedImageView: UIImageView!
    var uploadViews = [UploadImageData]()
    
    
//    createViews() {
//        for view in listOfObjects {
//            let header = createUploadHeader()
//            let imageView = createImageView()
//            var subview: UIView
//            if first{
//                subview = createContainer(topAnchor: self.view, imageView: image, header: header)
//        }
//        else {
//            subview = createContainer(topAnchor: self.view, imageView: image, header: header)
//        }
//            view.addSubview(subview)
//        }
//        createContainer(Anchor){
//        -set constraints of container and all views in container
//    }

    func createNewUploadImageDataObject(anchor: NSLayoutYAxisAnchor, number: Int) -> UploadImageData {
        let header: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Document #" + String(number)
            label.numberOfLines = 2
            label.textColor = UIColor.purple
            label.font = UIFont(name: label.font.fontName, size: 20)
            label.textAlignment = .center
            return label
        }()
        
        let imageView: UIImageView = {
            let theImageView = UIImageView()
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            
            theImageView.image = UIImage.init(named: "newDocumentPurple.png")
            
//            theImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage)))
//            theImageView.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSelectImage(tapGestureRecognizer:)))
            theImageView.isUserInteractionEnabled = true
            theImageView.addGestureRecognizer((tapGestureRecognizer))
            theImageView.layer.shadowColor = UIColor.lightGray.cgColor
            theImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
            theImageView.layer.shadowOpacity = 0.8
            theImageView.layer.shadowRadius = 3
            
            
            return theImageView
        }()
        
        let container: UIView = {
            let container = UIView()
            container.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
            container.translatesAutoresizingMaskIntoConstraints = false
            container.layer.masksToBounds = true
            return container
        }()
        
        return UploadImageData(anchor: anchor, imageView: imageView, header: header, container: container)
    }
    
    @objc func handleSelectImage(tapGestureRecognizer: UITapGestureRecognizer){
        //set global varible to currently selected image view so we can use this in the
        //image picker function (it takes the wrong arguments)
        currentlyTappedImageView = tapGestureRecognizer.view as! UIImageView
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func createUploadViews() {
        var currentAnchor = scrollView.topAnchor
            for x in 1...5 {
                let data = createNewUploadImageDataObject(anchor: currentAnchor, number: x)
                configureUploadViewContainer(anchor: currentAnchor, header: data.header, imageView: data.imageView, container: data.container)
                uploadViews.append(UploadImageData(anchor: currentAnchor, imageView: data.imageView, header: data.header, container: data.container))
                //update our new anchor to the new container view we just created
                currentAnchor = data.container.bottomAnchor
            }
        print(uploadViews)
       

    }
    
    func configureUploadViewContainer(anchor: NSLayoutYAxisAnchor, header: UILabel, imageView: UIImageView, container: UIView) {
        print("createUploadViewContainer called")

        container.addSubview(header)
        container.addSubview(imageView)
        scrollView.addSubview(container)
        
        container.topAnchor.constraint(equalTo: anchor, constant: 50).isActive = true
        container.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -100).isActive = true
        container.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        header.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        header.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: 8.5 * 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 11 * 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20).isActive = true
  
        view.addSubview(scrollView)
        
    }
    
    
    let uploadItemHeaderLabel: UILabel = {
        let welcome = UILabel()
        welcome.translatesAutoresizingMaskIntoConstraints = false
        welcome.text = "Please take/select a photograph of your documentation."
        welcome.numberOfLines = 2
        welcome.textColor = UIColor(r: 230, g: 230, b: 230)
        welcome.font = UIFont(name: welcome.font.fontName, size: 20)
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
    
//    let imageView: UIImageView = {
//        let theImageView = UIImageView()
//        theImageView.translatesAutoresizingMaskIntoConstraints = false
//        return theImageView
//    }()
    
    let progressLabel: UILabel = {
        let progress = UILabel()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.textColor = UIColor(r: 230, g: 230, b: 230)
        progress.font = UIFont(name: progress.font.fontName, size: 15)
        progress.textAlignment = .center
        progress.lineBreakMode = .byWordWrapping
        progress.numberOfLines = 3
        
        return progress
    }()
    
//    let inputsContainerView: UIView = {
//        let inputsContainerView = UIView()
//
//        inputsContainerView.backgroundColor = UIColor(r: 247, g: 247, b: 247)
//        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
//        //inputsContainerView.layer.cornerRadius = 5
//        inputsContainerView.layer.masksToBounds = true
//        return inputsContainerView
//    }()
    
    let TakePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 247, g: 247, b: 247)
        button.backgroundColor = UIColor.purple
        button.setTitle("Take Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitleColor(UIColor(r: 145, g: 0, b: 123), for: .normal)
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
        return button
    }()
    
    let SelectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 247, g: 247, b: 247)
        button.backgroundColor = UIColor.purple
        button.setTitle("Select Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitleColor(UIColor(r: 145, g: 0, b: 123), for: .normal)
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func takePhoto() {
        
    }
    
//    @objc func selectPhoto() {
//        let picker = UIImagePickerController()
//
//        picker.delegate = self
//        picker.allowsEditing = true
//
//        present(picker, animated: true, completion: nil)
//    }
    
    @objc func selectPhoto(imageViewSource: UIImageView) {
        //this is the version used for mutliple uploads
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
            var selectedImageFromPicker: UIImage?
    
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                selectedImageFromPicker = editedImage
            } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                selectedImageFromPicker = originalImage
            }
    
            if let selectedImage = selectedImageFromPicker {
                print("Selected Image: ")
                print(selectedImage)
                currentlyTappedImageView.image = selectedImage
                uploadImageToFirebaseAndDisplayNewImage(uploadImage: selectedImage)
                //uploadViews[0].imageView.image = selectedImage
                //uploadAndDisplayImage(imageview: )
            }
    
            dismiss(animated: true, completion: nil)
    
        }
  
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//
//            selectedImageFromPicker = originalImage
//        }
//
//        if let selectedImage = selectedImageFromPicker {
//            uploadImageToFirebaseAndDisplayNewImage(signatureImage: selectedImage)
//        }
//
//        dismiss(animated: true, completion: nil)
//
//    }
    
    //func uploadImageToFirebaseAndDisplayNewImage(signatureImage: UIImage) {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("UID safeguard, UID is not available.")
//            return
//        }
//
//        let storageRef = Storage.storage().reference()
//        // Data in memory
//        var data = Data()
//        data = UIImagePNGRepresentation(signatureImage)!
//
//        // Create a reference to the file you want to upload
//        let databaseSaveRef = storageRef.child("documents/" + uid + ".png")
//
//        // Upload the file to the path "images/rivers.jpg"
//        let uploadTask = databaseSaveRef.putData(data, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                //Handle error here if save failure (also add error handling in guard uid)
//                return
//            }
//            // Metadata contains file metadata such as size, content-type, and download URL.
//            let downloadURL = metadata.downloadURL
//        }
//
//        uploadTask.observe(.progress) { snapshot in
//            // Upload reported progress
//            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                / Double(snapshot.progress!.totalUnitCount)
//            print("Upload progress: " + String(percentComplete))
//        }
//
//        uploadTask.observe(.success) { snapshot in
//            // Upload completed successfully
//            print("Upload done!")
//            self.imageView.image = signatureImage
//        }
 //   }
    
    func uploadImageToFirebaseAndDisplayNewImage(uploadImage: UIImage) {
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("UID safeguard, UID is not available.")
                    return
                }
        
                let storageRef = Storage.storage().reference()
                // Data in memory
                var data = Data()
                data = UIImagePNGRepresentation(uploadImage)!
        
                var identifier = -1
        
                for index in 0...uploadViews.count-1{
                    if uploadViews[index].imageView == self.currentlyTappedImageView{
                        identifier = index
                    }
                }
                // Create a reference to the file you want to upload
                let databaseSaveRef = storageRef.child("documents/" + uid + "_" + String(identifier) + ".png")
        
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
        
                uploadTask.observe(.success) { snapshot in
                    // Upload completed successfully
                    print("Upload done!")
                    self.currentlyTappedImageView.image = uploadImage
                }
    }
    
    func downloadImageFromFirebase(identifier: String, imageView: UIImageView) {
    
            guard let uid = Auth.auth().currentUser?.uid else {
                print("UID safeguard, UID is not available.")
                return
            }
    
            let ref = Storage.storage().reference().child("documents/" + uid + "_" + identifier + ".png")
    
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
                    self.progressLabel.text = String(Int(percentComplete)) + "%"
                } else {
                    self.progressLabel.text = "0%"
                }
    
            }
    
            downloadTask.observe(.success) { snapshot in
                // Download completed successfully
                print("Download complete")
                self.progressLabel.text = ""
            }
     }
    
 //   func downloadImageFromFirebase() {
        
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("UID safeguard, UID is not available.")
//            return
//        }
//
//        let ref = Storage.storage().reference().child("documents/" + uid + ".png")
//
//        //10 * 1024 * 1024 bytes = 10 megabytes
//
//        let downloadTask = ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if let error = error {
//                // Uh-oh, an error occurred!
//                print("Download failure, filesize may be too big or another issue.")
//                print(error)
//            } else {
//                // Data for "images/island.jpg" is returned
//                print("Download should now be complete and we can load in the image.")
//                self.imageView.image = UIImage(data: data!)
//            }
//        }
//
//        downloadTask.observe(.progress) { snapshot in
//            // Download reported progress
//            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                / Double(snapshot.progress!.totalUnitCount)
//            print("Current download progress: " + String(percentComplete))
//            //self.progressLabel.text! = String(format: "%.2f", arguments: percentComplete)
//            if !percentComplete.isNaN {
//                self.progressLabel.text = String(Int(percentComplete)) + "%"
//            } else {
//                self.progressLabel.text = "0%"
//            }
//
//        }
//
//        downloadTask.observe(.success) { snapshot in
//            // Download completed successfully
//            print("Download complete")
//            self.progressLabel.text = ""
//        }
   // }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func comparePasswords(pw1: String, pw2: String) -> Bool{
        return pw1 == pw2
    }
    
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
   
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        createUploadViews()
        
        
        //create scroll view so we can scroll stuff that is
        //not visible in the screen
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 2000)
      

        
        self.title = "Upload Documents"
        view.backgroundColor = UIColor(r: 247, g: 247, b: 247)
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        
//        view.addSubview(inputsContainerView)
//        view.addSubview(TakePhotoButton)
//        view.addSubview(SelectPhotoButton)
//        view.addSubview(imageView)
        
        //view.addSubview(backgroundImage)
        
        
//        setupInputsContainerView()
//        setupTakePhotoButton()
//        setupSelectPhotoButton()
//        setupImageView()
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.purple
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for index in 0...uploadViews.count-1{
            downloadImageFromFirebase(identifier: String(index), imageView: uploadViews[index].imageView)
        }
//        createUploadViews()
        //downloadImageFromFirebase()
    }
    
    func setupInputsContainerView(){
        //need  x, y, width, height constraints
        //        print(navigationController?.navigationBar.topAnchor)
        //        var anch = (navigationController?.navigationBar.topAnchor)!
        
//        inputsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.height)!).isActive = true
//        //        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        //        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
//        inputsContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: (self.navigationController?.navigationBar.frame.size.height)!).isActive = true

        
//        inputsContainerView.addSubview(uploadItemHeaderLabel)
//        uploadItemHeaderLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
//        uploadItemHeaderLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 0).isActive = true
//        uploadItemHeaderLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        uploadItemHeaderLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
//
//
//        inputsContainerView.addSubview(errorLabel)
//        errorLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
//        errorLabel.topAnchor.constraint(equalTo: TakePhotoButton.bottomAnchor, constant: 15).isActive = true
//        errorLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        errorLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        inputsContainerView.addSubview(progressLabel)
//        progressLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
//        progressLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5).isActive = true
//        progressLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        progressLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    
    func setupSelectPhotoButton(){
//        //        SelectPhotoButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        //        inputsContainerView.addSubview(SelectPhotoButton)
//        SelectPhotoButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
//        SelectPhotoButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
//        SelectPhotoButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/3).isActive = true
//        SelectPhotoButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupTakePhotoButton(){
//        TakePhotoButton.leftAnchor.constraint(equalTo: SelectPhotoButton.rightAnchor, constant: 60).isActive = true
//        TakePhotoButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
//        TakePhotoButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/3).isActive = true
//        TakePhotoButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupImageView() {
//        imageView.widthAnchor.constraint(equalToConstant: 8.5 * 20).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 11 * 20).isActive = true
//        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
    }
    
    
    
    func setupLabel(){
//        uploadItemHeaderLabel.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}
