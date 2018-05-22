//
//  ContactListRouter.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

@objc protocol ContactListRoutingLogic
{
    func routeToContactDetails(segue: UIStoryboardSegue?)
}

protocol ContactListDataPassing
{
    var dataStore: ContactListDataStore? { get }
}

class ContactListRouter: NSObject, ContactListRoutingLogic, ContactListDataPassing
{
    weak var viewController: ContactListViewController?
    var dataStore: ContactListDataStore?
    
    // MARK: Routing
    
    func routeToContactDetails(segue: UIStoryboardSegue?)
    {
                if let segue = segue {
                    let destinationVC =  (segue.destination as! UINavigationController).topViewController as! ContactDetailsViewController
                    var destinationDS = destinationVC.router!.dataStore!
                    passDataToContactDetails(source: dataStore!, destination: &destinationDS)
                }

    }
    
        func passDataToContactDetails(source: ContactListDataStore, destination: inout ContactDetailsDataStore)
        {
            destination.contactID = source.selectedContentID!
        }
}


