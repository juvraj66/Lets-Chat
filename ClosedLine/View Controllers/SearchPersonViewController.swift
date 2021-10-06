//
//  Test.swift
//  ClosedLine
//
//  Created by Juvraj on 8/6/21.

import UIKit
import Firebase

class SearchPersonViewController: UITableViewController, UISearchBarDelegate {

    var fixedSize = 0 // At max my array should load 20 people for speed.
    var counterID = 0
    var users:[User] = []
    var ref: DatabaseReference!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var personView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //print(Items.sharedInstance.authID)
        counterID = Items.sharedInstance.counterID
    }
    
    @IBAction func goToContacts(_ sender: Any) {
        performSegue(withIdentifier: "contacts", sender: nil)
    }
    
    func searchPersons(searchText:String, _ completion:@escaping () -> Void){
        users.removeAll()
        ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value) {
            (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let userID = snap.key
                let email = snap.childSnapshot(forPath: "Email").value as! String
                if email.contains(searchText) && self.users.count<19{// Make sure not more than 20 elements because that will slow amount of data feteched.
                    let picLink = snap.childSnapshot(forPath: "ProfilePictureLink").value as! String
                    let userObj = User(userID:userID,email: email, picUrl: picLink, addedUser: false)
                    self.users.append(userObj)
                    self.fixedSize = self.fixedSize + 1
                }
                
            }
            if self.users.count > 0{
                self.checkIfAdded()
            }
            self.personView.reloadData()
        }
        completion()
    }
    // users is added when search.
    func checkIfAdded()->Void{
        let tempContactsInfo = Items.sharedInstance.contactsInfo
        let userID = "-"+Items.sharedInstance.userID
        print(userID)
        if tempContactsInfo.count==0 {
            for i in 0...users.count-1{
                if users[i].getUserID() == userID{
                    users[i].setAddedUser(addUser: true)
                }
            }
            return
        }
        for i in 0...tempContactsInfo.count-1{
            for j in 0...users.count-1{
                if tempContactsInfo[i].getUID()==users[j].getUserID() ||
                    users[j].getUserID() == userID
                    {
                    users[j].setAddedUser(addUser: true)
                }
            }
        }
    }
    
    func addUser(contactID:String)->Void{
        ref = Database.database().reference()
        let userID = Items.sharedInstance.userID
        counterID = counterID + 1
        let stringCounterID = String(counterID)
        print(counterID)
        ref.child("Contacts").child(userID).updateChildValues(
            ["ContactID\(counterID)" : contactID,"CounterID" : stringCounterID])
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personView.dequeueReusableCell(withIdentifier: "customCell2") as! CustomTableViewCell2
        let person = users[indexPath.row]
        let picUrl = URL(string: person.picUrl0)
        let checkIfAdded = person.getAddedUser()
    
        cell.personNameLabel.text = person.email0
        cell.profilePic.sd_setImage(with: picUrl)
        cell.addButton.tag = indexPath.row
        if checkIfAdded == true{
            cell.addButton.setTitle("Added", for: .normal)
        }
        cell.addButton.addTarget(self,action: #selector(addToButton) , for:.touchUpInside)
        return cell
    }
    
    @objc func addToButton(sender:UIButton){
        let indexpath1 = IndexPath(row:sender.tag,section: 0)
        let user = users[indexpath1.row]
        let buttonText = sender.currentTitle
        if buttonText == "Add"{ // This make sure user is added only once.
            addUser(contactID: user.userID)
            sender.setTitle("Added", for: .normal)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchPersons(searchText:searchText) {
        }
    }
    

}

