//
//  ContactDetailsModels.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//


import UIKit

enum ContactDetails
{
    // MARK: Use cases
    
    enum DisplayContact
    {
        struct Request
        {
            let refresh:Bool
            let contactID:String
        }
        
        struct Response
        {
            let contact:Contact
        }
        
        struct ViewModel
        {
            let contact:DisplayableContact
        }
    }
    
    struct DisplayableContact {
        let contactID:String
        let fullName:String
        let phoneNumber:String
        let address:String
    }
}

