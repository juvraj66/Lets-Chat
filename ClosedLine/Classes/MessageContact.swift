//
//  MessageContact.swift
//  ClosedLine
//
//  Created by Juvraj on 9/7/21.
//

import Foundation

class MessageContact:Contact{
    //users=  Need user id, First name, Profile pic,
    private var lastMessage = ""
    private var lastMessageDate = ""
    private var lastMessageRead = false
    
    
    
    //Might not need overide init
    override init(){
        super.init()
        lastMessage = ""
        lastMessageDate = ""
        lastMessageRead = false
    }
    
    init(userID: String, firstName: String,profilePicLink:String,lastMessage:String,lastMessageDate:String,lastMessageRead:Bool){
        super.init(uID: userID, firstName: firstName, picUrl: profilePicLink)
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.lastMessageRead = lastMessageRead
    }
    
    func setLastMessage(lastMessage:String){
        self.lastMessage = lastMessage
    }
    func setLastMessageDate(lastMessageDate:String){
        self.lastMessageDate = lastMessageDate
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
    

  
    
}
