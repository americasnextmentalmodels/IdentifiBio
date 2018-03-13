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
        createBottomView()
    }
    
    func createBottomView() {
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
