//
//  StatusViewController.swift
//  ClosedLine
//
//  Created by Juvraj on 9/28/21.
//

import UIKit
import Firebase
class StatusViewController: UIViewController {
    
    @IBOutlet private weak var statusTextField: UITextField!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setNewStatus(_ sender: Any) {
        ref = Database.database().reference()
        let userID = "-"+Items.sharedInstance.getUserID()
        let status = statusTextField.text!
        let statusSpaces = status.trimmingCharacters(in: .whitespaces)
        let firstName = firstNameTextField.text!
        let firstNameSpaces = firstName.trimmingCharacters(in: .whitespaces)
        let lastName = lastNameTextField.text!
        let lastNameSpaces = lastName.trimmingCharacters(in: .whitespaces)
        
        if status != "" && statusSpaces != ""{
            ref.child("Users").child(userID).updateChildValues(["Bio":status])
        }
        if firstName != "" && firstNameSpaces != ""{
            ref.child("Users").child(userID).updateChildValues(["FirstName":firstName])
        }
        if lastName != "" && lastNameSpaces != ""{
            ref.child("Users").child(userID).updateChildValues(["Last Name":lastName])
        }
        
        performSegue(withIdentifier: "tabBarMenu", sender: nil)
    }
       
}
