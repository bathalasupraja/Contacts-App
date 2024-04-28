//
//  ContactsTableViewCell.swift
//  Contacts-App
//
//  Created by Supraja on 28/04/24.
//

import UIKit

protocol ContactsTableViewCellDelegate: AnyObject {
    func didUpdateText(_ text: String?, tag: Int)
}

class ContactsTableViewCell: UITableViewCell {
    
    static let id = "ContactsTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: ContactsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func prepareWithContacts(_ model: ContactsDataModel, delegate: ContactsTableViewCellDelegate?, indexPath: IndexPath) {
        self.delegate = delegate
    }

}
