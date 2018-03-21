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





