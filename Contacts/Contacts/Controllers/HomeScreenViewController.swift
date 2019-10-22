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

    //MARK:- Custom Methods
    func getContacts() {
        self.view.activityStartAnimating()
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
                self.view.activityStopAnimating()
            case .failure(let error):
                switch error {
                case .internalServerError500:
                    self.alert(message: "Internal Server Error", title: "")
                case .notFound404:
                    self.alert(message: "Not Found", title: "")
                case .validationErrors422:
                    self.alert(message: "Validation Error", title: "")
                default:
                    self.alert(message: error.localizedDescription, title: "")
                }
                print(error.localizedDescription)
                self.view.activityStopAnimating()
            }
        }
    }
    
    func moveToContactDetailViewController(withContactID contactId : Int) {
        let contactDetailViewController : ContactDetailViewController = Constants.Screen.storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        contactDetailViewController.contactId = contactId
        self.navigationController?.pushViewController(contactDetailViewController, animated: true)
    }
    
    func moveToAddOrEditContactsViewController() {
        let addOrEditViewController : AddOrEditContactsViewController = Constants.Screen.storyboard.instantiateViewController(withIdentifier: "AddOrEditContactsViewController") as! AddOrEditContactsViewController
        self.navigationController?.pushViewController(addOrEditViewController, animated: true)
    }
    
    //MARK:- IBOutlet Methods
    @IBAction func didSelectAddButton(_ sender: Any) {
        moveToAddOrEditContactsViewController()
    }
    
}

extension HomeScreenViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionTitles[section]
        if let contactArray = contactDictionary[sectionKey] {
            return contactArray.count
        }
            
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        
        let sectionKey = sectionTitles[indexPath.section]
        if let contactArray = contactDictionary[sectionKey] {
            cell.configureCellUI(contact: contactArray[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionKey = sectionTitles[indexPath.section]
        if let contactArray = contactDictionary[sectionKey] {
            if let contactId = contactArray[indexPath.row].id {
                moveToContactDetailViewController(withContactID : contactId)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
}

