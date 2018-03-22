//
//  FCSignInVC.swift
//  FireChat
//
//  Created by Tatiana Bocharnikova on 20.03.2018.
//  Copyright © 2018 Tatiana Bocharnikova. All rights reserved.
//

import UIKit


class FCSignInVC: UIViewController {

    private let CONTACTS_SEGUE = "ContactsSegue"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String? {
        return emailTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
    //MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        vc.modalTransitionStyle = .partialCurl
    }


    //MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if isValidEmail(testStr: email) && password != "" {
            
            FCFirebaseAuthService.sharedInstance.login(withEmail: email!, password: password!, loginHandler: { [weak self] (message) in
             
                if let message = message {
                    
                    self?.alertTheUser(title: "Ошибка авторизации", message: message)
                    
                } else {
                    
                    self?.clearTextFields()
                    self?.performSegue(withIdentifier: (self?.CONTACTS_SEGUE)!, sender: nil)
                }
            })
        
        } else {
            
            alertTheUser(title: "🙀\nЧто-то не так", message: "Введи реальный @mail и пароль")
        }
        
    }

    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        if isValidEmail(testStr: email) && password != "" {
            
            FCFirebaseAuthService.sharedInstance.signUp(withEmail: email!, password: password!, loginHandler: { [weak self] (message) in
                
                if let message = message {
                    
                    self?.alertTheUser(title: "Ошибка регистрации", message: message)
                    
                } else {
                    
                    self?.clearTextFields()
                    self?.performSegue(withIdentifier: (self?.CONTACTS_SEGUE)!, sender: nil)
                }
            })
            
        } else {
            
            alertTheUser(title: "😾\nЧто-то не так", message: "Введи реальный @mail и пароль")
        }
    }
    
    
    private func alertTheUser(title: String, message: String) {
        
        let alert = NYAlertViewController.alert(withTitle: title, message: "\n\(message)\n")
        alert?.backgroundTapDismissalGestureEnabled = true
        alert?.transitionStyle = .slideFromRight
        alert?.buttonColor = UIColor.red;
        
        let ok = NYAlertAction(title: "OK", style: .default, handler: { [weak alert] (alertAction) in
            alert?.dismiss(animated: true, completion: nil)
        })
        alert?.addAction(ok)
        present(alert!, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Private
    
    func isValidEmail(testStr:String?) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func clearTextFields() {
        
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
}
