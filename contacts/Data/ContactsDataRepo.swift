//
//  ContactsDataRepo.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright © 2018 Milo Croton. All rights reserved.
//

protocol ContactsDataRepo
{
    /// Requests from the repo all stored contacts
    /// Must be done async and the closure will indicate success and a list of contacts
    func requestContacts(response:@escaping (Bool, [Contact]) -> Void)
    
    /// Requests the given contacts be saved to the repo
    /// Must be done async and the closure will indicate success
    func requestSaveContacts(contacts:[Contact], response:@escaping (Bool) -> Void)
}
