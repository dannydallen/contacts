//
//  ContactListPresenter.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

protocol ContactListPresentationLogic
{
    func presentAllContacts(response: ContactList.AllContacts.Response)
}

class ContactListPresenter: ContactListPresentationLogic
{
    weak var viewController: ContactListDisplayLogic?
    
    // MARK: Present Contacts
    
    func presentAllContacts(response: ContactList.AllContacts.Response)
    {
        var contacts:[ContactList.DisplayContact] = []
        
        let sortedContacts = response.contacts.sorted { (a, b) -> Bool in
            let lastNameCompare = (a.lastName ?? "").compare(b.lastName ?? "")
            
            if lastNameCompare == .orderedSame {
                let firstNameCompare = (a.firstName ?? "").compare(b.firstName ?? "")
                return firstNameCompare == .orderedAscending
            }
            else {
                return lastNameCompare == .orderedAscending
            }
        }
        
        for contact in sortedContacts {
            contacts.append(ContactList.DisplayContact(contactID: contact.contactID, firstName: contact.firstName ?? "" , lastName: contact.lastName ?? "", fullName: "\(contact.firstName ?? "") \(contact.lastName ?? "")"))
        }
        
        let viewModel = ContactList.AllContacts.ViewModel(contacts:contacts)
        viewController?.displayAllContacts(viewModel: viewModel)
    }
}


