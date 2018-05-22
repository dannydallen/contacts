//
//  ContactDetailsRouter.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//


import UIKit

@objc protocol ContactDetailsRoutingLogic
{
    func routeToEditContact(segue: UIStoryboardSegue?)
}

protocol ContactDetailsDataPassing
{
    var dataStore: ContactDetailsDataStore? { get }
}

class ContactDetailsRouter: NSObject, ContactDetailsRoutingLogic, ContactDetailsDataPassing
{
    weak var viewController: ContactDetailsViewController?
    var dataStore: ContactDetailsDataStore?
    
    func routeToEditContact(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = (segue.destination as! UINavigationController).topViewController as! AddContactViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToEditContact(source: dataStore!, destination: &destinationDS)
        }
    }
    
    func passDataToEditContact(source: ContactDetailsDataStore, destination: inout AddContactDataStore)
    {
        destination.contactID = source.contactID
    }
}
