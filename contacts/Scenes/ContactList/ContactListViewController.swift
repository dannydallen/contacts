//
//  ContactListViewController.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright (c) 2018 Milo Croton. All rights reserved.
//

import UIKit

protocol ContactListDisplayLogic: class
{
    func displayAllContacts(viewModel: ContactList.AllContacts.ViewModel)
    func displayFilteredContacts(viewModel: ContactList.FilteredContacts.ViewModel)
}

class ContactListViewController: UITableViewController, ContactListDisplayLogic
{
    var contacts:[ContactList.DisplayContact] = []
    
    var detailViewController: ContactDetailsViewController? = nil
    
    var interactor: (ContactListBusinessLogic & ContactListDataStore)?
    var router: (NSObjectProtocol & ContactListRoutingLogic & ContactListDataPassing)?
    
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
        let interactor = ContactListInteractor()
        let presenter = ContactListPresenter()
        let router = ContactListRouter()
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
                if let indexPath = tableView.indexPathForSelectedRow {
                    let object = contacts[indexPath.row]
                    interactor?.selectedContentID = object.contactID
                }
                
                let controller = (segue.destination as! UINavigationController).topViewController
                controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller?.navigationItem.leftItemsSupplementBackButton = true
                
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ContactDetailsViewController
        }
        
        showAllContacts(refresh: true)
    }
    
    @objc
    func addContact(_ sender: Any)
    {
        performSegue(withIdentifier: "AddContact", sender: nil)
    }
    
    func showAllContacts(refresh:Bool)
    {
        let request = ContactList.AllContacts.Request(refresh: refresh)
        interactor?.showAllContacts(request: request)
    }
    
    func deleteContact(contactID:String)
    {
        let request = ContactList.DeleteContacts.Request(contactsToDelete: [contactID])
        interactor?.deleteContacts(request: request)
    }
    
    func displayAllContacts(viewModel:ContactList.AllContacts.ViewModel)
    {
        contacts = viewModel.contacts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayFilteredContacts(viewModel:ContactList.FilteredContacts.ViewModel)
    {
        contacts = viewModel.contacts
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contact = contacts[indexPath.row]
        configureCell(cell, withContact: contact)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withContact contact: ContactList.DisplayContact)
    {
        let name = NSMutableAttributedString(string:contact.fullName)
        
        name.addAttribute(NSAttributedStringKey.font, value:UIFont(name:"Helvetica", size:14.0)!, range:NSMakeRange(0,contact.firstName.count))
        name.addAttribute(NSAttributedStringKey.font, value:UIFont(name:"Helvetica-Bold", size:14.0)!, range:NSMakeRange(contact.firstName.count + 1, contact.lastName.count))
        name.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.black, range:NSMakeRange(0, contact.fullName.count))
        
        cell.textLabel!.attributedText = name
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteContact(contactID: contacts[indexPath.row].contactID)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
}

