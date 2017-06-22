//
//  MusicAlbum.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/23/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class MusicAlbum: NSObject {

    var Genres:String!
    var Title:String!
    var Singer:String!
    var URL:String!
    var Picture_URLS:[String] = [String]() //index by order : 1..|Picture_Url1.2
    var Production_Year:String!
    var Country:String!
    var Persian_Title:String!
    var Rate:String!
    var Duration:String!
    var Id:Int!
    var Likes:String!
    
    init(music:AnyObject) {
        
        //: init object by server data
        Picture_URLS.append({
            
            if let Picture_Url1 = music["Picture URL1"]
            {
                if Picture_Url1 is NSNull
                {
                    return ""
                }
                return Picture_Url1 as! String
            }
            return ""
            }())
        Picture_URLS.append({
            
            if let Picture_Url2 = music["Picture URL2"]
            {
                if Picture_Url2 is NSNull
                {
                    return ""
                }
                return Picture_Url2 as! String
            }
            return ""
            }())
        Production_Year = {
            
            if let Production_Year = music["Production Year"]
            {
                if Production_Year is NSNull
                {
                    return "-"
                }
                return Production_Year as! String
            }
            return "-"
        }()
        Id = {
            
            if let Id = music["Id"]
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
            
            if let Likes = music["Likes"]
            {
                if Likes is NSNull
                {
                    return "0"
                }
                return Likes as! String
            }
            return "0"
        }()
        Rate = {
            
            if let Rate = music["Rate"]
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
            
            if let URL = music["URL"]
            {
                if URL is NSNull
                {
                    return ""
                }
                return URL as! String
            }
            return ""
        }()
        Title = {
            
            if let Title = music["Title"]
            {
                if Title is NSNull
                {
                    return "-"
                }
                return Title as! String
            }
            return "-"
        }()
        Singer = {
            
            if let Singer = music["Singer"]
            {
                if Singer is NSNull
                {
                    return "-"
                }
                return Singer as! String
            }
            return "-"
        }()
        Duration = {
            
            if let Duration = music["Duration"]
            {
                if Duration is NSNull
                {
                    return "-"
                }
                return Duration as! String
            }
            return "-"
        }()
        Genres = {
            
            if let Genres = music["Genres"]
            {
                if Genres is NSNull
                {
                    return ""
                }
                return Genres as! String
            }
            return ""
        }()
    }
}
