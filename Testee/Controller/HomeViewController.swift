//
//  HomeViewController.swift
//  Testee
//
//  Created by Mental ModelsThree on 3/7/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) } // get hour only from Date
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

class HomeViewController: UIViewController {
    
    var shapeLayer: CAShapeLayer! // main circle path
    var pulsatingLayer: CAShapeLayer! // pulsating circle path
    
    var time = Timer()
    var handle: AuthStateDidChangeListenerHandle?
    
//    private func setupNotificationObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
//    }
//
//    @objc private func handleEnterForeground() {
//        animatePulsatingLayer()
//    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 15
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        return layer
    }
    
    private func setupCircleLayers() {
        // the pulsating circle
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor(r: 135, g: 56, b: 92))
        pulsatingLayer.opacity = 0.5
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        // the inner circle
        // UIColor(r: 244, g: 134, b: 161
        let trackLayer = createCircleShapeLayer(strokeColor: UIColor(r: 244, g: 134, b: 161)
, fillColor: UIColor(r: 21, g: 22, b: 33))
        trackLayer.opacity = 0.5
        
        view.layer.addSublayer(trackLayer)
        
        // rgb(244, 166, 161)
        // the progress circle
        // UIColor(r: 186, g: 29, b: 101
        shapeLayer = createCircleShapeLayer(strokeColor: UIColor(r: 186, g: 29, b: 101)
, fillColor: .clear)
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        //shapeLayer.opacity = 0.5
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.35
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
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
        welcome.text = "Hello"
        welcome.textColor = UIColor.white
        welcome.font = UIFont(name: welcome.font.fontName, size: 40)
        welcome.textAlignment = .center
        return welcome
    }()
    
    let daysLabel: UILabel = {
        let days = UILabel()
        days.translatesAutoresizingMaskIntoConstraints = false
        days.text = "0"
        days.textColor = UIColor.white
        days.font = UIFont(name: days.font.fontName, size: 70)
        days.textAlignment = .center
        return days
    }()
    
    let dLabel: UILabel = {
        let d = UILabel()
        d.translatesAutoresizingMaskIntoConstraints = false
        d.text = "Days"
        d.textColor = UIColor.white
        d.font = UIFont(name: d.font.fontName, size: 30)
        d.textAlignment = .center
        return d
    }()
    
    let untilLabel: UILabel = {
        let until = UILabel()
        until.translatesAutoresizingMaskIntoConstraints = false
        until.text = "Next Appointment In"
        until.textColor = UIColor.white
        until.font = UIFont(name: "Avenir", size: 15)
        until.textAlignment = .center
        return until
    }()
    
    let appointmentLabel : UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.text = ""
        date.textColor = UIColor.white
        date.font = UIFont(name: "Avenir", size: 40)
        date.textAlignment = .center
        
        return date
    }()
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            //print(logoutError)
        }
        //loginController.messagesController = self
        let loginController = LoginController()
        //dismiss(animated: false, completion: nil)
        present(loginController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNavigationBar()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "night.png")!)
        //circle stuff
        //setupNotificationObservers()
        setupCircleLayers()
        
        //let shaperLayer = CAShapeLayer()
        //let center = view.center
        //let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        //shaperLayer.path = circularPath.cgPath
        //shaperLayer.fillColor = UIColor.clear.cgColor

        //shaperLayer.fillColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.5).cgColor
            //UIColor.clear.cgColor
        //shaperLayer.strokeColor = UIColor(red:244/255, green:166/255, blue:161/255, alpha:1.0).cgColor
        //shaperLayer.lineWidth = 10
        //shaperLayer.lineCap = kCALineCapRound
        
        //view.layer.addSublayer(shaperLayer)
        
        //shapeLayer.path = circularPath.cgPath
        //shapeLayer.strokeColor = UIColor.red.cgColor
        //shapeLayer.lineWidth = 10
        //shapeLayer.fillColor = UIColor.clear.cgColor
        //shapeLayer.lineCap = kCALineCapRound
        
        //shapeLayer.strokeEnd = 0
        
        //view.layer.addSublayer(shapeLayer)
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(inputsContainerView)
        setupInputsContainerView()
        view.bringSubview(toFront: daysLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePulsatingLayer()
    }
    
    @objc private func handleTap(days: Int){
        print("Attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        if days <= 1 {
            basicAnimation.toValue = 1
        }
        else if days == 2 {
            basicAnimation.toValue = 0.75
        }
        else if days == 3 {
            basicAnimation.toValue = 0.50
        }
        
        else if days >= 4 {
            basicAnimation.toValue = 0.25
        }
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //called every time the view appears
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let calendar = NSCalendar.current
        let firstDate = Date()
        let secondDate = Date().tomorrow
        
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        print(components.day as Any)
        
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
                print(firstName + " " + lastName)
                name = firstName //+ " " + lastName
                self.welcomeLabel.numberOfLines = 2
                self.welcomeLabel.text = "Hello " + name
                
                guard let dateEpoch = dict["nextAppointment"] as? Int else {
                    return
                }
                let today: Int = Int(Date().timeIntervalSince1970)
                let diff = Int((dateEpoch - today)/86400)
                let dayDisplay = Date(timeIntervalSince1970: Double(dateEpoch))
                var date = "0"
                if (diff < 0) {
                    date = "0"
                }
                else{
                    date = "\(diff+1)"
                }
                print(diff)
                if date == "1" {
                    self.dLabel.text = "day"
                }
                else{
                    self.dLabel.text = "days"
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateFormatter.locale = Locale(identifier: "en_US")
                
                self.appointmentLabel.text = dateFormatter.string(from: dayDisplay)
                self.daysLabel.text = date
                
                
                self.handleTap(days: diff+1)
            }
        })
        
        //HOW THE DATES ARE HANDLED
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNames(){
        //return name
    }
    
    /*func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 40, width: screenSize.width, height: 300))
        let navItem = UINavigationItem(title: "")
        /*let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(handleLogout))
        let messagesItem = UIBarButtonItem(title: "Messages", style: .plain, target: nil, action: #selector(handleMessages))
        let profileItem = UIBarButtonItem(title: "Profile", style: .plain, target: nil, action: #selector(handleProfile))
        navItem.rightBarButtonItem = logoutItem
        navItem.leftBarButtonItem = messagesItem*/
        
        let logoutImage = UIImage(named: "logoutBtn.png")!
        let messagesImage = UIImage(named: "chatBtn.png")!
        let profileImage = UIImage(named: "profileBtn.png")!
        let dateImage = UIImage(named: "dateBtn.png")!
        let homeImage = UIImage(named: "homeBtn.png")!
        
        let logoutButton = UIBarButtonItem(image: logoutImage,  style: .plain, target: nil, action: #selector(handleLogout))
        let messagesButton = UIBarButtonItem(image: messagesImage,  style: .plain, target: nil, action: #selector(handleMessages))
        let dateButton = UIBarButtonItem(image: dateImage,  style: .plain, target: nil, action: #selector(handleDate))
        let profileButton = UIBarButtonItem(image: profileImage,  style: .plain, target: nil, action: #selector(handleProfile))
        let homeButton = UIBarButtonItem(image: homeImage,  style: .plain, target: nil, action: nil)
        
        navItem.rightBarButtonItems = [logoutButton, messagesButton, homeButton]
        navItem.leftBarButtonItems = [profileButton, dateButton]
        
        //navItem.setRightBarButtonItems(buttons, animated: true)
        navBar.setItems([navItem], animated: false)
        navBar.tintColor = UIColor(r: 145, g: 0, b: 123)
        self.view.addSubview(navBar)
    }*/
    
    @objc func handleMessages() {
        //dismiss(animated: true, completion: nil)
        let megController = MessagesController();
        present(megController, animated: true, completion: nil)
    }
    
    @objc func handleDate() {
        let dateController = DateViewController()
        present(dateController, animated: true, completion: nil)
    }
    
    @objc func handleProfile() {
        let proController = ProfileController();
        present(proController, animated: true, completion: nil)
    }
    
    
    
    func setupInputsContainerView(){
        //need  x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        inputsContainerView.addSubview(welcomeLabel)
        welcomeLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 10).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        inputsContainerView.addSubview(untilLabel)
        untilLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        untilLabel.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: 50).isActive = true
        untilLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        untilLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputsContainerView.addSubview(daysLabel)
        daysLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        //daysLabel.topAnchor.constraint(equalTo: untilLabel.topAnchor, constant: 110).isActive = true
        daysLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        daysLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        daysLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputsContainerView.addSubview(dLabel)
        dLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        dLabel.topAnchor.constraint(equalTo: daysLabel.topAnchor, constant: 50).isActive = true
        dLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        dLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputsContainerView.addSubview(appointmentLabel)
        appointmentLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true
        //appointmentLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 160).isActive = true
        appointmentLabel.topAnchor.constraint(equalTo: dLabel.bottomAnchor, constant: 100).isActive = true
        appointmentLabel.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        appointmentLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
