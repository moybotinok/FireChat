//
//  FCContactsVC.swift
//  FireChat
//
//  Created by Tatiana Bocharnikova on 20.03.2018.
//  Copyright © 2018 Tatiana Bocharnikova. All rights reserved.
//

import UIKit

class FCContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FetchData {

    private let CELL_IDENTIFIER = "Cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    private var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        FCFirebaseDatabaseService.sharedInstance.delegate = self;
        FCFirebaseDatabaseService.sharedInstance.getContacts()
    }

    func setupView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - FetchData
    
    func dataReceived(contacts: [Contact]) {
        
        self.contacts = contacts
        
        tableView.reloadData()
    }
    
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER)
        
        cell?.textLabel?.text = contacts[indexPath.row].name
        
        return cell!
    }
    
    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Actions
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
        if FCFirebaseAuthService.sharedInstance.logOut() {
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}
