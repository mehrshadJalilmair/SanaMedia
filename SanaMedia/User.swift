//
//  User.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/28/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

final class User {

    let UD = UserDefaults.standard
    
    //: uniqueSingleton
    private static var uniqueSingleton:User!
    
    //: Singleton implementation
    private init()
    {
        if let token = UserDefaults.standard.value(forKey: "token") , let isLoggined = UserDefaults.standard.value(forKey: "isLoggined") , let isRegistered = UserDefaults.standard.value(forKey: "isRegistered")
        {
            self.token = token as! String
            self.isLoggined = isLoggined as! Bool
            self.isRegistered = isRegistered as! Bool
        }
    }
    
    static func getInstance()->User
    {
        if uniqueSingleton == nil
        {
            uniqueSingleton = User()
            return uniqueSingleton
        }
        return uniqueSingleton
    }
    
    //go on...
    var token:String!
    var phone:String!
    var email:String!
    var pass:String!
    
    var isLoggined:Bool = false
    var isRegistered:Bool = false
    
    func isLogin()->Bool
    {
        if UD.value(forKey: "isLoggined") != nil
        {
            if UD.value(forKey: "isLoggined") as! Bool == true
            {
                return true
            }
        }
        return false
    }
    
    func setLogin()
    {
        UD.set(token , forKey:"token")
        UD.set(isLoggined , forKey:"isLoggined")
        UD.set(phone , forKey:"phone")
        UD.set(pass , forKey:"pass")
    }
    
    func setRegister()
    {
        UD.set(token , forKey:"token")
        UD.set(isLoggined , forKey:"isLoggined")
        UD.set(isRegistered , forKey:"isRegistered")
        UD.set(phone , forKey:"phone")
        UD.set(email , forKey:"email")
        UD.set(pass , forKey:"pass")
    }
    
    func logout()
    {
        UD.set(false , forKey:"isLoggined")
    }
}
