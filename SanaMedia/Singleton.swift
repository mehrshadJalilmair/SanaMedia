//
//  Singleton.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/17/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Alamofire
import CoreAudio
import AudioToolbox
import AVFoundation

final class Singleton {
    
    //: uniqueSingleton
    private static var uniqueSingleton:Singleton!
    
    //: related to requests from any page
    enum RequestType {
        case get
        case post
    }
    
    //: api addressess
    public let url_static_part = "http://192.168.123.100"
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
        "newest_messages":"/newest_messages/?pagesize=%@&pageindex=%@&token=%@",
        "music_album_childs" : "/music_album_childs/?id=%@",
        "movie_serial_childs" : "/movie_serial_childs/?id=%@",
        "genres": "/genres/?type=%@",
        "movies_by_genre": "/movies_by_genre/?pagesize=%@&pageindex=%@&genre_first_level=%@",
        "images_by_category" : "/images_by_category/?pagesize=%@&pageindex=%@&category_title=%@",
        "ebooks_by_category" : "/ebooks_by_category/?pagesize=%@&pageindex=%@&category_title=%@",
        "musics_by_genre" : "/musics_by_genre/?pagesize=%@&pageindex=%@&genre_first_level=%@",
        "movies_serials_by_genre" : "/movies_serials_by_genre/?pagesize=%@&pageindex=%@&genre_first_level=%@",
        "musics_album_by_genre" : "/musics_album_by_genre/?pagesize=%@&pageindex=%@&genre_first_level=%@",
        "like": "/users/like/",
        "check_like":"/users/like_item/",
        "comment": "/users/comment/",
    
        "image_search":"/image_search/?param=%@&pageindex=%@&pagesize=%@",
        "ebook_search": "/ebook_search/?param=%@&pageindex=%@&pagesize=%@",
        "music_search":"/music_search/?param=%@&pagesize=%@&pageindex=%@",
        "music_album_search": "/music_album_search/?param=%@&pageindex=%@&pagesize=%@",
        "movie_search":"/movie_search/?param=%@&pageindex=%@&pagesize=%@",
        "movie_serial_search": "/movie_serial_search/?param=%@&pageindex=%@&pagesize=%@"
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
        
//        if url_dynamic_part.contains("get_comments")
//        {
//            do
//            {
//                let data = try Data(contentsOf: URL(string: "http://88.99.172.130:8000/get_comments/?type=news&id=129&pageindex=1&pagesize=8")!)
//                print(data.base64EncodedString())
//                let _data = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                print(_data)
//            }
//            catch
//            {
//                
//            }
//        }
        
        if requestType == .get
        {
            Alamofire.request(url).validate().responseJSON { response in
                
                //print(response.result.value)
                if !response.result.isSuccess
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : ["":""] , "func":function , "error":"error"])
                    return
                }
                
                switch response.result {
                case .success:
                    
                    let error:String = "nil"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : response.result.value! , "func":function , "error":error])
                    
//                case .failure(let error):
//                    break
                    
                case .failure(_):
                    break
                }
            }
        }
        else if requestType == RequestType.post
        {
            Alamofire.request(url, method: .post, parameters: body, encoding: URLEncoding.httpBody).validate().responseJSON { (response) in
                
                if !response.result.isSuccess
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : ["":""] , "func":function , "error":"error"])
                    return
                }
                
                switch response.result {
                case .success:
                    
                    let error:String = "nil"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : response.result.value! , "func":function , "error":error])
                    
                case .failure(_):
                    break
//                case .failure(let error):
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: class_), object: nil, userInfo: [ "data" : response.result.value! , "func":function , "error":error])
                }
            }
        }
    }
    
    func headphone()->Bool
    {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0{
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return false
        }
        return false
    }
}
