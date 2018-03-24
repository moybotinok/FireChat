//
//  Contact.swift
//  FireChat
//
//  Created by Tatiana Bocharnikova on 24.03.2018.
//  Copyright © 2018 Tatiana Bocharnikova. All rights reserved.
//

import Foundation


class Contact {
    
    private var _name = ""
    private var _id = ""
    
    var name: String {
        return _name
    }
    
    var id: String {
        return _id
    }
    
    init(id: String, name: String) {
        _id = id
        _name = name
    }
    
}
