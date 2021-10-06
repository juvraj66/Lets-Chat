//
//  MessageContactDate.swift
//  ClosedLine
//
//  Created by Juvraj on 9/13/21.
//

import Foundation

class MessageContactDate {
    
    private var userID:String
    private var lastMessage:String
    private var lastMessageDate:String
    private var senderUserID:String
    private var lastMessageRead:Bool
    
    init(){
        userID = ""
        lastMessage = ""
        lastMessageDate = ""
        senderUserID = ""
        lastMessageRead = false
}
    init(userID: String,lastMessage:String,lastMessageDate:String,senderUserID:String,lastMessageRead:Bool){
        self.userID = userID
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.senderUserID = senderUserID
        self.lastMessageRead = lastMessageRead
}
    func setUserID(userID:String){
        self.userID = userID
    }
    func setLastMessage(lastMessage:String){
        self.lastMessage = lastMessage
    }
    func setLastMessageDate(lastMessageDate:String){
        self.lastMessageDate = lastMessageDate
    }
    func getUserID()->String{
        return userID
    }
    func getLastMessage()->String{
        return lastMessage
    }
    func getLastMessageDate()->String{
        return lastMessageDate
    }
    func getLastMessageRead()->Bool{
        return lastMessageRead
    }
    func getSenderID()->String{
        return senderUserID
    }

}
