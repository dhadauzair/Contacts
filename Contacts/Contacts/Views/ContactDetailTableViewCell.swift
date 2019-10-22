//
//  ContactDetailTableViewCell.swift
//  Contacts
//
//  Created by Uzair Dhada on 20/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var contactDetailKeyLabel: UILabel!
    @IBOutlet weak var contactDetailValueLabel: UILabel!
    
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
    
    func configureCellUI(contact : ContactDetail, forRow row: Int) {
        if row == 0 {
            contactDetailKeyLabel.text = "mobile"
            if let mobileNumber = contact.phoneNumber {
                contactDetailValueLabel.text = mobileNumber
            }
        } else {
            contactDetailKeyLabel.text = "email"
            if let email = contact.email {
                contactDetailValueLabel.text = email
            }
        }
    }

}
