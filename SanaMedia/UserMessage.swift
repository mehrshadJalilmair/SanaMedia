//
//  UserMessage.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/1/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class UserMessage: NSObject {
    
    var Title:String!
    var Content:String!
    var Creation_Date:String!
    
    init(message:AnyObject) {
        
        //: init object by server data
        Title = {
            
            if let Title = message["Title"]
            {
                if Title is NSNull
                {
                    return ""
                }
                return Title as! String
            }
            return "-"
        }()
        Content = {
            
            if let Content = message["Content"]
            {
                if Content is NSNull
                {
                    return "-"
                }
                return Content as! String
            }
            return "-"
        }()
        Creation_Date = {
            
            if let Creation_Date = message["Creation Date"]
            {
                if Creation_Date is NSNull
                {
                    return "-"
                }
                return Creation_Date as! String
            }
            return "-"
        }()
    }
}
