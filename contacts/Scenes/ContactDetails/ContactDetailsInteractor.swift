//
//  ContactDetailsInteractor.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//


import UIKit

protocol ContactDetailsBusinessLogic
{
    func displayContact(request: ContactDetails.DisplayContact.Request)
}

protocol ContactDetailsDataStore
{
    var contactID: String? { get set }
}

class ContactDetailsInteractor: ContactDetailsBusinessLogic, ContactDetailsDataStore
{
    var presenter: ContactDetailsPresentationLogic?
    var contactID: String?
    
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(contactUpdated(notif:)), name: Notification.Name(kNotificationContactUpdated), object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func contactUpdated(notif:Notification)
    {
        let contactID = notif.object as! String
        let request = ContactDetails.DisplayContact.Request(refresh: true, contactID: contactID)
        self.displayContact(request:request)
    }
    
    func displayContact(request: ContactDetails.DisplayContact.Request)
    {
        let contact = ContactsData.shared.contact(with: request.contactID)
        let response = ContactDetails.DisplayContact.Response(contact: contact ?? Contact())
        self.presenter?.presentContact(response: response)
    }
}

