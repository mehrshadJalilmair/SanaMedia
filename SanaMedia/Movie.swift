//
//  Movie.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/17/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import Foundation


class Movie: NSObject {
    
    var Title:AnyObject!
    var Description:AnyObject!
    var Director:AnyObject!
    var Sub_Genre:AnyObject!
    var Picture_URLS:[String] = [String]() //index by order : 
    //0 = trailer,1 = Background Image,3..|Picture_Url1..5
    var Genre:AnyObject!
    var Country:AnyObject!
    var Persian_Title:AnyObject!
    var Main_URL:AnyObject!
    var production_date:AnyObject!
    var Rate:AnyObject!
    var Duration:AnyObject!
    var Id:Int!
    var Likes:AnyObject!
}
