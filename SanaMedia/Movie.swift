//
//  Movie.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/17/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import Foundation


class Movie: NSObject {
    
    var Title:String!
    var Description:String!
    var Director:String!
    var Sub_Genre:String!
    var Picture_URLS:[String] = [String]() //index by order : 
    //0 = trailer,1 = Background Image,3..|Picture_Url2..5
    var Genre:String!
    var Country:String!
    var Persian_Title:String!
    var Main_URL:String!
    var production_date:String!
    var Rate:String!
    var Duration:String!
    var Id:Int!
    var Likes:String!
    
    init(movie:AnyObject) {
        
        //: init object by server data
        Country = {
            
            if let Country = movie["Country"]
            {
                if Country is NSNull
                {
                    return ""
                }
                return Country as! String
            }
            return "-"
        }()
        Description = {
            
            if let Description = movie["Description"]
            {
                if Description is NSNull
                {
                    return ""
                }
                return Description as! String
            }
            return "-"
        }()
        Director = {
            
            if let Director = movie["Director"]
            {
                if Director is NSNull
                {
                    return ""
                }
                return Director as! String
            }
            return "-"
        }()
        Duration = {
            
            if let Duration = movie["Duration"]
            {
                if Duration is NSNull
                {
                    return ""
                }
                return Duration as! String
            }
            return "-"
        }()
        Genre = {
            
            if let Genre = movie["Genre"]
            {
                if Genre is NSNull
                {
                    return ""
                }
                return Genre as! String
            }
            return "-"
        }()
        Id = {
            
            if let Id = movie["Id"]
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
            
            if let Likes = movie["Likes"]
            {
                if Likes is NSNull
                {
                    return ""
                }
                return Likes as! String
            }
            return "0"
        }()
        Rate = {
            
            if let Rate = movie["Rate"]
            {
                if Rate is NSNull
                {
                    return "0"
                }
                return Rate as! String
            }
            return "0"
        }()
        Sub_Genre = {
            
            if let Sub_Genre = movie["Sub-Genre"]
            {
                if Sub_Genre is NSNull
                {
                    return ""
                }
                return Sub_Genre as! String
            }
            return "-"
        }()
        Title = {
            
            if let Title = movie["Title"]
            {
                if Title is NSNull
                {
                    return ""
                }
                return Title as! String
            }
            return "-"
        }()
        production_date = {
            
            if let production_date = movie["production-date"]
            {
                if production_date is NSNull
                {
                    return ""
                }
                return production_date as! String
            }
            return "-"
        }()
        Main_URL = {
            
            if let Main_URL = movie["Main URL"]
            {
                if Main_URL is NSNull
                {
                    return ""
                }
                return Main_URL as! String
            }
            return ""
        }()
        Persian_Title = {
            
            if let Persian_Title = movie["Persian Title"]
            {
                if Persian_Title is NSNull
                {
                    return ""
                }
                return Persian_Title as! String
            }
            return "-"
        }()
        Picture_URLS.append({
            
            if let trailer = movie["trailer"]
            {
                if trailer is NSNull
                {
                    return ""
                }
                return trailer as! String
            }
            return ""
            }())
        Picture_URLS.append({
            
            if let trailer = movie["Background Image"]
            {
                if trailer is NSNull
                {
                    return ""
                }
                return trailer as! String
            }
            return ""
            }())
        Picture_URLS.append({
            
            if let trailer = movie["Picture Url2"]
            {
                if trailer is NSNull
                {
                    return ""
                }
                return trailer as! String
            }
            return ""
            }())
        Picture_URLS.append({
            
            if let trailer = movie["Picture Url3"]
            {
                if trailer is NSNull
                {
                    return ""
                }
                return trailer as! String
            }
            return ""
            }())
        Picture_URLS.append({
            
            if let trailer = movie["Picture Url4"]
            {
                if trailer is NSNull
                {
                    return ""
                }
                return trailer as! String
            }
            return ""
        }())
        Picture_URLS.append({
            
            if let trailer = movie["Picture Url5"]
            {
                if trailer is NSNull
                {
                    return ""
                }
                return trailer as! String
            }
            return ""
        }())
    }
}
