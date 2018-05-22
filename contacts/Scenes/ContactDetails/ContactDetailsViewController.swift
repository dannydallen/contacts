//
//  ContactDetailsViewController.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//


import UIKit

protocol ContactDetailsDisplayLogic: class
{
    func displayContact(viewModel: ContactDetails.DisplayContact.ViewModel)
}

class ContactDetailsViewController: UIViewController, ContactDetailsDisplayLogic
{
    var interactor: ContactDetailsBusinessLogic?
    var router: (NSObjectProtocol & ContactDetailsRoutingLogic & ContactDetailsDataPassing)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneField: UITextView!
    @IBOutlet weak var addressField: UITextView!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ContactDetailsInteractor()
        let presenter = ContactDetailsPresenter()
        let router = ContactDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let contactID = self.router?.dataStore?.contactID {
            showContact(refresh: true, contactID:contactID)
        }
    }
    
    func showContact(refresh:Bool, contactID:String)
    {
        let request = ContactDetails.DisplayContact.Request(refresh:refresh, contactID: contactID)
        interactor?.displayContact(request: request)
    }
    
    func displayContact(viewModel: ContactDetails.DisplayContact.ViewModel)
    {
        DispatchQueue.main.async {
            if self.nameLabel != nil {
                self.nameLabel.text = viewModel.contact.fullName
                self.phoneField.text = viewModel.contact.phoneNumber
                self.addressField.text = viewModel.contact.address
            }
        }
    }
}

