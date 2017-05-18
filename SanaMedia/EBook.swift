//
//  OFile.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/17/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class EBook: NSObject {

    var Category:String!
    var Writer:String!
    var URL:String!
    var Publication_Date:String!
    var Title:String!
    var Picture_Url:String!
    var Publisher:String!
    var Rate:String!
    var Preview:String!
    var Id:Int!
    var Likes:String!
    var _Type:String!
    
    init(ebook:AnyObject) {
        
        //: init object by server data
        Category = {
            
            if let Category = ebook["Category"]
            {
                if Category is NSNull
                {
                    return "-"
                }
                return Category as! String
            }
            return "-"
        }()
        Writer = {
            
            
            if let Writer = ebook["Writer"]
            {
                if Writer is NSNull
                {
                    return "-"
                }
                return Writer as! String
            }
            return "-"
        }()
        Publisher = {
            
            if let Publisher = ebook["Publisher"]
            {
                if Publisher is NSNull
                {
                    return "-"
                }
                return Publisher as! String
            }
            return "-"
        }()
        Preview = {
            
            if let Preview = ebook["Preview"]
            {
                if Preview is NSNull
                {
                    return "-"
                }
                return Preview as! String
            }
            return "-"
        }()
        Picture_Url = {
            
            if let Picture_Url = ebook["Picture Url"]
            {
                if Picture_Url is NSNull
                {
                    return "-"
                }
                return Picture_Url as! String
            }
            return "-"
        }()
        Id = {
            
            if let Id = ebook["Id"]
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
            
            if let Likes = ebook["Likes"]
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
            
            if let Rate = ebook["Rate"]
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
            
            if let URL = ebook["URL"]
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
            
            if let Title = ebook["Title"]
            {
                if Title is NSNull
                {
                    return "-"
                }
                return Title as! String
            }
            return "-"
        }()
        Publication_Date = {
            
            if let Publication_Date = ebook["Publication Date"]
            {
                if Publication_Date is NSNull
                {
                    return "-"
                }
                return Publication_Date as! String
            }
            return "-"
        }()
        _Type = {
            
            if let Type = ebook["Type"]
            {
                if Type is NSNull
                {
                    return "-"
                }
                return Type as! String
            }
            return "ebook"
        }()
    }
}
