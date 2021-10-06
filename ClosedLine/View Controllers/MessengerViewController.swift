import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

struct Sender:SenderType{
    var senderId: String
    var displayName: String
    
}
struct Message:MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind

}

class MessengerViewController: MessagesViewController, MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    // If the there is chat when user sends first message create a unqiuechatid and send message.
    var ref: DatabaseReference!
    var messageCounterID = 0
    var messageCounterID2 = 0
    var chatID = String()
    
    let currentUser = Sender(senderId: "-"+Items.sharedInstance.userID,
                             displayName: Items.sharedInstance.currentUserName)
    let otherUser = Sender(senderId:Items.sharedInstance.otherUserID, displayName: Items.sharedInstance.otherUserName)
    var arrOfDics = [NSDictionary]()
    let dateFormatter = DateFormatter()

    var messages = [MessageType]()
    var tempMessages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.reloadData()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        title = Items.sharedInstance.otherUserName
        loadChatID {
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messageInputBar.inputView?.becomeFirstResponder()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        print("dis")
       
        
    }
    func currentSender() -> SenderType {
        return currentUser
    }
    func loadChatID(_ completion:@escaping () -> Void){
        print(chatID,"loadchaid")
        let userID01 = currentUser.senderId
        let userID02 = Items.sharedInstance.otherUserID
        ref = Database.database().reference()
        ref.child("Messages").observeSingleEvent(of: .value) {
            (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
            let userID1 = snap.childSnapshot(forPath: "UserID1").value as! String
            let userID2 =  snap.childSnapshot(forPath: "UserID2").value as! String
            if userID1 == userID01 && userID2 == userID02 ||
                userID1 == userID02 && userID2 == userID01 {
                self.chatID = snap.key
                break
                }
            }
            self.messageListener {
            }
        }
    }
    func loadMessages(_ completion:@escaping () -> Void){
        let userID01 = currentUser.senderId
        let userID02 = Items.sharedInstance.otherUserID
        ref = Database.database().reference()
        ref.child("Messages").observeSingleEvent(of: .value) {
            (snapshot) in
            self.tempMessages.removeAll()
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
               
                let userID1 = snap.childSnapshot(forPath: "UserID1").value as! String
                let userID2 =  snap.childSnapshot(forPath: "UserID2").value as! String
                if userID1 == userID01 && userID2 == userID02 ||
                    userID1 == userID02 && userID2 == userID01 {
                    let CounterID =
                        snap.childSnapshot(forPath: "MessageCounterID").value as! String
                    self.messageCounterID = Int(CounterID) ?? 0
                    Items.sharedInstance.messageCounterID = self.messageCounterID
                    
                    for i in 1...self.messageCounterID{
                        print(i)
                        let value = snap.childSnapshot(forPath: "Message\(i)").value as? NSDictionary
                        let message = value?.value(forKey: "Message") as! String
                        let sender = value?.value(forKey: "Sender") as! String
                        let receiver = value?.value(forKey: "Receiver") as! String
                        let timestampString = value?.value(forKey: "Timestamp") as? String ?? ""
                        print(timestampString)
                        
                        self.dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
                        let date = self.dateFormatter.date (from: timestampString)
                       
                        print(sender)
                        if sender == Items.sharedInstance.otherUserID{
                            self.tempMessages.append(
                                Message(sender: self.otherUser,
                                        messageId:"Message\(i)", sentDate: date ?? Date(), kind: .text(message)))
                            
                        }
                        else{
                            self.tempMessages.append(
                                Message(sender: self.currentUser,
                                        messageId:"Message\(i)", sentDate: date ?? Date(), kind: .text(message)))
                        }
                    }
                }
            }
            self.messages = self.tempMessages
            print(self.messages.count,"messco")
            self.messagesCollectionView.reloadData()
        }
    }
   
    func messageListener(_ completion:@escaping () -> Void){
        ref = Database.database().reference()
        if chatID != ""{
            ref.child("Messages").child(chatID).observe(.value, with: { (snapshot) in
                print("change")
                self.loadMessages {
                }
            })
        }
    }
    
    func sendMessage(message:String){
        ref = Database.database().reference()
        if chatID != ""{
            let userID = currentUser.senderId
            Items.sharedInstance.messageCounterID = messageCounterID
            messageCounterID = messageCounterID + 1
            let currentDate = Date().toString(withFormat: "MM-dd-yyyy HH:mm")
            let stringMessageCounterID = String(messageCounterID)
            print(messageCounterID)
            ref.child("Messages").child(chatID).updateChildValues(
                ["LastMessage" : message,"LastMessageDate" : currentDate,
                 "MessageCounterID":stringMessageCounterID] )
            //setValue
            ref.child("Messages").child(chatID).child("Message\(messageCounterID)").setValue(
                ["Message" : message,"Sender" : userID,
                 "Receiver":otherUser.displayName, "Timestamp":currentDate] )
        
        }
        
        else{
            let user1 = currentUser.senderId
            let user2 = otherUser.senderId
            Items.sharedInstance.messageCounterID = messageCounterID
            messageCounterID = messageCounterID + 1
            let currentDate = Date().toString(withFormat: "MM-dd-yyyy HH:mm")
            let stringMessageCounterID = String(messageCounterID)
            print(messageCounterID)
            

            chatID = (ref.child("Messages").childByAutoId().key ?? "") as String
            ref.child("Messages").child(chatID).updateChildValues(
                ["LastMessage" : message,"LastMessageDate" : currentDate,
                 "MessageCounterID":stringMessageCounterID, "UserID1":user1,
                 "UserID2":user2
                ] )
            
            ref.child("Messages").child(chatID).child("Message\(messageCounterID)").setValue(
                    ["Message" : message,"Sender" : user1,
                     "Receiver":otherUser.displayName, "Timestamp":currentDate] )
            
            messageListener {
                
            }
           
            
            //1.First loadchatID
            //2. messlisner
            //3. load messages
            //childByAutoId()
            // Create message id in messages.
            
        }
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

  
    
   
}
extension MessengerViewController:InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
       
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty
        else{
            return
        }
        // Send message add to database.
        //
        sendMessage(message: text)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
        print(text)
        //print(messages[messages.count-1].kind)
        // Then make sure the text in the text view is blank for more messages.
        messageInputBar.inputTextView.text = ""
        
        
    }
}
