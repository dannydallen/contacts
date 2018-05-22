//
//  AddContactPresenter.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

protocol AddContactPresentationLogic
{
    func presentContactSaved(response: AddContact.SaveNewContact.Response)
    func presentContact(response: AddContact.ShowContact.Response)
}

class AddContactPresenter: AddContactPresentationLogic
{
    weak var viewController: AddContactDisplayLogic?
    
    func presentContactSaved(response: AddContact.SaveNewContact.Response)
    {
        let viewModel = AddContact.SaveNewContact.ViewModel(saved: response.saved)
        viewController?.displayContactSaved(viewModel: viewModel)
    }
    
    
    func presentContact(response: AddContact.ShowContact.Response)
    {
        let viewModel = AddContact.ShowContact.ViewModel(contact: response.contact)
        viewController?.displayContact(viewModel: viewModel)
    }
}

