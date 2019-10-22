//
//  ContactsModel.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import Foundation

class Contact: Codable {
    var id: Int?
    var firstName, lastName: String?
    var profilePic: String?
    var favorite: Bool?
    var url: String?
//    var email, phoneNumber: String?
//    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite, url
//        case email
//        case phoneNumber = "phone_number"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
    }
    
    init() {
        self.id = 0
        self.firstName = ""
        self.lastName = ""
//        self.email = ""
//        self.phoneNumber = ""
        self.profilePic = ""
        self.favorite = false
//        self.createdAt = ""
//        self.updatedAt = ""
        self.url = ""
    }

    init(id: Int?, firstName: String?, lastName: String?, /*email: String?, phoneNumber: String?,*/ profilePic: String?, favorite: Bool?/*, createdAt: String?, updatedAt: String?*/, url: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
//        self.email = email
//        self.phoneNumber = phoneNumber
        self.profilePic = profilePic
        self.favorite = favorite
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
        self.url = url
    }
}

class ContactDetail: Contact {
    var email, phoneNumber: String?
    var createdAt, updatedAt: String?

    enum CodingKeys2: String, CodingKey {
        case email
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    override init() {
        super.init()
        email = ""
        phoneNumber = ""
        createdAt = ""
        updatedAt = ""
    }

    init(id: Int?, firstName: String?, lastName: String?, email: String?, phoneNumber: String?, profilePic: String?, favorite: Bool?, createdAt: String?, updatedAt: String?) {
        super.init(id: id, firstName: firstName, lastName: lastName, profilePic: profilePic, favorite: favorite, url: nil)
        self.email = email
        self.phoneNumber = phoneNumber
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.email = try container.decode(String.self, forKey: .email)
//        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
//        self.createdAt = try container.decode(String.self, forKey: .createdAt)
//        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        
        let container = try decoder.container(keyedBy: CodingKeys2.self)
        self.email = try container.decodeIfPresent(String.self, forKey: CodingKeys2.email)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: CodingKeys2.phoneNumber)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: CodingKeys2.createdAt)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: CodingKeys2.updatedAt)
        
        try super.init(from: decoder)
    }

}
