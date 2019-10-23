//
//  AddOrEditTableViewCell.swift
//  Contacts
//
//  Created by Uzair Dhada on 20/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

protocol ParentControllerDelegate {
    func notifyParentController(ForText text: String, withTag tag:Int)
    func notifyParentControllerModelFavouriteChanged(contactDetail : ContactDetail)
    func notifyParentControllerIfContactIsSuccessfulltAddedOrEdited(isContactEdited : Bool, with contactDetail : ContactDetail)
}

class AddOrEditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactDetailKeyLabel: UILabel!
    @IBOutlet weak var contactDetailValueTextFiled: UITextField!
    
    var delegate : ParentControllerDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(WithContactDetail contactDetail: ContactDetail?, ForRow row: Int) {
        if row == 0 {
            self.contactDetailKeyLabel.text = "First Name"
            if let firstName = contactDetail?.firstName {
                self.contactDetailValueTextFiled.text = firstName
            }
        } else if row == 1 {
            self.contactDetailKeyLabel.text = "Last Name"
            if let lastName = contactDetail?.lastName {
                self.contactDetailValueTextFiled.text = lastName
            }
        } else if row == 2 {
            self.contactDetailKeyLabel.text = "mobile"
            if let phoneNumber = contactDetail?.phoneNumber {
                self.contactDetailValueTextFiled.text = phoneNumber
            }
            self.contactDetailValueTextFiled.keyboardType = .numberPad
        } else {
            self.contactDetailKeyLabel.text = "email"
            if let email = contactDetail?.email {
                self.contactDetailValueTextFiled.text = email
            }
        }
        self.contactDetailValueTextFiled.tag = row
        self.contactDetailValueTextFiled.delegate = self
    }

}

extension AddOrEditTableViewCell : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate.notifyParentController(ForText: textField.text ?? "", withTag: textField.tag)
    }
}
