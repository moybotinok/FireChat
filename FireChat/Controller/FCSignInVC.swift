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
    private let HUD_DURATION = 3.1
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String? {
        return emailTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
    let loginHud = LottieHUD("anubis")//("veil")
    let signUpHud = LottieHUD("acrobatics")
    
    //MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            self.emailTextField.text = "tany@tany.com"
            self.passwordTextField.text = "111111"
        #endif
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        vc.modalTransitionStyle = .partialCurl
    }


    //MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        loginHud.showHUD()
        
        if isValidEmail(testStr: email) && password != "" {
            
            FCFirebaseAuthService.sharedInstance.login(withEmail: email!, password: password!, loginHandler: { [weak self] (message) in
             
                if let message = message {
                    
                    self?.alertTheUser(title: "Ошибка авторизации", message: message)
                    
                } else {
                    
                    self?.clearTextFields()
                    self?.dismissHUD()
                    self?.performSegue(withIdentifier: (self?.CONTACTS_SEGUE)!, sender: nil)
                }
            })
        
        } else {
            
            perform(#selector(cantLogin), with: nil, afterDelay: TimeInterval(HUD_DURATION))
        }
        
    }

    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        signUpHud.showHUD()
        
        if isValidEmail(testStr: email) && password != "" {
            
            FCFirebaseAuthService.sharedInstance.signUp(withEmail: email!, password: password!, loginHandler: { [weak self] (message) in
                
                if let message = message {
                    
                    self?.alertTheUser(title: "Ошибка регистрации", message: message)
                    
                } else {
                    
                    self?.clearTextFields()
                    self?.dismissHUD()
                    self?.performSegue(withIdentifier: (self?.CONTACTS_SEGUE)!, sender: nil)
                }
            })
            
        } else {
            
            perform(#selector(cantSignIn), with: nil, afterDelay: TimeInterval(HUD_DURATION))
            
        }
    }
    

    @objc private func cantLogin() {
        
        alertTheUser(title: "🙀\nЧто-то не так", message: "Введи реальный @mail и пароль")
    }
    
    @objc private func cantSignIn() {
        
        alertTheUser(title: "😾\nЧто-то не так", message: "Введи реальный @mail и пароль")
    }
    
    private func alertTheUser(title: String, message: String) {
        
        dismissHUD()
        
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
    

    @objc func dismissHUD() {

        print("dismissHUD")
        loginHud.stopHUD()
        signUpHud.stopHUD()
    }
    
    
    //MARK: - Helpers
    
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
