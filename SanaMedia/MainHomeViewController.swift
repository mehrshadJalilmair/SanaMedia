//
//  MainHomeViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/16/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class MainHomeViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var mostLikes: DesignableButton!
    @IBOutlet weak var recentDate: DesignableButton!
    
    //table view
    let CellId0 = "VideosCellId"
    let CellId1 = "ImagesCellId"
    let CellId2 = "MusicsCellId"
    let CellId3 = "EbooksCellId"
    
    lazy var tableView : UITableView! =
    {
        let tableView : UITableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(VideosCell.self, forCellReuseIdentifier: self.CellId0)
        tableView.register(MusicsCell.self, forCellReuseIdentifier: self.CellId2)
        tableView.register(ImagesCell.self, forCellReuseIdentifier: self.CellId1)
        tableView.register(EbooksCell.self, forCellReuseIdentifier: self.CellId3)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let sectionHeaderSize = CGFloat(45.0)
    let tableViewSectionsTitle:[String] = ["فیلم ها" , "تصاویر" , "موسیقی" , "کتاب"]
    
    
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
        
        self.view.bringSubview(toFront: navBar)
        configTableView()
        
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
                        
                        self.tableView.reloadData()
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
                        
                        self.tableView.reloadData()
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
                        
                        self.tableView.reloadData()
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
                        
                        self.tableView.reloadData()
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
    
    
    func configTableView()
    {
        view.addSubview(tableView)
        
        //x
        let horizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mostLikes, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: SCREEN_SIZE.height - (self.tabBarController?.tabBar.frame.size.height)! - navBar.frame.size.height - mostLikes.frame.size.height)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: sectionHeaderSize))
        let label = UILabel()
        let line = UIView()
        label.backgroundColor = UIColor.white
        line.backgroundColor = UIColor.orange
        line.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(line)
        headerView.addSubview(label)
        
        //x
        var horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        var verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        //w
        var heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: sectionHeaderSize-2)
        //h
        var widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -4)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        //x
        horizontalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        heightConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 2)
        //h
        widthConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    
        label.textColor = UIColor.black
        label.textAlignment = .right
        label.font = UIFont(name: "American Typewriter" , size: 18)
        label.text = "\(tableViewSectionsTitle[section])"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return tableViewSectionsTitle[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return SCREEN_SIZE.width - SCREEN_SIZE.width/4
            
            
        case 1:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
            
        case 2:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
            
        case 3:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
        default:
            break
        }
        
        return SCREEN_SIZE.width - SCREEN_SIZE.width/4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId0, for: indexPath) as! VideosCell
            cell.newestMovies = self.newestMovies
            cell.newestMoviesIDs = self.newestMoviesIDs
            return cell
            
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId1, for: indexPath) as! ImagesCell
            cell.newestImages = self.newestImages
            cell.newestImagesIDs = self.newestImagesIDs
            return cell
            
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId2, for: indexPath) as! MusicsCell
            cell.newestMusics = self.newestMusics
            cell.newestMusicsIDs = self.newestMusicsIDs
            return cell
            
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId3, for: indexPath) as! EbooksCell
            cell.newestEBooks = self.newestEBooks
            cell.newestEBooksIDs = self.newestMusicsIDs
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
