//
//  ContactsModel.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import Foundation

class Contact: Codable {
    let id: Int?
    let firstName, lastName: String?
    let profilePic: String?
    let favorite: Bool?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite, url
    }

    init(id: Int?, firstName: String?, lastName: String?, profilePic: String?, favorite: Bool?, url: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.favorite = favorite
        self.url = url
    }
}
