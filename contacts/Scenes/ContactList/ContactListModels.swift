//
//  ContactListModels.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

enum ContactList
{
    // MARK: Use cases
    
    enum AllContacts
    {
        struct Request
        {
            let refresh:Bool
        }
        
        struct Response
        {
            let contacts:[Contact]
        }
        
        struct ViewModel
        {
            let contacts:[DisplayContact]
        }
    }
    
    enum DeleteContacts
    {
        struct Request
        {
            let contactsToDelete:[String]
        }
        
        struct Response
        {
            let contacts:[Contact]
        }
        
        struct ViewModel
        {
            let contacts:[DisplayContact]
        }
    }
    
    enum FilteredContacts
    {
        struct Request
        {
            let filter:String
        }
        
        struct Response
        {
            let contacts:[Contact]
        }
        
        struct ViewModel
        {
            let contacts:[DisplayContact]
        }
    }
    
    struct DisplayContact {
        let contactID:String
        let firstName:String
        let lastName:String
        let fullName:String
    }
}

