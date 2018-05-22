//
//  AddContactModels.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

enum AddContact
{
    // MARK: Use cases
    
    enum SaveNewContact
    {
        struct Request
        {
            let newContact:Contact
        }
        
        struct Response
        {
            let saved:Bool
        }
        
        struct ViewModel
        {
            let saved:Bool
        }
    }
    
    
    enum SaveContact
    {
        struct Request
        {
            let contact:Contact
        }
        
        struct Response
        {
            let saved:Bool
        }
        
        struct ViewModel
        {
            let saved:Bool
        }
    }
    
    enum ShowContact
    {
        struct Request
        {
            let contactID:String
        }
        
        struct Response
        {
            let contact:Contact
        }
        
        struct ViewModel
        {
            let contact:Contact
        }
    }
}

