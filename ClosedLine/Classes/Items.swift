//
//  Items.swift
//  ClosedLine
//
//  Created by Juvraj on 3/13/21.
//

import Foundation

class Items {
    
    // This class lets me share data between view controllers.
    static let sharedInstance = Items()
    private var  authID = String()
    private var userID = String()
    private var contactsInfo = [Contact]()
    private var counterID = Int()
    
    private var messageCounterID = Int()
    private var currentUserName = String()
    private var otherUserName = String()
    private var otherUserID = String()
    private var senderID = String()
    
    private var switchTab = Bool()
   
    func setAuthID(authID:String){
        self.authID = authID
    }
    func setUserID(userID:String){
        self.userID = userID
    }
    func setContactsInfo(arr:[Contact]){
        contactsInfo = arr
    }
    func setCounterID(counterID:Int){
        self.counterID = counterID
    }
    func setMessageCounterID(messageCounterID:Int){
        self.messageCounterID = messageCounterID
    }
    func setCurrentUserName(currentUserName:String){
        self.currentUserName = currentUserName
    }
    func setOtherUserName(otherUserName:String){
        self.otherUserName = otherUserName
    }
    func setOtherUserID(otherUserID:String){
        self.otherUserID = otherUserID
    }
    func setSenderID(senderID:String){
        self.senderID = senderID
    }
    func setSwitchTab(value:Bool){
        switchTab = value
    }
    
    func getUserID()->String{
        return userID
    }
    func getAuthID()->String{
        return authID
    }
    func getContactsInfo()->[Contact]{
        return contactsInfo
    }
    func removeContactsInfoAt(index:Int){
        contactsInfo.remove(at: index)
    }
    func getCounterID()->Int{
        return counterID
    }
    func getMessageCounterID()->Int{
        return messageCounterID
    }
    func getCurrentUserName()->String{
        return currentUserName
    }
    func getOtherUserName()->String{
        return otherUserName
    }
    func getOtherUserID()->String{
        return otherUserID
    }
    func getSenderID()->String{
        return senderID
    }
    func getSwitchTab()->Bool{
        return switchTab
    }

}
