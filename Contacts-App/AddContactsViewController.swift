//
//  AddContactsViewController.swift
//  Contacts-App
//
//  Created by Supraja on 25/04/24.
//

import UIKit

enum AddContactsFieldTypeEnum {
    case photo, firstName, lastName, phone, email, dob
}

struct ContactsDataModel {
    var type: AddContactsFieldTypeEnum
    var name: String
    var placeholder: String
    var value: String?
    var image: UIImage? /// Used to store contact image data
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
        contacts.append(ContactsDataModel(type: .photo, name: "Photo", placeholder: "Capture Contact photo"))
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
        let phone = Int64(phone),
        let email = getTextForContactsFieldType(.email),
        let dob = getTextForContactsFieldType(.dob)
         else {
            showToast("Please enter valid input", message: "Please check the entered fields.")
            return
        }
        let image = contacts.first(where: { $0.type == .photo })?.image
        if phone == phone {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.fetchAllContacts { contacts in
                    if let contacts, !contacts.isEmpty, contacts.first(where: { $0.phone == phone }) != nil {
                        self.showToast("Contact is already saved!", message: "Entered contact is already saved, please try entered new contact")
                    } else {
                        appDelegate.addContacts(firstName: firstName, lastName: lastName, phone: phone, email: email, dob: dob, image: image)
                            UserDefaults.standard.set(phone, forKey: "phone")
                            self.navigationController?.popViewController(animated: true)
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
    
    func cellIdentifierAtIndexPath(_ indexPath: IndexPath) -> String {
        if indexPath.row == 0 {
            return ContactImageTableViewCell.identifier
        } else {
            return ContactsTableViewCell.id
        }
    }
    
    func cellHeightAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? 120 : 70
    }
}

extension AddContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = cellIdentifierAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let contactsTableViewCell = cell as? ContactsTableViewCell {
            let contactsField = contacts[indexPath.row]
            contactsTableViewCell.prepareWithContacts( contactsField, delegate: self, indexPath: indexPath)
        } else if let photoCell = cell as? ContactImageTableViewCell {
            photoCell.delegate = self
            photoCell.prepare(contacts[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeightAtIndexPath(indexPath)
    }
}

extension AddContactsViewController: ContactsTableViewCellDelegate {
    func didUpdateText(_ text: String?, tag: Int) {
        print(text)
        print(tag)
        contacts[tag].value = text
    }
}

// MARK: - Open Camera
extension AddContactsViewController: ContactImageTableViewCellDelegate {
    func didTouchImage() {
        let alert = UIAlertController(title: "Select Image source.", message: "Please select your image source.", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            /// Action - camera
            self.showImagePicker(.camera)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            /// Action - gallery
            self.showImagePicker(.photoLibrary)
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        
        /// for iPad
        if let popoverController = alert.popoverPresentationController {
            /// get the cell
            if let cell = contactsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ContactImageTableViewCell {
                popoverController.sourceView = cell.cellImageView
                popoverController.sourceRect = cell.cellImageView.bounds
            }
        }
        
        self.present(alert, animated: true)
    }
    
    private func showImagePicker(_ source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) { /// Check is camera available.
            var controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = source
            controller.allowsEditing = true
            self.present(controller, animated: true)
        } else {
            let alert = UIAlertController(title: "No camera found!", message: "Please check your device camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Handling Image picking options.
extension AddContactsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, let index = contacts.firstIndex(where: { $0.type == .photo }) {
            contacts[index].image = image
        }
        picker.dismiss(animated: true)
        contactsTableView.reloadData()
    }
}
