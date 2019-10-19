//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationUI()
    }
    

    func setNavigationUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

}
