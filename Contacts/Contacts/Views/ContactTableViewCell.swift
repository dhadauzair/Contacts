//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactIsFavImageView: UIImageView!
    

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
    
    func configureCellUI(contact : Contact) {
        
        if let firstName = contact.firstName, let lastName = contact.lastName {
            contactNameLabel.text = firstName + " " + lastName
        }
        
        if let isContactFav = contact.favorite {
            if isContactFav {
                contactIsFavImageView.image = #imageLiteral(resourceName: "favourite_button_selected")
            }
        }
        
        if let imageStringUrl = contact.profilePic {
            guard let imageURLWithBaseUrl = URL(string: API.environment.baseURL + imageStringUrl) else { return }
            contactImageView.loadImageFrom(url: imageURLWithBaseUrl)
        } else {
            contactImageView.image = #imageLiteral(resourceName: "placeholder_photo")
        }
        
    }

}
