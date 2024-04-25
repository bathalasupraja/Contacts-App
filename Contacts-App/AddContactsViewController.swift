//
//  AddContactsViewController.swift
//  Contacts-App
//
//  Created by Supraja on 25/04/24.
//

import UIKit

enum AddContactsFieldTypeEnum {
    case firstName, lastName, phone, email, dob
}

struct ContactsDataModel {
    var type: AddContactsFieldTypeEnum
    var name: String
    var placeholder: String
    var value: String?
}


class AddContactsViewController: UIViewController {
    
    static func create() -> AddContactsViewController? {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddContactsViewController") as? AddContactsViewController
    }
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    var contacts = [ContactsDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        createContacts()
        contactsTableView.separatorStyle = .none
        contactsTableView.allowsSelection = false
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        keyboardNotifications()

        
    }
    
    func createContacts() {
        contacts.append(ContactsDataModel(type: .firstName, name: "First name", placeholder: "Enter first name."))
        contacts.append(ContactsDataModel(type: .lastName, name: "Last name", placeholder: "Enter last name."))
        contacts.append(ContactsDataModel(type: .phone, name: "Phone", placeholder: "Enter phone number."))
        contacts.append(ContactsDataModel(type: .email, name: "Email", placeholder: "Enter email."))
        contacts.append(ContactsDataModel(type: .dob, name: "Dob", placeholder: "Enter dob."))
    }
    
    private func keyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        contactsTableView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        contactsTableView.contentInset.bottom = 0
    }
        
    private func getTextForContactsFieldType(_ type: AddContactsFieldTypeEnum) -> String? {
        contacts.first(where: { $0.type == type })?.value
    }
    
    
    @IBAction func didTouchSaveButtonAction() {
        view.endEditing(true)
        guard let firstName = getTextForContactsFieldType(.firstName),
        let lastName = getTextForContactsFieldType(.lastName),
        let phone = getTextForContactsFieldType(.phone),
        let phone = Int32(phone),
        let email = getTextForContactsFieldType(.email),
        let dob = getTextForContactsFieldType(.dob)
         else {
            showToast("Please enter valid input", message: "Please check the entered fields.")
            return
        }
        
        if phone == phone {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.fetchAllContacts { contacts in
                    if let contacts, !contacts.isEmpty, contacts.first(where: { $0.phone == phone }) != nil {
                        self.showToast("Contact is already saved!", message: "Entered contact is already saved, please try entered new contact")
                    } else {
                        appDelegate.addContacts(firstName: firstName, lastName: lastName, phone: phone, email: email, dob: dob)
                        if let controller = AllContactsViewController.create() {
                            UserDefaults.standard.set(phone, forKey: "phone")
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            }
            
        } else {
            showToast("Wrong contact", message: "Please check the entered number.")
        }
    }
    
    private func showToast(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
}

extension AddContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.id, for: indexPath)
        if let ContactsTableViewCell = cell as? ContactsTableViewCell {
            let contactsField = contacts[indexPath.row]
            ContactsTableViewCell.prepareWithContacts( contactsField, delegate: self, indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

extension AddContactsViewController: ContactsTableViewCellDelegate {
    func didUpdateText(_ text: String?, tag: Int) {
        print(text)
        print(tag)
        contacts[tag].value = text
    }
}

