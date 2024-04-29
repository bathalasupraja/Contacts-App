//
//  AllContactsTableViewCell.swift
//  Contacts-App
//
//  Created by Supraja on 25/04/24.
//

import UIKit

class AllContactsTableViewCell: UITableViewCell {
    
    static let id = "AllContactsTableViewCell"
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var firstNameDataLabel: UILabel!
    @IBOutlet weak var phoneDataLabel: UILabel!
    @IBOutlet weak var emailDataLabel: UILabel!
    @IBOutlet weak var dobDataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contactImageView.layer.cornerRadius = 40
        contactImageView.layer.masksToBounds = true
        contactImageView.contentMode = .scaleToFill
        selectionStyle = .none
    }
    
    func prepareContact(_ contact: ContactsEntity) {
        var nameComponents = [String]()
        if let firstName = contact.firstName {
            nameComponents.append(firstName.capitalized)
        }
        
        if let lastName = contact.lastName {
            nameComponents.append(lastName.capitalized)
        }
        
        firstNameDataLabel.text = nameComponents.joined(separator: ", ")
        phoneDataLabel.text = "\(contact.phone)"
        emailDataLabel.text = contact.email
        dobDataLabel.text = contact.dob
        if let imageString = contact.photo, let data = Data(base64Encoded: imageString) {
            let image = UIImage(data: data)
            contactImageView.image = image ?? UIImage(named: "default-contact-icon")
        } else {
            contactImageView.image = UIImage(named: "default-contact-icon")
        }
    }

}
