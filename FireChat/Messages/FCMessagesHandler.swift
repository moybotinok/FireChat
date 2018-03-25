//
//  FCMessagesHandler.swift
//  FireChat
//
//  Created by Tatiana Bocharnikova on 25.03.2018.
//  Copyright © 2018 Tatiana Bocharnikova. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


protocol FCMessageRecievedDelegate: class {
    func messageRecieved(senderId: String, senderName: String, text: String)
    func mediaRecieved(senderId: String, senderName: String, url: String)
}


class FCMessagesHandler {
    
    static let sharedInstance = FCMessagesHandler()
    private init(){}
    
    weak var delegate: FCMessageRecievedDelegate?
    
    func sendMessage(senderID: String, senderName: String, text: String) {
        
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text]
        
        FCFirebaseDatabaseService.sharedInstance.messagesRef.childByAutoId().setValue(data)
        
    }
    
    func sendMediaMessage(senderId: String, senderName: String, url: String) {
        
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderId, Constants.SENDER_NAME: senderName, Constants.URL: url]
        FCFirebaseDatabaseService.sharedInstance.mediaMessagesRef.childByAutoId().setValue(data)
    }
    
    func sendMedia(image: Data?, video: URL?, senderId: String, senderName: String) {
        
        if let image = image {
            
            FCFirebaseDatabaseService.sharedInstance.imageStorageRef.child(senderId + "\(NSUUID().uuidString).jpg").putData(image, metadata: nil, completion: { [weak self] (storageMetadata, error) in
                
                if let error = error {
                    
                    print("ошибка загрузки \(error)")// обработать ошибку
                    
                } else {
                    
                    let url: String  = String(describing: (storageMetadata?.downloadURL())!)
                    
                    self?.sendMediaMessage(senderId: senderId, senderName: senderName, url: url)
                }
                
            })
            
        } else if let video = video {
            
            FCFirebaseDatabaseService.sharedInstance.videoStorageRef.child(senderId + "\(NSUUID().uuidString)").putFile(from: video, metadata: nil, completion: { [weak self] (storageMetadata, error) in
                
                if let error = error {
                    
                    print("ошибка загрузки \(error)")// обработать ошибку
                    
                } else {
                    
                    let url: String  = String(describing: (storageMetadata?.downloadURL())!)
                    
                    self?.sendMediaMessage(senderId: senderId, senderName: senderName, url: url)
                }
                
            })
            
        }
        
    }
    
    func observeMessages() {
        
        FCFirebaseDatabaseService.sharedInstance.messagesRef.observe(DataEventType.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let senderID = data[Constants.SENDER_ID] as? String,
                    let text = data[Constants.TEXT] as? String,
                    let senderName = data[Constants.SENDER_NAME] as? String {
                    
                    self?.delegate?.messageRecieved(senderId: senderID, senderName: senderName, text: text)
                }
                
            }
        }
    }
    
    func observeMediaMessages() {
        
        FCFirebaseDatabaseService.sharedInstance.mediaMessagesRef.observe(DataEventType.childAdded) { [weak self] (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let senderID = data[Constants.SENDER_ID] as? String,
                    let senderName = data[Constants.SENDER_NAME] as? String,
                    let fileURL = data[Constants.URL] as? String {
                    
                    self?.delegate?.mediaRecieved(senderId: senderID, senderName: senderName, url: fileURL)
                }
                
            }
        }
    }
    
    func stopObserve() {
        
        FCFirebaseDatabaseService.sharedInstance.messagesRef.removeAllObservers()
        FCFirebaseDatabaseService.sharedInstance.mediaMessagesRef.removeAllObservers()
    }
    
}





