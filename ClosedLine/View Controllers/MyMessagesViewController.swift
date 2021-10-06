//
//  MessagesViewController.swift
//  ClosedLine
//
//  Created by Juvraj on 3/24/21.
//

import UIKit
// This is now a tableview controller and not a view controller.
import Firebase

class MyMessagesViewController:UITableViewController {
    
    @IBOutlet var messagesView: UITableView!
    var ref: DatabaseReference!
    var messageProfiles = [MessageContact]()
    var messageInfo = [MessageContactDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUserIDs {
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        messageProfiles.removeAll()
        messageInfo.removeAll()
        
    }
    func loadUserIDs(_ completion:@escaping () -> Void){
        let userID="-"+Items.sharedInstance.userID
        ref = Database.database().reference()
        ref.child("Messages").observeSingleEvent(of: .value) {
            (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                print(snap.key)
                let userID1 = snap.childSnapshot(forPath: "UserID1").value as! String
                let userID2 =  snap.childSnapshot(forPath: "UserID2").value as! String
                if userID1 == userID || userID2 == userID{
                    let lastMessage =  snap.childSnapshot(
                        forPath: "LastMessage").value as! String
                    let lastMessageDateString =  snap.childSnapshot(
                        forPath: "LastMessageDate").value as! String
                    
                    if userID1 != userID{
                 
                        let messageContactDateObj =
                            MessageContactDate(userID: userID1,lastMessage: lastMessage, lastMessageDate: lastMessageDateString)
                        self.messageInfo.append(messageContactDateObj)
                    }
                    else{
              
                        let messageContactDateObj =
                            MessageContactDate(userID: userID2,lastMessage: lastMessage, lastMessageDate: lastMessageDateString)
                        self.messageInfo.append(messageContactDateObj)
                    }
                    
                }
            }
            if(self.messageInfo.count != 0){
                self.loadContactInfo()
            }
        }
        completion()
        
    }
    
    func loadContactInfo()->Void{
        ref.child("Users").observeSingleEvent(of: .value) {
            (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let uid = snap.key
                for i in 0...self.messageInfo.count-1{
                    if self.messageInfo[i].getUserID()==uid{
                        print(uid)
                        let firstName = snap.childSnapshot(forPath: "FirstName").value as! String
                        let picLink = snap.childSnapshot(forPath: "ProfilePictureLink").value as! String
                        let lastMessageDateString =  self.messageInfo[i].getLastMessageDate()
                        
                        let messageContactObj = MessageContact(userID: uid,firstName: firstName,profilePicLink: picLink,lastMessage: self.messageInfo[i].getLastMessage(),lastMessageDate: lastMessageDateString)
                        self.messageProfiles.append(messageContactObj)
                    }
                }
            }
            sortMessagesByDate()
            self.messagesView.reloadData()
        }
    func sortMessagesByDate(){
        messageInfo = messageInfo.sorted(by: {
                $0.getLastMessageDate() > $1.getLastMessageDate() })
            
        messageProfiles = messageProfiles.sorted(by: {
                                $0.getLastMessageDate()
                                 > $1.getLastMessageDate() })
        
    }
        // If mintues less than <60 show mins on date.
    func dontShowHoursMins(date:String)->String{
        var dateToReplace = date
        let dateIndex = dateToReplace.firstIndex(of: " ")!
        dateToReplace.remove(at:dateIndex)
            //let dateWithoutHoursMins =  date[...String.12]
        return dateToReplace
    }
    
     
        
        
    }
    
    
            
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageProfiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesView.dequeueReusableCell(withIdentifier: "customCell3") as! CustomTableViewCell3
        //let person = messages[indexPath.row].
        let profile = messageProfiles[indexPath.row]
        let picUrl = URL(string: profile.picUrl0)
        var lastMessageDate = profile.getLastMessageDate()
        let dateIndex = lastMessageDate.firstIndex(of: " ")!
        lastMessageDate = String(lastMessageDate[...dateIndex])
        
        cell.personNameLabel.text = profile.firstName0
        cell.lastMessageLabel.text = profile.getLastMessage()
        cell.lastMessageDateLabel.text = lastMessageDate
        cell.profilePic.sd_setImage(with: picUrl)
    
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the name for the cell that is tabbed.
        print(messageProfiles[indexPath.row].getLastMessage())
        Items.sharedInstance.otherUserID = messageProfiles[indexPath.row].getUID()
        Items.sharedInstance.otherUserName = messageProfiles[indexPath.row].getFirstName()
        performSegue(withIdentifier: "Messenger", sender: nil)
    }
}
extension Date {

    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format

        return formatter.string(from: yourDate!)
    }
}
