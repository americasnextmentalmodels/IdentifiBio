//
//  ChatLogController.swift
//  Testee
//
//  Created by Mental ModelsTwo on 2/8/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var user: User? {
        didSet {
            navigationItem.title = user?.firstName
            
            observeMessages()
        }
    }
    
    var currentUserReferralCode = ""
    var messages = [Message]()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    
    
    
    let anotherID = "thisIsAnotherID"
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: anotherID)
        //collectionView?.reloadData()
        setupInputComponents()

        setupKeyBoardObservers()
        
        
    }
    
    func setupKeyBoardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rect = CGRect(x: 0, y: 0, width: 300, height: 6000)
        self.collectionView?.setContentOffset(CGPoint(x: 0, y: (collectionView?.collectionViewLayout.collectionViewContentSize.height)!), animated: false)
        self.collectionView?.backgroundColor = UIColor.red
        
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 200, right: 0)
        //scrollToBottom()
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        //scrollToBottom()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: anotherID, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setUpCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32


        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: Message){
        if message.fromId == Auth.auth().currentUser?.uid {
            //The message is from us
            //anchor this to the right
            
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else{
            //The message is from the person chatting with us
            //anchor this to the left
            
            cell.bubbleView.backgroundColor = ChatMessageCell.grayColor
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true

        }
        
        
//        if message.fromId == message.chatPartnerId() {
//            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
//            cell.textView.textColor = UIColor.white
//        }
//        else{
//            // gray
//            cell.bubbleView.backgroundColor = ChatMessageCell.grayColor
//            cell.textView.textColor = UIColor.black
//
//            cell.bubbleViewRightAnchor?.isActive = false
//            cell.bubbleViewLeftAnchor?.isActive = true
//        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let newText = messages[indexPath.item].text {
            height = estimateFrameForText(text: newText).height + 20
        }
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    
    fileprivate func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        //Save our referral code into a global variable
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //self.currentUserReferralCode = (snapshot.value as? String)!
            
        })
        
        
        
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: {(snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: {(snapshot) in
                //print("attempting to observe all messages")
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else{
                    return
                }
//                for item in dictionary {
//                    print(type(of: item.key))
//                        print(type(of: item.value))
//                }
                let message = Message(dictionary: dictionary)
                
                if message.chatPartnerId() == self.user?.uid {
                    self.messages.append(message)
//                    print("message array: ")
//                    print(self.messages)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                        
                        //self.scrollToLastItem()
                    
                    })
                    
                }
                
//                let lastItemIndex = IndexPath(index: self.messages.count - 1)
//                self.collectionView?.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
                
                //potential of crashing if keys don't match
                //message.toId = dictionary["toId"] as? String
                //message.fromId = dictionary["fromId"] as? String
                //message.text = dictionary["text"] as? String
                //message.timestamp = dictionary["timestamp"] as? NSNumber
                
//                if message.chatPartnerId() == self.user?.uid {
//                    self.messages.append(message)
                
            }, withCancel: nil)
                
                //self.collectionView?.reloadData()
                
                
                
                //print(message.text)
                
                
            }, withCancel: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
//    func viewScrollButton() {
//        let lastItem = collectionView(, numberOfRowsInSection: 0) - 1
//        let indexPath: NSIndexPath = NSIndexPath.init(item: lastItem, section: 0)
//        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: false)
//    }
    
    func scrollToBottom() {
        self.collectionView?.alwaysBounceVertical = false
        let rect = CGRect(x: 0, y: 0, width: 300, height: 10000)
        self.collectionView?.scrollRectToVisible(rect, animated: false)
        self.collectionView?.alwaysBounceVertical = true
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.setTitleColor(UIColor.purple, for: .normal)
    
        containerView.addSubview(inputTextField)
        //containerView.backgroundColor = UIColor.cyan
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        // may need to reload data
        //collectionView?.reloadData()
    }
    
    
    @objc func handleSend() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //uid not available so do nothing
            return
        }
        Database.database().reference().child("users").child(uid).child("referralCode").observeSingleEvent(of: .value, with: { (snapshot) in
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            let toId = self.user!.uid!
            let fromId = Auth.auth().currentUser!.uid
            let currentUserReferralCode = snapshot.value as? String
            
            //The 0 means, 0 second + the number of seconds since 1970
            //I used Date() instead of NSDate() because
            //NSDate wasn't working
            //^Nick
            let timestamp: Int = Int(Date().timeIntervalSince1970)
            let values = ["text": self.inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp, "referralCode": currentUserReferralCode] as [String : Any]
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                self.inputTextField.text = nil
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                let messageId = childRef.key
                userMessagesRef.updateChildValues([messageId: 1])
                
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
                recipientUserMessagesRef.updateChildValues([messageId: 1])
                
            }
        })
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        
        return true
    }
    
        

}
