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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
        nameTextField.resignFirstResponder()
    }
    
    func prepareWithContacts(_ contactsField: ContactsDataModel, delegate: ContactsTableViewCellDelegate?, indexPath: IndexPath) {
        nameTextField.inputView = getInputViewAtIndexPath(indexPath)
        nameTextField.keyboardType = getKeypadTypeForIndexPath(indexPath)
        nameLabel.text = contactsField.name
        nameTextField.placeholder = contactsField.placeholder
        nameTextField.text = contactsField.value
        nameTextField.resignFirstResponder()
        self.delegate = delegate
        nameTextField.tag = indexPath.row
    }
    
    func getInputViewAtIndexPath(_ indexPath: IndexPath) -> UIView? {
        switch indexPath.row {
        case 5:
            let datePicker = UIDatePicker()
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
            datePicker.datePickerMode = .date
            return datePicker
        default:
            return nil
        }
    }
    
    @objc func didChangeDate(_ sender: UIDatePicker) {
        print(sender.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        nameTextField.text = formatter.string(from: sender.date)
    }
    
    func getKeypadTypeForIndexPath(_ indexPath: IndexPath) -> UIKeyboardType {
        switch indexPath.row {
        case 0:
            return .default
        case 1,2:
            return .namePhonePad
        case 3:
            return .phonePad
        case 4:
            return .emailAddress
        default:
            return .default
        }
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
