//
//  AddContactViewController.swift
//  contacts
//
//  Created by Danny Allen on 5/22/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

protocol AddContactDisplayLogic: class
{
    func displayContactSaved(viewModel: AddContact.SaveNewContact.ViewModel)
    func displayContact(viewModel: AddContact.ShowContact.ViewModel)
}

class AddContactViewController: UITableViewController, AddContactDisplayLogic
{
    var interactor: AddContactBusinessLogic?
    var router: (NSObjectProtocol & AddContactRoutingLogic & AddContactDataPassing)?
    var contact: Contact?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var street1TextField: UITextField!
    @IBOutlet weak var street2TextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBAction func cancel(_ sender: Any)
    {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any)
    {
        saveContact()
    }
    
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
        let interactor = AddContactInteractor()
        let presenter = AddContactPresenter()
        let router = AddContactRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
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
        
        if let contactID = router?.dataStore?.contactID {
            showContact(contactID: contactID)
        }
    }
    
    func showContact(contactID:String)
    {
        let request = AddContact.ShowContact.Request(contactID: contactID)
        interactor?.showContact(request: request)
    }
    
    func saveContact()
    {
        if self.contact != nil {
            let request = AddContact.SaveContact.Request(contact: gatherUpdatedData())
            interactor?.saveContact(request: request)
        }
        else {
            let request = AddContact.SaveNewContact.Request(newContact: gatherNewData())
            interactor?.saveNewContact(request: request)
        }
    }
    
    func gatherUpdatedData() -> Contact
    {
        if let updateContact = self.contact {
            updateContact.city = cityTextField.text
            updateContact.firstName = firstNameTextField.text
            updateContact.lastName = lastNameTextField.text
            updateContact.phoneNumber = phoneTextField.text
            updateContact.state = stateTextField.text
            updateContact.streetAddress1 = street1TextField.text
            updateContact.streetAddress2 = street2TextField.text
            updateContact.zipCode = zipTextField.text
            
            return updateContact
        }
        else {
            return gatherNewData()
        }
    }
    
    func gatherNewData() -> Contact
    {
        let newContact = Contact()
        
        newContact.city = cityTextField.text
        newContact.firstName = firstNameTextField.text
        newContact.lastName = lastNameTextField.text
        newContact.phoneNumber = phoneTextField.text
        newContact.state = stateTextField.text
        newContact.streetAddress1 = street1TextField.text
        newContact.streetAddress2 = street2TextField.text
        newContact.zipCode = zipTextField.text
        
        return newContact
    }
    
    func displayContactSaved(viewModel: AddContact.SaveNewContact.ViewModel)
    {
        if viewModel.saved {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func displayContact(viewModel: AddContact.ShowContact.ViewModel)
    {
        DispatchQueue.main.async {
            self.contact = viewModel.contact
            self.cityTextField.text = viewModel.contact.city
            self.firstNameTextField.text = viewModel.contact.firstName
            self.lastNameTextField.text = viewModel.contact.lastName
            self.phoneTextField.text = viewModel.contact.phoneNumber
            self.stateTextField.text = viewModel.contact.state
            self.street1TextField.text = viewModel.contact.streetAddress1
            self.street2TextField.text = viewModel.contact.streetAddress2
            self.zipTextField.text = viewModel.contact.zipCode
        }
    }
}


