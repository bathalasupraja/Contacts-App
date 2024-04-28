//
//  ContactsTableViewCell.swift
//  Contacts-App
//
//  Created by Supraja on 25/04/24.
//

import UIKit

protocol ContactsTableViewCellDelegate: AnyObject {
    func didUpdateText(_ text: String?, tag: Int)
}

class ContactsTableViewCell: UITableViewCell {
    
    static let id = "ContactsTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: ContactsTableViewCellDelegate?

    
    func prepareWithContacts(_ model: ContactsDataModel, delegate: ContactsTableViewCellDelegate?, indexPath: IndexPath) {
        self.delegate = delegate
        nameTextField.delegate = self
        nameTextField.resignFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func prepareWithContacts(_ contactsField: ContactsDataModel, delegate: ContactsTableViewCellDelegate?, indexPath: IndexPath) {
       // nameTextField.keyboardType = getKeypadTypeForIndexPath(indexPath)
        nameLabel.text = contactsField.name
        nameTextField.placeholder = contactsField.placeholder
        nameTextField.text = contactsField.value
        nameTextField.resignFirstResponder()
        self.delegate = delegate
        nameTextField.tag = indexPath.row
    }
}

extension ContactsTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ contactsField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ contactsField: UITextField) {
        delegate?.didUpdateText(contactsField.text, tag: contactsField.tag)
    }
}
