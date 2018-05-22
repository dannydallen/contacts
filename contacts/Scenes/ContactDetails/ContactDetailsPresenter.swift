//
//  ContactDetailsPresenter.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

protocol ContactDetailsPresentationLogic
{
    func presentContact(response: ContactDetails.DisplayContact.Response)
}

class ContactDetailsPresenter: ContactDetailsPresentationLogic
{
    weak var viewController: ContactDetailsDisplayLogic?
    
    func presentContact(response: ContactDetails.DisplayContact.Response)
    {
        let fullName = "\(response.contact.firstName ?? "") \(response.contact.lastName ?? "")"
        let address = "\(response.contact.streetAddress1 ?? "")\n\(response.contact.streetAddress2 ?? "")\n\(response.contact.city ?? ""), \(response.contact.state ?? "") \(response.contact.zipCode ?? "")"
        let viewModel = ContactDetails.DisplayContact.ViewModel(contact: ContactDetails.DisplayableContact(contactID: response.contact.contactID, fullName: fullName, phoneNumber: response.contact.phoneNumber ?? "", address: address))
        
        viewController?.displayContact(viewModel: viewModel)
    }
}

