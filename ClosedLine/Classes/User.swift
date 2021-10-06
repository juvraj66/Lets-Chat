//
//  User.swift
//  ClosedLine
//
//  Created by Juvraj on 8/7/21.
//

import Foundation
import UIKit

class User{
    
    private var userID:String
    private var email0: String
    private var picUrl0: String
    private var addedUser: Bool
    
  
    init(){
        userID = ""
        email0 = ""
        picUrl0 = ""
        addedUser = false
    }
   
    init(userID:String,email:String,picUrl:String, addedUser:Bool){
        email0 = email
        picUrl0 = picUrl
        self.userID = userID
        self.addedUser = addedUser
    }
    
    
    func setUserID(userID:String){
        self.userID = userID
    }
    
    func setEmail(email:String){
        email0 = email
    }
    
    func setPicUrl(picUrl:String){
        picUrl0 = picUrl
    }
    func setAddedUser(addUser:Bool){
        self.addedUser = addUser
    }
    func getUserID()->String{
        return userID
    }
   
    func getEmail()->String{
        return email0
    }
    func getAddedUser()->Bool{
        return addedUser
    }
    func getPicURL()->String{
        return picUrl0
    }

}
