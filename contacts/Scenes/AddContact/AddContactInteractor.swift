//
//  AddContactInteractor.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

protocol AddContactBusinessLogic
{
    func saveNewContact(request: AddContact.SaveNewContact.Request)
    func showContact(request: AddContact.ShowContact.Request)
    func saveContact(request: AddContact.SaveContact.Request)
}

protocol AddContactDataStore
{
    var contactID: String? { get set }
}

class AddContactInteractor: AddContactBusinessLogic, AddContactDataStore
{
    var presenter: AddContactPresentationLogic?
    var contactID: String?
    
    func showContact(request: AddContact.ShowContact.Request)
    {
        let contact = ContactsData.shared.contact(with: request.contactID)
        
        let response = AddContact.ShowContact.Response(contact: contact ?? Contact())
        self.presenter?.presentContact(response: response)
    }
    
    func saveContact(request: AddContact.SaveContact.Request)
    {
        ContactsData.shared.updateContact(request.contact)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationContactUpdated), object:request.contact.contactID)
        
        self.presenter?.presentContactSaved(response: AddContact.SaveNewContact.Response(saved: true))
    }
    
    func saveNewContact(request: AddContact.SaveNewContact.Request)
    {
        ContactsData.shared.addContact(request.newContact)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationNewContactAdded), object: nil)
        
        self.presenter?.presentContactSaved(response: AddContact.SaveNewContact.Response(saved: true))
    }
}

