//
//  Contact.swift
//  ClosedLine
//
//  Created by Juvraj on 3/12/21.
//

import Foundation
import UIKit

class Contact{
    
    // internal same as protected.
    internal var firstName0 = ""
    internal var lastName0 = ""
    internal var bio0 = ""
    internal var picUrl0 = ""
    internal var userID = ""
    
    
    init(){
        userID = ""
        firstName0 = ""
        lastName0 = ""
        bio0 = ""
        picUrl0 = ""
        
    }
   
    init(uID:String,firstName:String, lastName:String,bio:String,picUrl:String){
        userID = uID
        firstName0 = firstName
        lastName0 = lastName
        bio0 = bio
        picUrl0 = picUrl
    }
    
    init(uID:String,firstName:String,picUrl:String){
        userID = uID
        firstName0 = firstName
        picUrl0 = picUrl
    }
    
    
    func setUID(uID:String){
        userID = uID
    }
    func setFirstName(firstName:String){
        firstName0 = firstName
    }
    func setLastName(lastName:String){
        lastName0 = lastName
    }
    func setBio(bio:String){
        bio0 = bio
    }
    func setPicUrl(picUrl:String){
        picUrl0 = picUrl
    }
    func getUID()->String{
        return userID
    }
    func getFirstName()->String{
        return firstName0
    }
    func getLastName()->String{
        return lastName0
    }
    func getBio()->String{
        return bio0
    }
    func getPicUrl()->String{
        return picUrl0
    }
    
}
