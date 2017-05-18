//
//  Image.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/17/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class Image: NSObject {

    var Category:String!
    var Description:String!
    var URL:String!
    var Title:String!
    var Rate:String!
    var Id:Int!
    var Likes:String!
    
    init(image:AnyObject) {
        
        //: init object by server data
        Category = {
            
            if let Category = image["Category"]
            {
                if Category is NSNull
                {
                    return "-"
                }
                return Category as! String
            }
            return "-"
        }()
        Description = {
            
            if let Description = image["Category"]
            {
                if Description is NSNull
                {
                    return "-"
                }
                return Description as! String
            }
            return "-"
        }()
        Id = {
            
            if let Id = image["Id"]
            {
                if Id is NSNull
                {
                    return 987654321
                }
                return Id as! Int
            }
            return 987654321
        }()
        Likes = {
            
            if let Likes = image["Likes"]
            {
                if Likes is NSNull
                {
                    return "-"
                }
                return Likes as! String
            }
            return "0"
        }()
        Rate = {
            
            if let Rate = image["Rate"]
            {
                if Rate is NSNull
                {
                    return "0"
                }
                return Rate as! String
            }
            return "0"
        }()
        URL = {
            
            if let URL = image["URL"]
            {
                if URL is NSNull
                {
                    return "-"
                }
                return URL as! String
            }
            return ""
        }()
        Title = {
            
            if let Title = image["Title"]
            {
                if Title is NSNull
                {
                    return "-"
                }
                return Title as! String
            }
            return "-"
        }()
    }
}
