//
//  AddOrEditContactsViewController.swift
//  Contacts
//
//  Created by Uzair Dhada on 20/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit
import AVFoundation

class AddOrEditContactsViewController: UIViewController {
    
    var contactDetail : ContactDetail = ContactDetail()
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var gradientSuperView: UIView!
    @IBOutlet weak var contactDetailTableView: UITableView!
    @IBOutlet weak var contactImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationUI()
        let whiteCGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        let greenCGColor = #colorLiteral(red: 0.3607843137, green: 0.9019607843, blue: 0.8039215686, alpha: 0.2).cgColor
        gradientSuperView.setGradient(colors: [whiteCGColor,greenCGColor])
        self.contactDetailTableView.tableFooterView = UIView()
        contactImageView.setborderWithWidth(width: 2.0)
        contactImageView.setBorderColor(color: UIColor.white.cgColor)
    }
    
    //MARK:- IBOutlets Methods
    func setNavigationUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 0.8470588235)
    }
    
    //MARK:- IBOutlets Methods
    @IBAction func didSelectCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSelectCameraButton(_ sender: Any) {
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        let selectSourceAlert = UIAlertController.init(title:nil, message:nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction.init(title:ConstantStrings.Gallery.rawValue, style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                self.imagePickerController.sourceType = .photoLibrary
            }else{
                self.imagePickerController.sourceType = .savedPhotosAlbum
            }
            
            self.present(self.imagePickerController, animated: true, completion: {
                
            })
        }
        let cameraAction = UIAlertAction.init(title:ConstantStrings.Camera.rawValue, style: .default) { (action) in
            
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                    
                    self.imagePickerController.sourceType = .camera
                    
                    self.present(self.imagePickerController, animated: true, completion: {
                        
                    })
                    
                }else{
                    print("Your device has no camera")
                }
                
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                            
                            self.imagePickerController.sourceType = .camera
                            
                            self.present(self.imagePickerController, animated: true, completion: {
                                
                            })
                            
                        }else{
                            print("Your device has no camera")
                        }
                    } else {
                        print("Access denied")
                    }
                })
            }
        }
        
        let removeAction = UIAlertAction.init(title:  ConstantStrings.Remove.rawValue, style: .destructive) { (action) in
            self.contactImageView.image = #imageLiteral(resourceName: "placeholder_photo")
        }
        
        let cancelAction = UIAlertAction.init(title:  ConstantStrings.Cancel.rawValue, style: .cancel) { (action) in
            print("cancelled")
            
        }
        
        selectSourceAlert.addAction(galleryAction)
        selectSourceAlert.addAction(cameraAction)
        selectSourceAlert.addAction(removeAction)
        selectSourceAlert.addAction(cancelAction)
        
        self.present(selectSourceAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func didSelectDoneButton(_ sender: Any) {
        self.view.endEditing(true)
        guard contactDetail.phoneNumber?.isPhoneNumber ?? false else {
            self.alert(message: ConstantStrings.invalidPhoneNumber.rawValue, title: "")
            return
        }
        
        guard contactDetail.email?.isValidEmail ?? false else {
            self.alert(message: ConstantStrings.invalidEmailAddress.rawValue, title: "")
            return
        }
        let date = Date()
        let param = [/*"id": 1,*/
            "first_name": contactDetail.firstName ?? "",
            "last_name": contactDetail.lastName ?? "",
            "email": contactDetail.email ?? "",
            "phone_number": contactDetail.phoneNumber ?? "",
            "profile_pic": "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/007/original/ab.jpg?1464516610",
            "favorite": contactDetail.favorite ?? false,
            "created_at": date.stringFromDate(date: date),
            "updated_at": date.stringFromDate(date: date)] as [String : Any]
        API.contacts.apiRequestData(method: .post, params: param) { (result : Result<[Contact], APIRestClient.APIServiceError>) in
            switch result {
            case .success(let status):
                print(status)
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

extension AddOrEditContactsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AddOrEditTableViewCell = tableView.dequeueReusableCell(withIdentifier: AddOrEditTableViewCell.identifier, for: indexPath) as! AddOrEditTableViewCell

        cell.configureCell(WithContactDetail: contactDetail, ForRow: indexPath.row)
        cell.delegate = self
        
        return cell
    }
}

extension AddOrEditContactsViewController : ParentControllerDelegate {
    func notifyParentControllerModelFavouriteChanged(contactDetail: ContactDetail) {
        
    }
    
    func notifyParentController(ForText text: String, withTag tag: Int) {
        switch tag {
        case 0:
            contactDetail.firstName = text
        case 1:
            contactDetail.lastName = text
        case 2:
            contactDetail.phoneNumber = text
        case 3:
            contactDetail.email = text
        default: break
        }
    }
}

extension AddOrEditContactsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        contactImageView.image = newImage
        
        dismiss(animated: true)
    }
}
