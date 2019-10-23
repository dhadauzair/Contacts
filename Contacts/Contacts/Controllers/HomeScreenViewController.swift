//
//  HomeScreenViewController.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    var allContacts = [Contact]()
    var sectionTitles = [String]()
    var contactDictionary = [String: [Contact]]()
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshContactsTableView), for: .valueChanged)
        return refreshControl
    }()
    
    @IBOutlet weak var contactsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
        self.contactsTableView.tableFooterView = UIView()
        contactsTableView.addSubview(refreshControl)
    }

    //MARK:- Custom Methods
    func getContacts() {
        self.view.activityStartAnimating()
        API.contacts.apiRequestData(method: .get, params: ["":""]) { (result : Result<[Contact], APIRestClient.APIServiceError>) in
            switch result {
            case .success(let contacts):
                self.allContacts = contacts.sorted{ $0.firstName!.lowercased() < $1.firstName!.lowercased() }
                self.populateUI()
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
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func populateUI()  {
        
        for singleContact in self.allContacts {
            let prefix = String(singleContact.firstName?.prefix(1).uppercased() ?? "")
            if var carValues = self.contactDictionary[prefix] {
                carValues.append(singleContact)
                self.contactDictionary[prefix] = carValues
            } else {
                self.contactDictionary[prefix] = [singleContact]
            }
        }
           
        self.sectionTitles = [String](self.contactDictionary.keys)
        self.sectionTitles = self.sectionTitles.sorted(by: { $0 < $1 })
        self.contactsTableView.reloadData()
        self.view.activityStopAnimating()
        self.refreshControl.endRefreshing()
    }
    
    func moveToContactDetailViewController(withContactID contactId : Int) {
        let contactDetailViewController : ContactDetailViewController = Constants.Screen.storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        contactDetailViewController.contactId = contactId
        contactDetailViewController.delegate = self
        self.navigationController?.pushViewController(contactDetailViewController, animated: true)
    }
    
    func moveToAddOrEditContactsViewController() {
        let addOrEditViewController : AddOrEditContactsViewController = Constants.Screen.storyboard.instantiateViewController(withIdentifier: "AddOrEditContactsViewController") as! AddOrEditContactsViewController
        addOrEditViewController.delegate = self
        self.navigationController?.pushViewController(addOrEditViewController, animated: true)
    }
    
    @objc func refreshContactsTableView() {
        refreshControl.beginRefreshing()
        getContacts()
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

extension HomeScreenViewController : ParentControllerDelegate {
    func notifyParentControllerIfContactIsSuccessfulltAddedOrEdited(isContactEdited: Bool, with contactDetail: ContactDetail) {
        if isContactEdited {
            self.alert(message: "Contact Editd", title: "")
            self.allContacts.removeAll(where: { $0.id  == contactDetail.id })
        } else {
            self.alert(message: "Contact Added", title: "")
        }
        let contact = Contact(id: contactDetail.id, firstName: contactDetail.firstName, lastName: contactDetail.lastName, profilePic: contactDetail.profilePic, favorite: contactDetail.favorite, url: contactDetail.url)
        var allContacts = self.allContacts
        allContacts.append(contact)
        self.allContacts.removeAll()
        self.allContacts = allContacts.sorted{ $0.firstName!.lowercased() < $1.firstName!.lowercased() }
        self.populateUI()
    }
    
    func notifyParentController(ForText text: String, withTag tag: Int) {
        
    }
    
    func notifyParentControllerModelFavouriteChanged(contactDetail: ContactDetail) {
        self.allContacts.filter({ $0.id == contactDetail.id }).first?.favorite = contactDetail.favorite
        self.populateUI()
    }
}

