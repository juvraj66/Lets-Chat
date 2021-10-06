//
//  ContactsViewController.swift
//  ClosedLine
//
//  Created by Juvraj on 6/7/21.
//

import UIKit
import Firebase

class ContactsViewController: UIViewController {

   
     // When swtiching tabs viewdidload does not occur
    @IBOutlet weak var friendView: UITableView!
    // Need to get userid from login in screen and set to userID
    var contactIDDic:Dictionary<String, String>=[:]
    var ref: DatabaseReference!
    var contactsInfo:[Contact] = []
    var contactIDsName = [ContactIDsName]()
    
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("freinds")
        getContactIds {
            print(self.contactIDsName.count,"guu")
            print("Kor")
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        contactIDDic.removeAll()
        contactsInfo.removeAll()
        contactIDsName.removeAll()
        
    }
    override func viewDidLoad() {
        friendView.delegate = self
        friendView.dataSource = self
        friendView.reloadData()

    }
    
    
    
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "searchPerson", sender: nil)
    }
    
    func getContactIds(_ completion:@escaping () -> Void){
        ref = Database.database().reference()
        let userID = Items.sharedInstance.userID
     
        ref.child("Contacts").child(userID).observeSingleEvent(of: .value) {
            (snapshot) in
            let value = snapshot.value as? NSDictionary
           
            if value == nil{
                Items.sharedInstance.counterID = 0
                return
            }
            self.contactIDDic = value as! Dictionary<String, String>
            // Convert dictory data to array and save in contactUserIDs array.
            self.findCounterID() // Deletes counterId from dic n saves it in item var.
            
            let contactsCounterIDs =  Array(self.contactIDDic.keys)
            let contactUserIDs = Array(self.contactIDDic.values)
            if(contactsCounterIDs.count != 0  && contactUserIDs.count != 0 ){
                self.loadDataInContactIDName(contactIDs: contactsCounterIDs,
                                         userIDs: contactUserIDs)
                self.getContactInfo()
            }
           
        }
        completion()
    }
    
    func getContactInfo()->Void{
        if contactIDsName.count == 0{ // Make sure the user has contacts.
            return
        }
        ref.child("Users").observeSingleEvent(of: .value) {
            (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let uid = snap.key
                for i in 0...self.contactIDsName.count-1{
                    if self.contactIDsName[i].getUserID()==uid{
                        print(uid)
                        let firstName = snap.childSnapshot(forPath: "FirstName").value as! String
                        let lastName = snap.childSnapshot(forPath: "Last Name").value as! String
                        let bio = snap.childSnapshot(forPath: "Bio").value as! String
                        let picLink = snap.childSnapshot(forPath: "ProfilePictureLink").value as! String
                        let cObj = Contact(uID: uid,firstName: firstName,lastName: lastName,bio: bio,picUrl: picLink)
                               self.contactsInfo.append(cObj)
                               print(firstName)
                           }
                       }
                   }
          
            self.loadFirstNameInContactIDName()
            self.sortNamesAlphabetically()
            Items.sharedInstance.contactsInfo = self.contactsInfo
            self.friendView.reloadData()
        }
    
    }
    
    func findCounterID()->Void{
        if contactIDDic["CounterID"] == nil{
            Items.sharedInstance.counterID = 0
            return
        }
        let counterID = Int(contactIDDic["CounterID"]!) ?? 0
            if counterID != 0{
                Items.sharedInstance.counterID = counterID
                contactIDDic["CounterID"] = nil
                return
            }
    }
 
    func loadDataInContactIDName(contactIDs:[String], userIDs:[String]){
        for i in 0...contactIDs.count-1{
            let contactIDsNameObj = ContactIDsName(contactID: contactIDs[i],
                                                   userID: userIDs[i])
            contactIDsName.append(contactIDsNameObj)
            
        }
    }
    func loadFirstNameInContactIDName(){
        let tempArr1 = contactsInfo.sorted(by: { $0.getUID() < $1.getUID() })
        contactIDsName = contactIDsName.sorted(by: { $0.getUserID() < $1.getUserID() })
        for i in 0...contactIDsName.count-1{
            if tempArr1[i].getUID() == contactIDsName[i].getUserID(){
                contactIDsName[i].setContactFirstName(
                    firstName: tempArr1[i].getFirstName()
                )
            }
        }
    }
    func sortNamesAlphabetically(){
        contactsInfo = contactsInfo.sorted(by: {
                                            $0.getFirstName() < $1.getFirstName() })
        contactIDsName = contactIDsName.sorted(by: {
                                                $0.getContactFirstName()
                                                < $1.getContactFirstName() })
        for i in 0...contactsInfo.count-1{
            print(contactsInfo[i].getFirstName(),"ContactsInfo")
            print(contactIDsName[i].getContactFirstName(),"contactIDsName")
        }
    }
    func deleteContact(index:Int)->Void{
        let contactCounterKey = contactIDsName[index].getContactID()
        ref = Database.database().reference()
        let userID = Items.sharedInstance.userID
        ref.child("Contacts").child(userID).child(contactCounterKey).setValue(nil)
        
    }
    
}


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsInfo.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            print(indexPath.row,"delted")
            
            deleteContact(index: indexPath.row)
            contactsInfo.remove(at: indexPath.row)
            contactIDsName.remove(at: indexPath.row)
            Items.sharedInstance.contactsInfo.remove(at: indexPath.row)
            friendView.reloadData()
        }

    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        let friend = contactsInfo[indexPath.row]
        let picUrl = URL(string: friend.picUrl0)
        cell.nameLabel.text = friend.firstName0
        cell.statusLabel.text = friend.bio0
        cell.profilePic.sd_setImage(with: picUrl)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MessengerContact
        Items.sharedInstance.otherUserID = contactsInfo[indexPath.row].getUID()
        Items.sharedInstance.otherUserName = contactsInfo[indexPath.row].getFirstName()
        performSegue(withIdentifier: "MessengerContact", sender: nil)
    }

}
