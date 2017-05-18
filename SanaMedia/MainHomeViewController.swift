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
    var newestMoviesIDs:[Int] = [Int]()
    var newestMusics:[Int:Music] = [Int:Music]()
    var newestMusicsIDs:[Int] = [Int]()
    var newestImages:[Int:Image] = [Int:Image]()
    var newestImagesIDs:[Int] = [Int]()
    var newestEBooks:[Int:EBook] = [Int:EBook]()
    var newestEBooksIDs:[Int] = [Int]()
    
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
        
        let error = notification.userInfo?["error"] as! String
        let data = notification.userInfo?["data"] as! [String:AnyObject]
        let function = notification.userInfo?["func"] as!String
        
        switch function {
            
        case "getNewestMovies":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestMovies(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
            
        case "getNewestMusics":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestMusics(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
            
        case "getNewestEBooks":
            
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestEBooks(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
            
        case "getNewestImages":
            
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestImages(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
        default:
            break
        }
    }
    
    func getNewestMovies(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let movies:[AnyObject] = data["movie"] as! [AnyObject]
        
        self.moviesPageSize = itemsCount/10 + 1
        self.moviesPageIndex = 1
        
        for movie in movies {
            
            let newMovie = Movie(movie: movie)
            self.newestMovies[newMovie.Id] = newMovie
            self.newestMoviesIDs.append(newMovie.Id)
        }
    }
    
    func getNewestMusics(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let musics:[AnyObject] = data["musics"] as! [AnyObject]
        
        self.musicsPageSize = itemsCount/10 + 1
        self.musicsPageIndex = 1
        
        for music in musics {
            
            let newMusic = Music(music: music)
            self.newestMusics[newMusic.Id] = newMusic
            self.newestMusicsIDs.append(newMusic.Id)
        }
    }
    
    func getNewestEBooks(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let ebooks:[AnyObject] = data["ebooks"] as! [AnyObject]
        
        self.musicsPageSize = itemsCount/10 + 1
        self.musicsPageIndex = 1
        
        for ebook in ebooks {
            
            let newEbook = EBook(ebook: ebook)
            self.newestEBooks[newEbook.Id] = newEbook
            self.newestEBooksIDs.append(newEbook.Id)
        }
    }
    
    func getNewestImages(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let Images:[AnyObject] = data["Images"] as! [AnyObject]
        
        self.imagesPageSize = itemsCount/10 + 1
        self.imagesPageIndex = 1
        
        for image in Images {
            
            let newImage = Image(image: image)
            self.newestImages[newImage.Id] = newImage
            self.newestImagesIDs.append(newImage.Id)
        }
        
    }
}

extension MainHomeViewController{
    
    
}
