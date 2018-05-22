//
//  ContactListInteractor.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

protocol ContactListBusinessLogic
{
    func showAllContacts(request: ContactList.AllContacts.Request)
    func deleteContacts(request: ContactList.DeleteContacts.Request)
}

protocol ContactListDataStore
{
    var selectedContentID:String? { get set }
}

class ContactListInteractor: ContactListBusinessLogic, ContactListDataStore
{
    var presenter: ContactListPresentationLogic?
    var selectedContentID:String?
    
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(newContactAdded), name: Notification.Name(kNotificationNewContactAdded), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(contactUpdated), name: Notification.Name(kNotificationContactUpdated), object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func newContactAdded()
    {
        showAllContacts(request: ContactList.AllContacts.Request(refresh:false))
    }
    
    @objc
    func contactUpdated()
    {
        showAllContacts(request: ContactList.AllContacts.Request(refresh:false))
    }
    
    func showAllContacts(request: ContactList.AllContacts.Request)
    {
        if request.refresh {
            ContactsData.shared.requestContacts(response: { (success) in
                let response = ContactList.AllContacts.Response(contacts: ContactsData.shared.allContacts())
                self.presenter?.presentAllContacts(response: response)
            })
        }
        else {
            let response = ContactList.AllContacts.Response(contacts:ContactsData.shared.allContacts())
            self.presenter?.presentAllContacts(response: response)
        }
    }
    
    func deleteContacts(request: ContactList.DeleteContacts.Request)
    {
        for contactID in request.contactsToDelete {
            ContactsData.shared.removeContact(with:contactID)
        }
        
        let response = ContactList.AllContacts.Response(contacts: ContactsData.shared.allContacts())
        self.presenter?.presentAllContacts(response: response)
    }
}

