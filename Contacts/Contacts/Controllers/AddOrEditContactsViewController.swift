//
//  AddOrEditContactsViewController.swift
//  Contacts
//
//  Created by Uzair Dhada on 20/10/19.
//  Copyright © 2019 Go Jek. All rights reserved.
//

import UIKit

class AddOrEditContactsViewController: UIViewController {
    
    @IBOutlet weak var gradientSuperView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationUI()
        let whiteCGColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        let greenCGColor = #colorLiteral(red: 0.3607843137, green: 0.9019607843, blue: 0.8039215686, alpha: 0.2).cgColor
        gradientSuperView.setGradient(colors: [whiteCGColor,greenCGColor])
    }
    
    func setNavigationUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 0.8470588235)
    }
    
    @IBAction func didSelectCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
