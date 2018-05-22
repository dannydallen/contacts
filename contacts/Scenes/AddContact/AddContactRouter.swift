//
//  AddContactRouter.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

@objc protocol AddContactRoutingLogic
{

}

protocol AddContactDataPassing
{
    var dataStore: AddContactDataStore? { get }
}

class AddContactRouter: NSObject, AddContactRoutingLogic, AddContactDataPassing
{
    weak var viewController: AddContactViewController?
    var dataStore: AddContactDataStore?
}

