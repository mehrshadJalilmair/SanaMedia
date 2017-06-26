//
//  Comment.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/27/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class Comment: NSObject {

    var IP: String!
    var Approved:String!
    var Content:String!
    var rate:String!
    var Date:String!
    var Id:Int!
    
    init(comment:AnyObject) {
        
        //: init object by server data
        IP = {
            
            if let Content = comment["IP"]
            {
                if Content is NSNull
                {
                    return ""
                }
                return Content as! String
            }
            return ""
        }()
        Approved = {
            
            if let Type_ = comment["Approved"]
            {
                if Type_ is NSNull
                {
                    return "False"
                }
                return Type_ as! String
            }
            return "False"
        }()
        Content = {
            
            if let Id = comment["Content"]
            {
                if Id is NSNull
                {
                    return ""
                }
                return Id as! String
            }
            return ""
        }()
        Date = {
            
            if let Title = comment["Date"]
            {
                if Title is NSNull
                {
                    return "-"
                }
                return Title as! String
            }
            return "-"
        }()
        Id = {
            
            if let Stream = comment["Id"]
            {
                if Stream is NSNull
                {
                    return 8327983476
                }
                return Stream as! Int
            }
            return 8327983476
        }()
        rate = {
            
            if let Icon = comment["rate"]
            {
                if Icon is NSNull
                {
                    return "0"
                }
                return Icon as! String
            }
            return "0"
        }()
    }
}
