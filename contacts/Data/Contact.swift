//
//  Contact.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright © 2018 Milo Croton. All rights reserved.
//

import Foundation

class Contact : Codable {
    var contactID:String = UUID().uuidString
    var firstName:String?
    var lastName:String?
    var phoneNumber:String?
    var streetAddress1:String?
    var streetAddress2:String?
    var city:String?
    var state:String?
    var zipCode:String?
}
