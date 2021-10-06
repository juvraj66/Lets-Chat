//
//  SignInViewController.swift
//  ClosedLine
//
//  Created by Juvraj on 3/9/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class SignInViewController: UIViewController {
    
    var authID = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     override func viewDidDisappear(_ animated: Bool) {
        
    }
    @IBAction func done(_ sender: UITextField){
        sender.resignFirstResponder()
    }
    
    @IBAction func signIn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { [self]
            (result,error) in
            if error != nil{
                self.errorLabel.text="Invalid Password or Email. Please Try Again"
                
            }
            else {
                self.errorLabel.text=""
                //Items.sharedInstance.
                authID = result!.user.uid
                print(authID, "userid0")
                Items.sharedInstance.authID = authID
                self.performSegue(withIdentifier: "mainApp1", sender: nil)
               print("Good")
            }
        }
    }
    @IBAction func signUp(_ sender: Any) {
        //performSegue(withIdentifier: "goSignUp", sender: nil)
    }
    
}
