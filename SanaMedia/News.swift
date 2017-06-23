//
//  News.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/23/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class News: NSObject {

    var Content: String!
    var Rate: String!
    var Likes: String!
    var Title: String!
    var Date: String!
    var Image_Url: String!
    var Type_: String!
    var Id: Int!
    
    init(news:AnyObject) {
        
        //: init object by server data
        Content = {
            
            if let Content = news["Content"]
            {
                if Content is NSNull
                {
                    return "بدون شرح"
                }
                return Content as! String
            }
            return "بدون شرح"
        }()
        Type_ = {
            
            if let Type_ = news["Type"]
            {
                if Type_ is NSNull
                {
                    return "News"
                }
                return Type_ as! String
            }
            return "News"
        }()
        Id = {
            
            if let Id = news["Id"]
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
            
            if let Likes = news["Likes"]
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
            
            if let Rate = news["Rate"]
            {
                if Rate is NSNull
                {
                    return "0"
                }
                return Rate as! String
            }
            return "0"
        }()
        Image_Url = {
            
            if let Image_Url = news["Image Url"]
            {
                if Image_Url is NSNull
                {
                    return "-"
                }
                return Image_Url as! String
            }
            return ""
        }()
        Title = {
            
            if let Title = news["Title"]
            {
                if Title is NSNull
                {
                    return "بدون تیتر"
                }
                return Title as! String
            }
            return "بدون تیتر"
        }()
        Date = {
            
            if let Date = news["Date"]
            {
                if Date is NSNull
                {
                    return "-"
                }
                return Date as! String
            }
            return "-"
        }()
    }
}
