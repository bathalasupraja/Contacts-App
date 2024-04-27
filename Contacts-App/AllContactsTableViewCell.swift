//
//  AllContactsTableViewCell.swift
//  Contacts-App
//
//  Created by Supraja on 25/04/24.
//

import UIKit

class AllContactsTableViewCell: UITableViewCell {
    
    static let id = "AllContactsTableViewCell"
    
    @IBOutlet weak var firstNameDataLabel: UILabel!
    @IBOutlet weak var lastNameDataLabel: UILabel!
    @IBOutlet weak var phoneDataLabel: UILabel!
    @IBOutlet weak var emailDataLabel: UILabel!
    @IBOutlet weak var dobDataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func prepareContact(_ contact: ContactsEntity) {
        firstNameDataLabel.text = contact.firstName
        lastNameDataLabel.text = contact.lastName
        phoneDataLabel.text = "\(contact.phone)"
        emailDataLabel.text = contact.email
        dobDataLabel.text = contact.dob
    }

}
