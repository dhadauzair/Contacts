//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Uzair Dhada on 19/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailViewController: UIViewController {

    var contactId : Int?
    var contactDetail : ContactDetail?
    var numberOfRow = 0
    @IBOutlet weak var gradientSuperView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactDetailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationUI()
        let whiteCGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        let greenCGColor = #colorLiteral(red: 0.3607843137, green: 0.9019607843, blue: 0.8039215686, alpha: 0.2).cgColor
        gradientSuperView.setGradient(colors: [whiteCGColor,greenCGColor])
        getContactDetail()
        self.contactDetailTableView.tableFooterView = UIView()
        contactImageView.setborderWithWidth(width: 2.0)
        contactImageView.setBorderColor(color: UIColor.white.cgColor)
    }
    
    //MARK:- Custom Methods
    func configureUI() {
        if let contact = self.contactDetail {
            if let firstName = contact.firstName, let lastName = contact.lastName {
                contactNameLabel.text = firstName + " " + lastName
            }
            
            if let isContactFav = contact.favorite {
                if isContactFav {
                    favouriteButton.imageView?.image = #imageLiteral(resourceName: "favourite_button_selected")
                } else {
                    favouriteButton.imageView?.image = #imageLiteral(resourceName: "favourite_button")
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
    
    
    func setNavigationUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 0.8470588235)
    }
    
    func getContactDetail() {
        if let contactId = contactId {
            self.view.activityStartAnimating()
            API.detailContact.apiRequestData(method: .get, params: [ConstantStrings.contactID.rawValue:"\(contactId)"]) { (result : Result<ContactDetail, APIRestClient.APIServiceError>) in
                switch result {
                case .success(let contactDetail):
                    print(contactDetail)
                    self.contactDetail = contactDetail
                    self.configureUI()
                    self.numberOfRow = 2
                    self.contactDetailTableView.reloadData()
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
    }
    
    func sendMessage() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            
            guard let recipientNumber = contactDetail?.phoneNumber else { return }
            
            controller.recipients = [recipientNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func makePhoneCall(phoneNumber: String) {

        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func sendEmail() {
        if (MFMailComposeViewController.canSendMail()) {
            if let email = contactDetail?.email {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients([email])
                self.present(composeVC, animated: true, completion: nil)
            }
        }
    }

    //MARK:- IBOutlets Methods
    @IBAction func didSelectMessageButton(_ sender: Any) {
        sendMessage()
    }
    
    @IBAction func didSelectCallButton(_ sender: Any) {
        if let phoneNumber = contactDetail?.phoneNumber {
            makePhoneCall(phoneNumber: phoneNumber)
        }
    }
    
    @IBAction func didSelectEmailButton(_ sender: Any) {
        sendEmail()
    }
    
    @IBAction func didSelectFavouriteButton(_ sender: Any) {
    }
    
    @IBAction func didSelectEditButton(_ sender: Any) {
        let addOrEditViewController : AddOrEditContactsViewController = Constants.Screen.storyboard.instantiateViewController(withIdentifier: "AddOrEditContactsViewController") as! AddOrEditContactsViewController
        if let contactDetail = self.contactDetail {
            addOrEditViewController.contactDetail = contactDetail
        }
        self.navigationController?.pushViewController(addOrEditViewController, animated: true)
    }
    
    
}

extension ContactDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ContactDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.identifier, for: indexPath) as! ContactDetailTableViewCell

        if let contact = contactDetail {
            cell.configureCellUI(contact: contact, forRow: indexPath.row)
        }

        return cell
    }

}

extension ContactDetailViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
