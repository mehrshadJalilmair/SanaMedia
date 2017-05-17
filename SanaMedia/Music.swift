//
//  Music.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/17/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class Music: NSObject {

    var Title:AnyObject!
    var Singer:AnyObject!
    var URL:AnyObject!
    var Picture_URLS:[String] = [String]() //index by order : 1..|Picture_Url1.2
    var Production_Year:AnyObject!
    var Country:AnyObject!
    var Persian_Title:AnyObject!
    var Rate:AnyObject!
    var Duration:AnyObject!
    var Id:Int!
    var Likes:AnyObject!
}
