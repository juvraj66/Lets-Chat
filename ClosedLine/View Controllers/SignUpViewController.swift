//
//  SignUpTableViewController.swift
//  ClosedLine
//
//  Created by Juvraj on 3/5/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    var ref: DatabaseReference!
        
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
  
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func done ( _ sender: UITextField ){
        
        //  Hides keyboard when return or done is pressed.
        sender.resignFirstResponder()
    
    }
    
    func validFields(_ email:String, _ pass:String,_ firstName:String, _ lastName:String )->String{
        if pass.count <= 7{
            return "Password needs to be 8 characters or more."
        }
        else if email == "" || pass == "" || firstName == "" || lastName == "" {
            return "Please fill in all fields"
        }
         return ""
    }

    @IBAction func signUp(_ sender: Any) {
        
        let email = emailTextField.text!
        let password1 = passwordTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        
        let error = validFields(email,password1,firstName,lastName)
        if error != ""{
          print(error)
            errorLabel.text = error
        }
        else{
            Auth.auth().createUser(withEmail: email, password: password1)
            { (result,err) in
                if (err != nil){
                    print("Error user could not be created")
            }
                else{
                    self.ref = Database.database().reference()
                    self.ref.child("Users").childByAutoId().setValue(
                    ["UID" : result!.user.uid, "FirstName" : firstName,
                     "Last Name" : lastName, "Bio":"", "ProfilePictureLink":"",
                     "Email":email
                    ])
                    print("User Created")
                    self.performSegue(withIdentifier: "signUpComplete", sender: nil)
                    
                }
            }
            
        }
        
    }
  
}
  


