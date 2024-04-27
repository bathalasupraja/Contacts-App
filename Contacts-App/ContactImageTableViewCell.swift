//
//  ContactImageTableViewCell.swift
//  Contacts-App
//
//  Created by Supraja on 26/04/24.
//

import UIKit

protocol ContactImageTableViewCellDelegate: AnyObject {
    func didTouchImage()
}

class ContactImageTableViewCell: UITableViewCell {
    
    static let identifier = "ContactImageTableViewCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    
    weak var delegate: ContactImageTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 40
        cellView.layer.masksToBounds = true
        cellImageView.contentMode = .scaleToFill
    }
    
    func prepare(_ contact: ContactsDataModel) {
        if let image = contact.image {
            cellImageView.image = image
        } else {
            cellImageView.image = UIImage(named: "default-contact-icon")
        }
    }

    @IBAction func didTouchImage() {
        delegate?.didTouchImage()
    }

}
