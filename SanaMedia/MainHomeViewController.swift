//
//  MainHomeViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/16/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class MainHomeViewController: UIViewController {

    //: Main tab vars
    var newestMovies:[Int:Movie] = [Int:Movie]()
    var newestMusics:[Int:Music] = [Int:Music]()
    var newestImages:[Int:Image] = [Int:Image]()
    var newestEBooks:[Int:EBook] = [Int:EBook]()
    
    //: requestType : get|post
    var requestType:Singleton.RequestType!
    
    //: uses in ip dynamic part for page indexing
    var queryType:String = "date"
    var moviesPageSize:Int = 10
    var moviesPageIndex:Int = 1
    var musicsPageSize:Int = 10
    var musicsPageIndex:Int = 1
    var imagesPageSize:Int = 10
    var imagesPageIndex:Int = 1
    var ebooksPageSize:Int = 10
    var ebooksPageIndex:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //: getting init data
        self.getNewest(urlKey: "newest_movies" , function: "getNewestMovies" , pageSize: moviesPageSize , pageIndex:  moviesPageIndex)
        self.getNewest(urlKey: "newest_musics" , function: "getNewestMusics" , pageSize: musicsPageSize , pageIndex:  musicsPageIndex)
        self.getNewest(urlKey: "newest_ebooks" , function: "getNewestEBooks" , pageSize: ebooksPageSize , pageIndex:  ebooksPageIndex)
        self.getNewest(urlKey: "newest_images" , function: "getNewestImages" , pageSize: imagesPageSize , pageIndex:  imagesPageIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //: adding observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: NSNotification.Name(rawValue: "MainHomeViewController"), object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //: removing observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MainHomeViewController"), object: nil)
    }
}

extension MainHomeViewController{
    
    //: handles requests for getting newest movies to server
    func getNewest(urlKey:String , function:String , pageSize:Int , pageIndex:Int)
    {
        requestType = .get
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS[urlKey]!, "\(pageSize)" , "\(pageIndex)" , queryType)
        singleton.requestToServer(requestType: requestType, requesterData: ["url_dynamic_part":url_dynamic_part , "func":function , "class":"MainHomeViewController"], body: [:])
    }
    
    //: handles data when recieved from server
    func notificationReceived(_ notification: Notification)
    {
        guard let data = notification.userInfo?["data"] else { return }
        guard let function = notification.userInfo?["func"] as? String else { return }
        print ("data: \(data)")
        print ("function: \(function)")
    }
}
