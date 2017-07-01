//
//  Singleton.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/17/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Alamofire

final class Singleton {
    
    //: uniqueSingleton
    private static var uniqueSingleton:Singleton!
    
    //: related to requests from any page
    enum RequestType {
        case get
        case post
    }
    
    //: api addressess
    public let url_static_part = "http://88.99.172.130:8000"
    let URLS:[String:String] =
    [
        "newest_movies":"/newest_movies/?pagesize=%@&pageindex=%@&querytype=%@",
        "newest_musics":"/newest_musics/?pagesize=%@&pageindex=%@&querytype=%@",
        "newest_images":"/newest_images/?pagesize=%@&pageindex=%@&querytype=%@",
        "newest_ebooks":"/newest_ebooks/?pagesize=%@&pageindex=%@&querytype=%@",
        "newest_music_album":"/newest_music_album/?pagesize=%@&pageindex=%@&querytype=%@",
        "newest_moive_serials":"/newest_moive_serials/?pagesize=%@&pageindex=%@&querytype=%@",
        "newest_news":"/newest_news/?pagesize=%@&pageindex=%@&querytype=%@",
        "live_shows":"/live_shows/?channel=%@",
        "get_comments":"/get_comments/?type=%@&id=%@&pageindex=%@&pagesize=%@",
        "authenticate": "/users/authenticate/",
        "Registration": "/users/Registration/",
        "logout":"/users/logout/",
        "update_profile":"/users/update_profile/",
        "survay":"/users/survay/",
        "newest_messages":"/newest_messages/?pagesize=%@&pageindex=%@&token=%@"
    ]
    
    //: Singleton implementation
    private init(){}
    static func getInstance()->Singleton
    {
        if uniqueSingleton == nil
        {
            uniqueSingleton = Singleton()
            return uniqueSingleton
            
        }
        return uniqueSingleton
    }
    
    //: handles requests to server
    func requestToServer(requestType:RequestType , requesterData:[String:String] , body:Parameters)
    {
        let url_dynamic_part = requesterData["url_dynamic_part"]!
        let url = url_static_part + url_dynamic_part
        let class_:String = requesterData["class"]!
        let function:String = requesterData["func"]!
        
        if requestType == .get
        {
            Alamofire.request(url).validate().responseJSON { response in
                switch response.result {
                case .success:
                    
                    let error:String = "nil"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : response.result.value! , "func":function , "error":error])
                    
                case .failure(let error):
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : response.result.value! , "func":function , "error":error])
                }
            }
        }
        else if requestType == RequestType.post
        {
            Alamofire.request(url, method: .post, parameters: body, encoding: URLEncoding.httpBody).validate().responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    let error:String = "nil"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : response.result.value! , "func":function , "error":error])
                    
                case .failure(let error):
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : response.result.value! , "func":function , "error":error])
                }
            }
        }
    }
}
