//
//  HomeScreenViewController.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAllContacts()
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }

    func getAllContacts() {
        API.contacts.apiRequestData(method: .get, params: ["":""]) { (result : Result<[Contact], APIRestClient.APIServiceError>) in
            switch result {
            case .success(let contacts):
                for singleContact in contacts {
                    print(singleContact.firstName ?? "")
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

