//
//  ProfileViewController.swift
//  ClosedLine
//
//  Created by Juvraj on 3/11/21.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage
import FirebaseUI

import FirebaseAuth
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var authID = Items.sharedInstance.authID
    var contactObj = Contact()
    var ref: DatabaseReference!
    var arrayOfPersons:[Contact] = []
    var counter = 0
    var userKey = ""
    
    @IBOutlet var profileView: UIView!
    private let storage = Storage.storage().reference()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var pictureImageView: UIImageView!
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfile()
    }
    func loadProfile()->Void{
        ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value) {
            (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let uid = snap.childSnapshot(forPath: "UID").value as! String
                if(uid == self.authID){
                    self.userKey = snap.key
                    print(self.userKey,"user")
                    let firstName = snap.childSnapshot(forPath: "FirstName").value as! String
                    let lastName = snap.childSnapshot(forPath: "Last Name").value as! String
                    let bio = snap.childSnapshot(forPath: "Bio").value as! String
                    let picLink = snap.childSnapshot(forPath: "ProfilePictureLink").value as! String
                    self.contactObj.setUID(uID: uid)
                    self.contactObj.setFirstName(firstName: firstName)
                    self.contactObj.setLastName(lastName: lastName)
                    self.contactObj.setBio(bio: bio)
                    
                    var uid1 = self.userKey
                    uid1.remove(at: uid1.startIndex)
                    
                    Items.sharedInstance.userID = uid1
                    
                    Items.sharedInstance.currentUserName = firstName
                    print(picLink)
                    self.contactObj.setPicUrl(picUrl: picLink)
                    print("now \(self.contactObj.getPicUrl())")
                    self.nameLabel.text = firstName + " " + lastName
                    self.bioTextView.text = bio
                    print(self.contactObj.getBio())
                    if(picLink != ""){
                        let url = URL(string: picLink)
                        self.pictureImageView.sd_setImage(with: url)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // profileView.backgroundColor = UIColor(patternImage: UIImage(named: "qmnhnsky.jpeg")!)
        profileView.backgroundColor = UIColor.systemIndigo
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else{
            print("Error")
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler:{ data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.pictureImageView.image = image
            }
        })
        task.resume()
        
       }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
      let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else{
            return
        }
        guard let imageData = image.pngData() else{
            return 
        }
        storage.child(authID).child("pic\(self.counter).png").putData(imageData,metadata: nil, completion:{_, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            self.storage.child(self.authID).child("pic\(self.counter).png").downloadURL(completion:{ url, error in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteURL
                DispatchQueue.main.async {
                    self.pictureImageView.image = image
                }
                print("Download URL: \(urlString)")
                self.settingUrlToUsers(url0: urlString)
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
                    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    func settingUrlToUsers(url0:URL){
        ref = Database.database().reference()
        ref.child("Users").child(self.userKey).child("ProfilePictureLink").setValue(url0.absoluteString)
    }
  
}

