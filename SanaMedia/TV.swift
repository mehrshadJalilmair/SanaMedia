//
//  TV.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/23/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class TV: NSObject {

    var Description:String!
    var Stream: String!
    var Title:String!
    var Type_:String!
    var Id:Int!
    var Icon:String!
    
    init(tv:AnyObject) {
        
        //: init object by server data
        Description = {
            
            if let Content = tv["Description"]
            {
                if Content is NSNull
                {
                    return ""
                }
                return Content as! String
            }
            return ""
        }()
        Type_ = {
            
            if let Type_ = tv["Type"]
            {
                if Type_ is NSNull
                {
                    return "TV"
                }
                return Type_ as! String
            }
            return "TV"
        }()
        Id = {
            
            if let Id = tv["Id"]
            {
                if Id is NSNull
                {
                    return 987654321
                }
                return Id as! Int
            }
            return 987654321
        }()
        Title = {
            
            if let Title = tv["Title"]
            {
                if Title is NSNull
                {
                    return "-"
                }
                return Title as! String
            }
            return "-"
        }()
        Stream = {
            
            if let Stream = tv["Stream"]
            {
                if Stream is NSNull
                {
                    return ""
                }
                return Stream as! String
            }
            return ""
        }()
        Icon = {
            
            if let Icon = tv["Icon"]
            {
                if Icon is NSNull
                {
                    return ""
                }
                return Icon as! String
            }
            return ""
        }()
    }
}
