//
//  ViewController.swift
//  Contacts-App
//
//  Created by Supraja on 25/04/24.
//

import UIKit

class AllContactsViewController: UIViewController {
    
    static func create() -> AllContactsViewController? {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllContactsViewController") as? AllContactsViewController
    }
    
    @IBOutlet weak var allContactsTableView: UITableView!
    
    var contactDetails = [ContactsEntity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllContacts()
        allContactsTableView.dataSource = self
        allContactsTableView.delegate = self
    }
    
    func fetchAllContacts() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.fetchAllContacts { contacts in
                if let contacts = contacts {
                    self.contactDetails = contacts
                }
            }
        }
    }
    
    @IBAction func didTouchAddButtonAction() {
        if let controller = AddContactsViewController.create() {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension AllContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllContactsTableViewCell.id, for: indexPath)
        if let allContactsTableViewCell = cell as? AllContactsTableViewCell {
            let contact = contactDetails[indexPath.row]
            allContactsTableViewCell.prepareContact(contact)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}

