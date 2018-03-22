//
//  FCFirebaseDatabaseService.swift
//  FireChat
//
//  Created by Tatiana Bocharnikova on 23.03.2018.
//  Copyright © 2018 Tatiana Bocharnikova. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


class FCFirebaseDatabaseService {
    
    static let sharedInstance = FCFirebaseDatabaseService()
    private init(){}
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var contactsRef: DatabaseReference {
        return dbRef.child(Constants.CONTACTS)
    }
    
    var messagesRef: DatabaseReference {
        return dbRef.child(Constants.MESSAGES)
    }
    
    var mediaMessagesRef: DatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES)
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL:Constants.FIREBASE_STORAGE_URL)
    }
    
    var imageStorageRef: StorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE)
    }
    
    var videoStorageRef: StorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE)
    }
    
    
    //MARK: --
    
    func saveUser(withID: String, email: String, password: String) {
        
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password];
        
        contactsRef.child(withID).setValue(data)
    }
    
    
    
    
    
    
//    service firebase.storage {
//    match /b/{bucket}/o {
//    match /{allPaths=**} {
//    allow read, write: if request.auth != null;
//    }
//    }
//    }
}
