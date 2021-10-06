//
//  ContactIDName.swift
//  ClosedLine
//
//  Created by Juvraj on 9/4/21.
//

import Foundation

class ContactIDsName{
    private var contactUserID:String
    private var contactID:String
    private var contactFirstName:String = ""
    
    init(contactID:String,userID:String){
        self.contactID = contactID
        self.contactUserID = userID
    }
    
    func setContactUserID(userID:String){
        contactUserID = userID
    }
    func setContactID(contactID:String){
        self.contactID = contactID
    }
    func setContactFirstName(firstName:String){
        contactFirstName = firstName
    }
    
    func getUserID()->String{
        return contactUserID
    }
    func getContactID()->String{
        return contactID
    }
    func getContactFirstName()->String{
        return contactFirstName
    }


   
    
}
