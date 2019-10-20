//
//  HomeScreenViewController.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    var allContacts = [Contact?]()
    var sectionTitles = [String]()
    var contactDictionary = [String: [Contact]]()
    
    @IBOutlet weak var contactsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
        self.contactsTableView.tableFooterView = UIView()
    }

    func getContacts() {
        API.contacts.apiRequestData(method: .get, params: ["":""]) { (result : Result<[Contact], APIRestClient.APIServiceError>) in
            switch result {
            case .success(let contacts):
                self.allContacts = contacts.sorted{ $0.firstName!.lowercased() < $1.firstName!.lowercased() }
                
                
                for car in self.allContacts {
                    let carKey = String(car?.firstName?.prefix(1).uppercased() ?? "")
                    if var carValues = self.contactDictionary[carKey] {
                        carValues.append(car!)
                        self.contactDictionary[carKey] = carValues
                    } else {
                        self.contactDictionary[carKey] = [car!]
                    }
                }
                   
                self.sectionTitles = [String](self.contactDictionary.keys)
                self.sectionTitles = self.sectionTitles.sorted(by: { $0 < $1 })
                self.contactsTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func moveToContactDetail() {
        let contactDetailViewController : ContactDetailViewController = Constants.Screen.storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        self.navigationController?.pushViewController(contactDetailViewController, animated: true)
    }
    
    @IBAction func didSelectAddButton(_ sender: Any) {
        
        
    }
    
}

extension HomeScreenViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let carKey = sectionTitles[section]
        if let carValues = contactDictionary[carKey] {
            return carValues.count
        }
            
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        
        let carKey = sectionTitles[indexPath.section]
        if let carValues = contactDictionary[carKey] {
            cell.configureCellUI(contact: carValues[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToContactDetail()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
}

