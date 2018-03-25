//
//  FCFirebaseAuthService.swift
//  FireChat
//
//  Created by Tatiana Bocharnikova on 21.03.2018.
//  Copyright © 2018 Tatiana Bocharnikova. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let INVALID_EMAIL = "Неверный email. Пожалуйста, введите реальный адресс электронной почты."
    static let WRONG_PASSWORD = "Неверный пароль. Пожалуйста введите корректный."
    static let USER_NOT_FOUND = "Пользователь не найден. Пожалуйста зарегистрируйтесь."
    static let EMAIL_ALREADY_IN_USE = "Email уже используется."
    static let WEAK_PASSWORD = "Пароль должен содержать минимум 6 символов."
    static let PROBLEM_CONNECTION = "Не удается подключится. Пожалуйста попробуйте позже."
}

class FCFirebaseAuthService {
    
    static let sharedInstance = FCFirebaseAuthService()
    private init(){}
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            
            if error != nil {
                
                self.handleErrors(error: error! as NSError, loginHandler: loginHandler)
                
            } else {
                
                loginHandler?(nil)
            }
        }
    }
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
            
            if error != nil {
                
                self.handleErrors(error: error! as NSError, loginHandler: loginHandler)
                
            } else {
                
                if let userUID = user?.uid {
                    
                    FCFirebaseDatabaseService.sharedInstance.saveUser(withID: userUID, email: withEmail, password: password)
                    
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
                }
            }
        }
    }
    
    
    func logOut() -> Bool {
        
        if isLoggedIn() {
            do {
                
                try Auth.auth().signOut()
                return true
                
            } catch {
                
                return false
            }
        }
        
        return true
    }
    
    func isLoggedIn() -> Bool {
        
        if let _ = Auth.auth().currentUser {
            
            return true
        }
        
        return false
    }
    
    func userId() -> String? {
        
        return Auth.auth().currentUser?.uid
    }
    
    private func handleErrors(error: NSError, loginHandler: LoginHandler?) {
        
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            
            switch errorCode {
                
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
                
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
                
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
                
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
                
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTION)
                break
                
            }
        }
    }
    
  
}





