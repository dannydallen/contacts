//
//  ContactsData.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright © 2018 Milo Croton. All rights reserved.
//

import Foundation

class ContactsData
{
    var contactData:[String:Contact]
    let contactsRepo:ContactsDataRepo
    static let shared = ContactsData()
    
    private init() {
        contactsRepo = ContactsFileDataRepo()
        contactData = [:]
    }
    
    func allContacts() -> [Contact]
    {
        return Array(contactData.values)
    }
    
    func requestContacts(response: @escaping (Bool) -> Void)
    {
        contactsRepo.requestContacts { (success, contacts) in
            if success {
                for contact in contacts {
                    self.contactData[contact.contactID] = contact
                }
            }
            
            response(success)
        }
    }
    
    func requestSaveContacts(response: @escaping (Bool) -> Void)
    {
        contactsRepo.requestSaveContacts(contacts: allContacts(), response: response)
    }
    
    func contact(with contactID:String) -> Contact?
    {
        return contactData[contactID]
    }
    
    func removeContact(with contactID:String)
    {
        contactData.removeValue(forKey: contactID)
        requestSaveContacts { (success) in
            print("Saved after remove \(success ? "succeded" : "failed")")
        }
    }
    
    func updateContact(_ contact:Contact)
    {
        contactData[contact.contactID] = contact

        requestSaveContacts { (success) in
            print("Saved after update \(success ? "succeded" : "failed")")
        }
    }
    
    func addContact(_ contact:Contact)
    {
        contactData[contact.contactID] = contact
        
        requestSaveContacts { (success) in
            print("Saved after add \(success ? "succeded" : "failed")")
        }
    }
}
