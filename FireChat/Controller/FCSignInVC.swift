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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        vc.modalTransitionStyle = .partialCurl
    }


    
    //MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if isValidEmail(testStr: email) && password != "" {
            
            FCFirebaseAuthService.sharedInstance.login(withEmail: email, password: password, loginHandler: { (message) in
             
                if let message = message {
                    
                    self.alertTheUser(title: "Ошибка авторизации", message: message)
                    
                } else {
                    
                    self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil)
                }
            })
        
        }
        
    }

    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        alertTheUser(title: "Hi", message: "test alert")
    }
    
    
    private func alertTheUser(title: String, message: String) {
        
//        let alert = KLCPopup.init(contentView: nil, showType: .bounceInFromRight, dismissType: .bounceOutToBottom, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
//
//        alert?.show()
        
        let alert = NYAlertViewController.alert(withTitle: title, message: message)
        alert?.backgroundTapDismissalGestureEnabled = true
        alert?.transitionStyle = .slideFromRight
        let ok = NYAlertAction(title: "OK", style: .default, handler: nil)
        alert?.addAction(ok)
        present(alert!, animated: true, completion: nil)
        
        
      //  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       // let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
       // alert.addAction(ok)
       // present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Helpers
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
