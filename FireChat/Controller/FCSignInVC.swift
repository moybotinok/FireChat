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
        
        performSegue(withIdentifier: CONTACTS_SEGUE, sender: nil)
    }

    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
    }
    
}
